object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Teste pr'#225'tico'
  ClientHeight = 278
  ClientWidth = 836
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnDestroy = FormDestroy
  TextHeight = 15
  object PcPrincipal: TPageControl
    Left = 0
    Top = 0
    Width = 836
    Height = 278
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 832
    ExplicitHeight = 277
    object TabSheet1: TTabSheet
      Caption = 'Parte 1'
      object gbBanco: TGroupBox
        Left = 0
        Top = 89
        Width = 828
        Height = 80
        Align = alTop
        Caption = 'Banco de Dados'
        TabOrder = 0
        ExplicitWidth = 824
        object btnGravarMemoriabanco: TButton
          Left = 49
          Top = 31
          Width = 216
          Height = 25
          Caption = 'Gravar (mem'#243'ria >>banco de dados)'
          TabOrder = 0
          OnClick = btnGravarMemoriabancoClick
        end
        object ExcluirPorId: TButton
          Left = 329
          Top = 31
          Width = 139
          Height = 25
          Caption = 'Excluir por Id'
          TabOrder = 1
        end
        object btnCarregarBancoMemoria: TButton
          Left = 577
          Top = 31
          Width = 232
          Height = 25
          Caption = 'Carregar (banco de dados >> mem'#243'ria)'
          TabOrder = 2
        end
      end
      object gbCadastro: TGroupBox
        Left = 0
        Top = 0
        Width = 828
        Height = 89
        Align = alTop
        Caption = ' Cadastro '
        TabOrder = 1
        ExplicitWidth = 824
        object lblNome: TLabel
          Left = 25
          Top = 21
          Width = 33
          Height = 15
          Caption = 'Nome'
        end
        object Label1: TLabel
          Left = 336
          Top = 21
          Width = 91
          Height = 15
          Caption = 'Data Nascimento'
        end
        object Label2: TLabel
          Left = 528
          Top = 21
          Width = 76
          Height = 15
          Caption = 'Saldo Devedor'
        end
        object edtNome: TEdit
          Left = 25
          Top = 43
          Width = 288
          Height = 23
          TabOrder = 0
        end
        object dtDataNascimento: TDateTimePicker
          Left = 336
          Top = 43
          Width = 129
          Height = 23
          Date = 45317.000000000000000000
          Time = 0.415369085647398600
          TabOrder = 1
        end
        object edtSaldoDevedor: TEdit
          Left = 528
          Top = 42
          Width = 121
          Height = 23
          TabOrder = 2
        end
        object btnAdicionarMemoria: TButton
          Left = 686
          Top = 41
          Width = 139
          Height = 25
          Caption = 'Adicionar na mem'#243'ria'
          TabOrder = 3
          OnClick = btnAdicionarMemoriaClick
        end
      end
      object MostrarPessoasMemoria: TButton
        Left = 49
        Top = 192
        Width = 216
        Height = 25
        Caption = 'Mostrar "pessoas" em mem'#243'ria'
        TabOrder = 2
        OnClick = MostrarPessoasMemoriaClick
      end
      object Button1: TButton
        Left = 577
        Top = 192
        Width = 216
        Height = 25
        Caption = 'Mostrar "pessoas" no Banco'
        TabOrder = 3
        OnClick = Button1Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Parte 2'
      ImageIndex = 1
      object pnlTopBuscar: TPanel
        Left = 0
        Top = 0
        Width = 828
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object btnBuscar: TButton
          Left = 16
          Top = 10
          Width = 75
          Height = 25
          Caption = '&Buscar'
          TabOrder = 0
          OnClick = btnBuscarClick
        end
        object LoadingParte2: TActivityIndicator
          Left = 792
          Top = 3
        end
      end
      object DBGrid1: TDBGrid
        Left = 0
        Top = 41
        Width = 828
        Height = 207
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
  end
  object RESTClient1: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 484
    Top = 218
  end
end
