object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'PDV Simples'
  ClientHeight = 220
  ClientWidth = 520
  Position = poScreenCenter
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 220
    Align = alClient
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 24
      Top = 24
      Width = 233
      Height = 28
      Caption = 'Sistema de Vendas (PDV)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnProdutos: TButton
      Left = 24
      Top = 88
      Width = 145
      Height = 41
      Caption = 'Cadastro de Produtos'
      TabOrder = 0
      OnClick = btnProdutosClick
    end
    object btnVendas: TButton
      Left = 184
      Top = 88
      Width = 145
      Height = 41
      Caption = 'Vendas'
      TabOrder = 1
      OnClick = btnVendasClick
    end
    object btnTestarConexao: TButton
      Left = 344
      Top = 88
      Width = 145
      Height = 41
      Caption = 'Testar Conexão'
      TabOrder = 2
      OnClick = btnTestarConexaoClick
    end
  end
end
