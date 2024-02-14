object FrmPessoasCadastradas: TFrmPessoasCadastradas
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsSingle
  ClientHeight = 417
  ClientWidth = 863
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 863
    Height = 376
    Align = alClient
    BorderStyle = bsNone
    DataSource = DsPessoas
    PopupMenu = PopupMenu1
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object pbnlInfoExcluir: TPanel
    Left = 0
    Top = 376
    Width = 863
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 1
    Visible = False
    object Label1: TLabel
      Left = 552
      Top = 16
      Width = 294
      Height = 15
      Caption = 'Selecione uma linha e bot'#227'o direito no grid para excluir.'
    end
  end
  object DsPessoas: TDataSource
    Left = 768
    Top = 224
  end
  object PopupMenu1: TPopupMenu
    Left = 624
    Top = 200
    object PopupMenu11: TMenuItem
      Caption = 'Excluir registro'
      Visible = False
      OnClick = PopupMenu11Click
    end
  end
end
