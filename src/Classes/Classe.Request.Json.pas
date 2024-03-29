﻿unit Classe.Request.Json;

interface

uses JSON,REST.Client,UrlMon  ;

const URI = 'https://run.mocky.io/v3/c20be17a-bc5c-4736-a5e5-dbcff9591b5a';

type
  TRESTJson = class
    private
      LJsonArray: TJSONArray;
      procedure ProcessarJsonArray(JsonArray: TJSONArray);
      function ProcessarCaracteristicas(const CaracteristicasArray: TJSONArray):String;
      function ObterNomeDoArquivoDaURL(const URL: string): string;
      function DownloadFile(SourceFile, DestFile: string): Boolean;
   public
      procedure CarregarDadosDoJSON;
     constructor Create;
     destructor Destroy; override;
  end;

implementation

uses
  REST.Types, Vcl.Dialogs, System.SysUtils, classe.DataSet, System.Classes,
  Vcl.ExtCtrls;


procedure TRESTJson.CarregarDadosDoJSON;
var
  LRestClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
begin
  LRestClient := TRESTClient.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);

  try
    LRestClient.BaseURL := URI;
    LRequest.Client := LRestClient;
    LRequest.Response := LResponse;
    LRequest.Method := rmGET;
    LRequest.Resource := '';
    LRequest.Execute;

    if Trim(LResponse.Content) = '' then Exit;
    if LResponse.StatusCode = 200 then
    begin
      LJsonArray := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONArray;
      ProcessarJsonArray(LJsonArray);
    end else ShowMessage('Erro ao carregar os dados: ' + LResponse.StatusText);
  finally
    FreeAndNil(LRestClient);
    FreeAndNil(LRequest);
    FreeAndNil(LResponse);
  end;
end;

constructor TRESTJson.Create;
begin
end;

destructor TRESTJson.Destroy;
begin
  inherited;
  if LJsonArray <> nil then
    FreeAndNil(LJsonArray);
end;

function TRESTJson.DownloadFile(SourceFile, DestFile: string): Boolean;
begin
  try
    Result := UrlDownloadToFile(nil, PChar(SourceFile), PChar(DestFile),
    0, nil) = 0;
  except
    Result := False;
  end;
end;

function TRESTJson.ObterNomeDoArquivoDaURL(const URL: string): string;
var
  UltimaBarra: Integer;
begin
  UltimaBarra := LastDelimiter('/', URL);
  if UltimaBarra > 0 then
    Result := Copy(URL, UltimaBarra + 1, Length(URL) - UltimaBarra)
  else
    Result := URL;
end;

function TRESTJson.ProcessarCaracteristicas(const CaracteristicasArray: TJSONArray): String;
var
  LCaracteristica: TJSONObject;
  LNome: string ;
begin
  Try
    for var i := 0 to CaracteristicasArray.Count - 1 do
    begin
      LCaracteristica := CaracteristicasArray.Items[i] as TJSONObject;
      LNome := LNome + ' '+LCaracteristica.GetValue('nome').Value +', ';
    end;
    result:= Lnome;
  Finally
    FreeAndNil(LCaracteristica);
  End;
end;

procedure TRESTJson.ProcessarJsonArray(JsonArray: TJSONArray);
var
  LJsonObject: TJSONObject;
  LCodigo, LNome: string;
  LPreco: Double;
  Lhospedes,
  LCaracteristica: String;
  LCaracteristicasArray: TJSONArray;
  LImagem,Lcaminho: String;
begin

  { TODO 5 -oJoão Bosco -cWarning :
  Verifico se é <> nil, pois o delphi é problemático com valotes null em Json
  Gera Access violation, pois se é null para o Delphi é NIl ...}

  try
    for var i := 0 to JsonArray.Count - 1 do
    begin
      LJsonObject := JsonArray.Items[i] as TJSONObject;

      if LJsonObject.GetValue('codigo') <> nil then
        LCodigo := LJsonObject.GetValue('codigo').AsType<string>;
      if LJsonObject.GetValue('nome') <> nil then
        LNome := LJsonObject.GetValue('nome').AsType<string>;
      if LJsonObject.GetValue('preco') <> nil then
        LPreco := LJsonObject.GetValue('preco').AsType<Double>;
      if LJsonObject.GetValue('caracteristica') <> nil then
        LCaracteristica := LJsonObject.GetValue('caracteristicas').AsType<string>;
      LJsonObject := JsonArray.Items[i] as TJSONObject;
      if LJsonObject.TryGetValue<TJSONArray>('caracteristicas', LCaracteristicasArray) then
        LCaracteristica:=  ProcessarCaracteristicas(LCaracteristicasArray);

      if LJsonObject.GetValue('hospedes') <> nil then
        Lhospedes := LJsonObject.GetValue('hospedes').AsType<string>;

      if LJsonObject.GetValue('img') <> nil then
        LImagem := LJsonObject.GetValue('img').AsType<string>;

      if DirectoryExists(GetCurrentDir()+ '\Imagens\') then
        ForceDirectories(GetCurrentDir()+ '\Imagens\');

      Lcaminho:= GetCurrentDir()+ '\Imagens\'+ExtractFileName(ObterNomeDoArquivoDaURL(LImagem));
      DownloadFile(LImagem, Lcaminho);
      TSingletonClientDataSet.Instance.AddValuesToDataSet(LCodigo, Lnome, LCaracteristica,Lhospedes, LPreco, Lcaminho);
    end;
  finally
  end;

end;

end.
