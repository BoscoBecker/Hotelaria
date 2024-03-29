﻿unit Classe.Services.Pessoa;

interface

uses Classe.Pessoa, Data.DB;

type
  TServiceProduto = class
    public class procedure SalvaNaMemoria(const nome: string; dataNascimento: TDate; SaldoDevedor: Double; SalvarBanco: boolean=False); static ;
    public class function MostrarPessoasMemoria: TDataSet; static ;
    public class function GetDataSetPessoasQuery: TDataSet; static ;
  end;

implementation

uses
  System.SysUtils;

class function TServiceProduto.GetDataSetPessoasQuery: TDataSet;
var
  LPessoa:TPessoa;
begin
  LPessoa:= TPessoa.Create;
  try
     result:=  LPessoa.GetDataSetPessoasQuery;
  finally
   FreeAndNil(LPessoa);
  end;
end;

class function TServiceProduto.MostrarPessoasMemoria: TDataSet;
var
  LPessoa:TPessoa;
begin
  LPessoa:= TPessoa.Create;
  try
     result:=  LPessoa.GetDataSetPessoas;
  finally
   FreeAndNil(LPessoa);
  end;
end;

class procedure TServiceProduto.SalvaNaMemoria(const nome: string; dataNascimento: TDate; SaldoDevedor: Double; SalvarBanco: boolean);
var
   LPessoa:TPessoa;
begin
  LPessoa:= TPessoa.Create;
  try
    LPessoa.SetNome(nome);
    LPessoa.SetDataNascimento(dataNascimento);
    LPessoa.SetSaldoDevedor(SaldoDevedor);
    LPessoa.Salvarmemoria(LPessoa);
    if SalvarBanco then
    Lpessoa.SalvarBanco;
  finally
    FreeAndNil(LPessoa);
  end;
end;

end.
