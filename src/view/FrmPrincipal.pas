unit FrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.WinXCtrls, Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,Classe.Connection,
  REST.Types, Data.Bind.Components, Data.Bind.ObjectScope, REST.Client;

type
  TFrmMainPrincipal = class(TForm)
    PcPrincipal: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    pnlTopBuscar: TPanel;
    btnBuscar: TButton;
    gbBanco: TGroupBox;
    gbCadastro: TGroupBox;
    edtNome: TEdit;
    lblNome: TLabel;
    dtDataNascimento: TDateTimePicker;
    edtSaldoDevedor: TEdit;
    btnAdicionarMemoria: TButton;
    Label1: TLabel;
    Label2: TLabel;
    btnGravarMemoriabanco: TButton;
    ExcluirPorId: TButton;
    btnCarregarBancoMemoria: TButton;
    MostrarPessoasMemoria: TButton;
    DBGrid1: TDBGrid;
    Button1: TButton;
    dsRest: TDataSource;
    LoadingParte2: TActivityIndicator;
    lblLoading: TLabel;
    Panel2: TPanel;
    Image1: TImage;
    procedure btnAdicionarMemoriaClick(Sender: TObject);
    procedure btnGravarMemoriabancoClick(Sender: TObject);
    procedure MostrarPessoasMemoriaClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure LoadingImage;
    Procedure ClearFields;
    procedure ExcluirPorIdClick(Sender: TObject);
    procedure btnCarregarBancoMemoriaClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1CellClick(Column: TColumn);
  end;

var
  FrmMainPrincipal: TFrmMainPrincipal = nil;

implementation

{$R *.dfm}

uses Classe.Pessoa,FrmPessoas,Classe.DataSet,Classe.Request.Json, System.Threading;

procedure TFrmMainPrincipal.btnAdicionarMemoriaClick(Sender: TObject);
var
  LPessoa:TPessoa;
begin
  LPessoa:= TPessoa.Create;
  try
    LPessoa.SetNome(edtNome.Text);
    LPessoa.SetDataNascimento(dtDataNascimento.Date);
    LPessoa.SetSaldoDevedor(StrToFloatDef(edtSaldoDevedor.Text,0));
    LPessoa.Salvarmemoria(LPessoa);
  finally
    FreeAndNil(LPessoa);
    LoadingParte2.Animate:= False;
    ClearFields;
    edtNome.SetFocus;
  end;
end;

procedure TFrmMainPrincipal.btnBuscarClick(Sender: TObject);
var
  FThread: TThread;
begin
  LoadingParte2.Visible:= True;
  LoadingParte2.Animate:= True;
  lblLoading.Visible:= True;
  dsRest.DataSet:= nil;
  FThread := TThread.CreateAnonymousThread(
  procedure
  var
    LRequestJson: TRESTJson;
  begin
    try
      LRequestJson:= TRESTJson.Create;
      LRequestJson.CarregarDadosDoJSON;
      TThread.Synchronize(TThread.CurrentThread, LoadingImage);
      TThread.Queue(nil, procedure
      begin
        dsRest.DataSet:= TSingletonClientDataSet.Instance.GetDataSetRest;
      end);
      LoadingParte2.Animate:= False;
      LoadingParte2.Visible:= False;
      lblLoading.Visible:= False;
    finally
    end;
  end);
  FThread.Start;
end;

procedure TFrmMainPrincipal.btnCarregarBancoMemoriaClick(Sender: TObject);
begin
  TSingletonClientDataSet.Instance.SQLiteToMemory;
end;

procedure TFrmMainPrincipal.btnGravarMemoriabancoClick(Sender: TObject);
var
  LPessoa:TPessoa;
begin
  LPessoa:= TPessoa.Create;
  try
    LPessoa.SetNome(edtNome.Text);
    LPessoa.SetDataNascimento(dtDataNascimento.Date);
    LPessoa.SetSaldoDevedor(StrToFloatDef(edtNome.Text,0));
    LPessoa.Salvarmemoria(nil).SalvarBanco;
  finally
    FreeAndNil(LPessoa);
  end;
