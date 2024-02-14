unit Classe.DataSet;

interface

uses
  Data.DB, Datasnap.DBClient, Classe.Pessoa,System.SysUtils, classe.Connection,
  FireDAC.Comp.Client;

type
  TSingletonClientDataSet = class
  private
    FClientDataSet: TClientDataSet;
    FClientDataSetRestJson: TClientDataSet;
    Field: TField;
    FQuery: TFDquery;
    class var FInstance: TSingletonClientDataSet;
    function GetSQLInsert: String;
    function GetSQLDeletePessoa: string;
    procedure CreateDataSets;
  public
    constructor Create;
    Destructor Destroy;override;

    procedure AddValuesToDataSet(const obj: TPessoa);overload;
    procedure AddValuesToDataSet(const codigo, nome,caracteristica, hospedes: string; preco: double; Imagem: String); overload;
    procedure AddValuesToDataSet(const Nome: string ; DataNascimento: TDate; SaldoDevedor: double); overload;
    procedure SaveMemoryToSQLite;
    procedure SQLiteToMemory;
    procedure DeletarPessoa(const idPessoa: integer);
    class function Instance: TSingletonClientDataSet;
    function GetClientDataSet: TClientDataSet;
    function GetDataSetBanco: TFDquery;
    function GetDataSetRest: TClientDataSet;
    
    property ClientDataSet: TClientDataSet read GetClientDataSet;
    property ClientDataSetRestJson: TClientDataSet read FClientDataSetRestJson;
    
  end;

implementation

uses
  Vcl.Dialogs, Datasnap.DSIntf;

class function TSingletonClientDataSet.Instance: TSingletonClientDataSet;
begin 
  if not Assigned(FInstance) then
  begin
    FInstance:= TSingletonClientDataSet.Create;
    FInstance.CreateDataSets;
  end;   
  result:= FInstance ;
end;   

procedure TSingletonClientDataSet.AddValuesToDataSet(const obj: TPessoa);
begin
  if obj = nil  then Exit;
  FClientDataSet.Append;
  FClientDataSet.fieldBYName('Nome').AsString:= obj.Nome;
  FClientDataSet.FieldByName('DataNascimento').AsDateTime:= obj.DataNascimento;
  FClientDataSet.FIeldByName('SaldoDevedor').AsFloat:= obj.SaldoDevedor;
  FClientDataSet.Post;
end;

procedure TSingletonClientDataSet.AddValuesToDataSet(const codigo, nome, caracteristica, hospedes: string; preco: double; Imagem: String);
begin
  FClientDataSetRestJson.Append;
  FClientDataSetRestJson.fieldBYName('codigo').AsString:= codigo;
  FClientDataSetRestJson.FieldByName('nome').AsString:= nome;
  FClientDataSetRestJson.FIeldByName('caracteristica').AsString:= caracteristica;
  FClientDataSetRestJson.FIeldByName('hospedes').AsString:= hospedes;
  FClientDataSetRestJson.FIeldByName('preco').AsFloat:= preco;
  TBlobField(FClientDataSetRestJson.FIeldByName('imagem')).LoadFromFile(Imagem);
  FClientDataSetRestJson.Post;
end;

procedure TSingletonClientDataSet.AddValuesToDataSet(const Nome: string ; DataNascimento: TDate; SaldoDevedor: double);
begin
  FClientDataSet.Append;
  FClientDataSet.fieldBYName('Nome').AsString:= Nome;
  FClientDataSet.FieldByName('DataNascimento').AsDateTime:= DataNascimento;
  FClientDataSet.FIeldByName('SaldoDevedor').AsFloat:= SaldoDevedor;
  FClientDataSet.Post;
end;

constructor TSingletonClientDataSet.Create;
begin   
end;

procedure TSingletonClientDataSet.CreateDataSets;
begin
  // Apenas Memória
  FClientDataSet:= TClientDataSet.Create(nil);
  FClientDataSet.Close;

  Field := TStringField.Create(FClientDataSet);
  Field.FieldName := 'Nome';
  Field.Size := 50;
  FClientDataSet.FieldDefs.Add('Nome', ftString, 50);

  Field := TDateField.Create(FClientDataSet);
  Field.FieldName := 'DataNascimento';
  FClientDataSet.FieldDefs.Add('DataNascimento', ftDate);

  Field:= TCurrencyField.Create(FClientDataSet);
  Field.FieldName := 'SaldoDevedor';
  FClientDataSet.FieldDefs.Add('SaldoDevedor', ftCurrency);


  FClientDataSet.CreateDataSet;
  FClientDataSet.EmptyDataSet;    
  
  /// Rest Memória
  FClientDataSetRestJson:= TClientDataSet.Create(nil);
  FClientDataSetRestJson.Close;

  Field := TStringField.Create(FClientDataSetRestJson);
  Field.FieldName := 'codigo';
  Field.Size := 50;
  FClientDataSetRestJson.FieldDefs.Add('codigo', ftString, 50);

  Field := TStringField.Create(FClientDataSetRestJson);
  Field.FieldName := 'nome';
  FClientDataSetRestJson.FieldDefs.Add('nome', ftString,100);

  Field:= TCurrencyField.Create(FClientDataSetRestJson);
  Field.FieldName := 'preco';
  FClientDataSetRestJson.FieldDefs.Add('preco', ftCurrency);

  Field := TStringField.Create(FClientDataSetRestJson);
  Field.FieldName := 'caracteristica';
  FClientDataSetRestJson.FieldDefs.Add('caracteristica', ftString,200);

  Field := TStringField.Create(FClientDataSetRestJson);
  Field.FieldName := 'hospedes';
  FClientDataSetRestJson.FieldDefs.Add('hospedes', ftString,50);

  Field:= TBlobField.Create(FClientDataSetRestJson);
  Field.FieldName:= 'imagem';
  FClientDataSetRestJson.FieldDefs.Add('imagem', ftBlob);           
  
  FClientDataSetRestJson.CreateDataSet;
  FClientDataSetRestJson.EmptyDataSet;        
