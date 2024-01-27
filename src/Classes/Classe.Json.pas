unit Classe.Json;

interface

uses JSON,REST.Client;

type
  TJson = class
    public
      constructor Create;
      destructor Destroy ; override;
      procedure CarregarDadosDoJSON;
      procedure ProcessarJsonArray(JsonArray: TJSONArray);
  end;

implementation

uses
  REST.Types, Vcl.Dialogs;

{ TJson }

procedure TJson.CarregarDadosDoJSON;
var
  RestClient: TRESTClient;
  Request: TRESTRequest;
  Response: TRESTResponse;
  JsonArray: TJSONArray;
begin
  RestClient := TRESTClient.Create(nil);
  Request := TRESTRequest.Create(nil);
  Response := TRESTResponse.Create(nil);

  try
    // Configurar o componente TRESTClient com a URL do seu JSON
    RestClient.BaseURL := 'https://run.mocky.io/v3/c20be17a-bc5c-4736-a5e5-dbcff9591b5a';

    // Configurar o componente TRESTRequest
    Request.Client := RestClient;
    Request.Response := Response;

    // Configurar o método e endpoint
    Request.Method := rmGET;
    Request.Resource := '';

    // Executar a solicitação
    Request.Execute;

    // Verificar se a resposta foi bem-sucedida
    if Response.StatusCode = 200 then
    begin
      // Converter a resposta JSON para um array JSON
      JsonArray := TJSONObject.ParseJSONValue(Response.Content) as TJSONArray;

      try
        // Processar o array JSON conforme necessário
        ProcessarJsonArray(JsonArray);
      finally
        JsonArray.Free;
      end;
    end else ShowMessage('Erro ao carregar os dados: ' + Response.StatusText);
  finally
    RestClient.Free;
    Request.Free;
    Response.Free;
  end;

end;

constructor TJson.Create;
begin

end;

destructor TJson.Destroy;
begin
  inherited;
end;

procedure TJson.ProcessarJsonArray(JsonArray: TJSONArray);
var
  i: Integer;
  JsonObject: TJSONObject;
  Codigo, Nome: string;
  Preco: Double;
begin
  for i := 0 to JsonArray.Count - 1 do
  begin
    JsonObject := JsonArray.Items[i] as TJSONObject;

    // Exemplo: Obter valores do JSON
    Codigo := JsonObject.GetValue('codigo').Value;
    Nome := JsonObject.GetValue('nome').Value;
    Preco := StrToFloat(JsonObject.GetValue('preco').Value);

    // Faça o que for necessário com os dados, como adicionar a um TFDQuery, por exemplo
    FDQuery1.Append;
    FDQuery1.FieldByName('Codigo').AsString := Codigo;
    FDQuery1.FieldByName('Nome').AsString := Nome;
    FDQuery1.FieldByName('Preco').AsFloat := Preco;
    FDQuery1.Post;
  end;
end;

end.
