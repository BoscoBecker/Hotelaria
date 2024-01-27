program TesteHotelaria;

uses
  Vcl.Forms,
  FrmPrincipal in 'view\FrmPrincipal.pas' {FrmMainPrincipal},
  FrmPessoas in 'view\FrmPessoas.pas' {FrmPessoasCadastradas},
  Classe.DataSet in 'Classes\Classe.DataSet.pas',
  Classe.Pessoa.Controller in 'Classes\Classe.Pessoa.Controller.pas',
  Classe.Pessoa in 'Classes\Classe.Pessoa.pas',
  Classe.Connection in 'Conenction\Classe.Connection.pas',
  Classe.Request.Json in 'Classes\Classe.Request.Json.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMainPrincipal, FrmMainPrincipal);
  Application.Run;
end.