end;

procedure TFrmMainPrincipal.Button1Click(Sender: TObject);
var
  LPessoa:TPessoa;
begin
  LPessoa:= TPessoa.Create;
  try
    FrmPessoasCadastradas:= TFrmPessoasCadastradas.Create(nil);
    try
      FrmPessoasCadastradas.DsPessoas.DataSet:= NIl;
      FrmPessoasCadastradas.DsPessoas.DataSet:=  LPessoa.GetDataSetPessoasQuery;
      FrmPessoasCadastradas.Caption:= 'Pessoas cadastradas (Banco)';
      FrmPessoasCadastradas.ShowModal;
    finally
      FreeAndNil(FrmPessoasCadastradas);
    end;
  finally
   FreeAndNil(LPessoa);
  end;
end;

procedure TFrmMainPrincipal.ClearFields;
begin
  edtNome.Clear;
  edtSaldoDevedor.Clear;
end;

procedure TFrmMainPrincipal.DBGrid1CellClick(Column: TColumn);
begin
  if Column.FieldName = 'imagem' then
  begin
   Image1.Picture.LoadFromStream(Column.Field.DataSet.CreateBlobStream(Column.Field, bmRead));
  end;
end;

procedure TFrmMainPrincipal.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Imagem: TImage;
begin
  if Column.FieldName = 'imagem' then
  begin
    Imagem := TImage.Create(nil);
    try
      if not Column.Field.IsNull then
        Imagem.Picture.LoadFromStream(Column.Field.DataSet.CreateBlobStream(Column.Field, bmRead));
      DBGrid1.Canvas.StretchDraw(Rect, Imagem.Picture.Graphic);
    finally
      Imagem.Free;
    end;
  end;
end;

procedure TFrmMainPrincipal.ExcluirPorIdClick(Sender: TObject);
var
  LPessoa:TPessoa;
begin
  LPessoa:= TPessoa.Create;
  try
    FrmPessoasCadastradas:= TFrmPessoasCadastradas.Create(nil);
    try
      FrmPessoasCadastradas.DsPessoas.DataSet:= NIl;
      FrmPessoasCadastradas.DsPessoas.DataSet:=  LPessoa.GetDataSetPessoasQuery;
      FrmPessoasCadastradas.Caption:= 'Pessoas cadastradas (Banco)';
      FrmPessoasCadastradas.pbnlInfoExcluir.visible:= True;
      FrmPessoasCadastradas.PopupMenu11.visible:= True;
      FrmPessoasCadastradas.ShowModal;
    finally
      FreeAndNil(FrmPessoasCadastradas);
    end;
  finally
   FreeAndNil(LPessoa);
  end;
end;

procedure TFrmMainPrincipal.FormDestroy(Sender: TObject);
begin
   TSingletonClientDataSet.Instance.Destroy;
   TConnection.Instance.Destroy;
end;

procedure TFrmMainPrincipal.LoadingImage;
begin
  LoadingParte2.repaint;
end;

procedure TFrmMainPrincipal.MostrarPessoasMemoriaClick(Sender: TObject);
var
  LPessoa:TPessoa;
begin
  LPessoa:= TPessoa.Create;
  try
    FrmPessoasCadastradas:= TFrmPessoasCadastradas.Create(nil);
    try
      FrmPessoasCadastradas.DsPessoas.DataSet:= NIl;
      FrmPessoasCadastradas.DsPessoas.DataSet:=  LPessoa.GetDataSetPessoas;
      FrmPessoasCadastradas.Caption:= 'Pessoas cadastradas (mem�ria)';
      FrmPessoasCadastradas.ShowModal;
    finally
      FreeAndNil(FrmPessoasCadastradas);
    end;
  finally
   FreeAndNil(LPessoa);
  end;
end;

end.