end;

procedure TSingletonClientDataSet.DeletarPessoa(const idPessoa: integer);
var
  LCommand : TFDcommand;
begin
  LCommand:= TFDCommand.Create(nil);
  try
    try
      LCommand.Connection:= TConnection.Instance.GetConnection;  
      TConnection.Instance.Transaction.StartTransaction;
      LCommand.CommandText.Clear;
      LCommand.CommandText.Add(GetSQLDeletePessoa);
      LCommand.ParamByName('ID').AsInteger:= idPessoa;
      LCommand.Execute();         
    except on E: Exception do
      begin
        TConnection.Instance.Transaction.Rollback;
        ShowMessage('Classe do erro:' +E.ClassName+' Erro ao salvar os dados : '+E.Message+ ' Linha:' +E.StackTrace);
      end;
    end;
    TConnection.Instance.Transaction.Commit;
  finally
    FreeAndNil(LCommand);
  end;
  TConnection.Instance.Disconnect;
end;

destructor TSingletonClientDataSet.Destroy;
begin
  inherited;
  if FClientDataSet <> nil then FreeAndNil(FClientDataSet);
  if FClientDataSetRestJson <> nil then FreeAndNil(FClientDataSetRestJson);  
  if FQuery <> nil then FreeAndNil(FQuery);
end;


procedure TSingletonClientDataSet.SaveMemoryToSQLite;
var
  LCommand : TFDcommand;
begin
  LCommand:= TFDCommand.Create(nil);
  LCommand.Connection:= TConnection.Instance.GetConnection;

  TConnection.Instance.Transaction.StartTransaction;
  LCommand.CommandText.Clear;
  LCommand.CommandText.Add(GetSQLInsert);
  try
    try
      FClientDataSet.open;
      FClientDataSet.First;
      while not FInstance.FClientDataSet.eof do
      begin
        LCommand.ParamByName('NOME').AsString:= FClientDataSet.FieldByName('Nome').AsString;
        LCommand.ParamByName('DATANASCIMENTO').AsDateTime:= FClientDataSet.FieldByName('DataNascimento').AsDateTime;
        LCommand.ParamByName('SALDODEVEDOR').AsFloat:= FClientDataSet.FieldByName('SaldoDevedor').AsFloat;
        LCommand.Execute();
        FClientDataSet.Next;
      end;
    Except on E : Exception do
      Begin
        TConnection.Instance.Transaction.Rollback;
        ShowMessage('Classe do erro:' +E.ClassName+' Erro ao salvar os dados : '+E.Message+ ' Linha:' +E.StackTrace);
      End;
    end;
    TConnection.Instance.Transaction.Commit;
  finally
    FreeAndNil(LCommand);
  end;
  TConnection.Instance.Disconnect;
end;

procedure TSingletonClientDataSet.SQLiteToMemory;
var
  LQueryBanco: TFDQuery;
begin
  LQueryBanco:= TFDQuery.Create(nil);
  try
    LQueryBanco.Connection:= TConnection.Instance.GetConnection;
    LQueryBanco.SQL.Clear;
    LQueryBanco.SQL.Add('SELECT * FROM PESSOAS');
    LQueryBanco.Open();
    LQueryBanco.First;
    while not LQueryBanco.eof do
    begin
      AddValuesToDataSet(LQueryBanco.FieldByName('nome').AsString,
                         LQueryBanco.FieldByName('DataNascimento').AsDateTime,
                         LQueryBanco.FieldByName('saldodevedor').AsFloat);
                          
       LQueryBanco.Next;
    end;    
  finally
    FreeAndNil(LQueryBanco);
  end;

end;

function TSingletonClientDataSet.GetClientDataSet: TClientDataSet;
begin
  result := FClientDataSet;
end;

function TSingletonClientDataSet.GetDataSetBanco: TFDquery;
begin
  FQuery:=TFDQuery.Create(nil);
  FQuery.Connection:= TConnection.Instance.GetConnection;
  FQuery.SQL.Clear;
  FQuery.SQL.Add('SELECT * FROM PESSOAS');
  FQuery.Open();
  result:= FQuery;
end;

function TSingletonClientDataSet.GetDataSetRest: TClientDataSet;
begin
  result:= FInstance.FClientDataSetRestJson;
end;

function TSingletonClientDataSet.GetSQLDeletePessoa: string;
begin
  result:= 'DELETE FROM PESSOAS where ID = :ID';
end;

function TSingletonClientDataSet.GetSQLInsert: String;
begin
  result:=
    'INSERT INTO PESSOAS (NOME,DATANASCIMENTO,SALDODEVEDOR)'+
    'VALUES (:NOME,:DATANASCIMENTO,:SALDODEVEDOR)';
end;


end.






