unit Classe.Pessoa;

interface

uses
  Datasnap.DBClient, FireDAC.Comp.Client;

type
  TPessoa = class
    private
      FNome: String;
      FDataNascimento: TDate;
      FSaldoDevedor: Double;
    public
      procedure SetNome(const Value: String);
      procedure SetDataNascimento(const Value: TDate);
      procedure SetSaldoDevedor(const Value: Double);

      property Nome: String read FNome write SetNome;
      property DataNascimento: TDate read FDataNascimento write SetDataNascimento;
      property SaldoDevedor: Double read FSaldoDevedor write SetSaldoDevedor;

      function Salvarmemoria(const obj: TPessoa): TPessoa;
      function SalvarBanco: TPessoa;
      procedure DeletarPessoa(const idpessoa: integer);

      function GetDataSetPessoas: TClientDataSet;
      function GetDataSetPessoasQuery: TFDQuery;
      constructor Create;
      destructor destroy;
  end;




implementation

uses  classe.Pessoa.Controller,System.SysUtils;

constructor TPessoa.Create;
begin
end;

procedure TPessoa.DeletarPessoa(const idpessoa: integer);
var
  LObjController: TPessoaController;
begin
  LObjController:= TPessoaController.Create;
  try
    LObjController.DeletarPessoa(idpessoa);
  finally
    FreeAndNil(LObjController);
  end;
end;

destructor TPessoa.destroy;
begin
  Inherited;
end;

function TPessoa.GetDataSetPessoasQuery: TFDQuery;
var
  LObjController: TPessoaController;
begin
  LObjController:= TPessoaController.Create;
  try
    result:= LObjController.GetDataSetBanco
  finally
    FreeAndNil(LObjController);
  end;

end;

function TPessoa.GetDataSetPessoas: TClientDataSet;
var
  LObjController: TPessoaController;
begin
  LObjController:= TPessoaController.Create;
  try
    result:= LObjController.GetDataSetMemoria
  finally
    FreeAndNil(LObjController);
  end;
end;

procedure TPessoa.SetDataNascimento(const Value: TDate);
begin
  FDataNascimento := Value;
end;

procedure TPessoa.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TPessoa.SetSaldoDevedor(const Value: Double);
begin
  FSaldoDevedor := Value;
end;

function TPessoa.SalvarBanco: TPessoa;
var
  LObjController: TPessoaController;
begin
  LObjController:= TPessoaController.Create;
  try
    LObjController.SalvarBanco(self);
  finally
    FreeAndNil(LObjController)
  end;
end;

function TPessoa.Salvarmemoria(const obj: TPessoa):TPessoa;
var
  LObjController: TPessoaController;
begin
  LObjController:= TPessoaController.Create;
  try
    LObjController.SalvarMemoria(obj);
  finally
    FreeAndNil(LObjController)
  end;
end;


end.
