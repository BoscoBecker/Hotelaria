unit Classe.Pessoa.Controller;

interface

uses Classe.Pessoa, Classe.DataSet,Datasnap.DBClient, FireDAC.Comp.Client;

type
  TPessoaController = class
  public
    constructor Create;
    Destructor Destroy; reintroduce;
    procedure SalvarMemoria(const obj: TPessoa);
    procedure SalvarBanco(const obj: TPessoa);
    procedure DeletarPessoa(const idpessoa: integer);
    function GetDataSetMemoria: TClientDataSet;
    function GetDataSetBanco: TFDQuery;
  end;


implementation

uses dialogs, System.Variants, System.SysUtils;

constructor TPessoaController.Create;
begin
end;

procedure TPessoaController.DeletarPessoa(const idpessoa: integer);
begin
  TSingletonClientDataSet.Instance.DeletarPessoa(idPessoa);
end;

destructor TPessoaController.Destroy;
begin
  Inherited;
end;

function TPessoaController.GetDataSetBanco: TFDQuery;
begin
    result:= TSingletonClientDataSet.Instance.GetDataSetBanco;
end;

function TPessoaController.GetDataSetMemoria: TClientDataSet;
begin
  result:= TSingletonClientDataSet.Instance.GetClientDataSet;
end;

procedure TPessoaController.SalvarBanco(const obj: TPessoa);
begin
  TSingletonClientDataSet.Instance.SaveMemoryToSQLite();
end;

procedure TPessoaController.SalvarMemoria(const obj: TPessoa);
begin
  TSingletonClientDataSet.Instance.AddValuesToDataSet(obj);
end;

end.
