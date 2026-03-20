object frmVendas: TfrmVendas
  Left = 0
  Top = 0
  Caption = 'Vendas'
  ClientHeight = 760
  ClientWidth = 980
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlVenda: TPanel
    Left = 0
    Top = 0
    Width = 980
    Height = 72
    Align = alTop
    TabOrder = 0
    object lblCliente: TLabel
      Left = 24
      Top = 14
      Width = 38
      Height = 15
      Caption = 'Cliente'
    end
    object lblData: TLabel
      Left = 760
      Top = 14
      Width = 24
      Height = 15
      Caption = 'Data'
    end
    object cbCliente: TComboBox
      Left = 24
      Top = 35
      Width = 720
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object edtDataVenda: TEdit
      Left = 760
      Top = 35
      Width = 185
      Height = 23
      ReadOnly = True
      TabOrder = 1
    end
  end
  object pnlItem: TPanel
    Left = 0
    Top = 72
    Width = 980
    Height = 132
    Align = alTop
    TabOrder = 1
    object lblIdProduto: TLabel
      Left = 24
      Top = 12
      Width = 49
      Height = 15
      Caption = 'Produto'
    end
    object lblNomeProduto: TLabel
      Left = 141
      Top = 12
      Width = 37
      Height = 15
      Caption = 'Nome'
    end
    object lblQtd: TLabel
      Left = 560
      Top = 12
      Width = 67
      Height = 15
      Caption = 'Quantidade'
    end
    object lblValorUnitario: TLabel
      Left = 648
      Top = 12
      Width = 74
      Height = 15
      Caption = 'Valor Unitário'
    end
    object lblTotalItem: TLabel
      Left = 776
      Top = 12
      Width = 54
      Height = 15
      Caption = 'Total Item'
    end
    object edtIdProduto: TEdit
      Left = 24
      Top = 33
      Width = 98
      Height = 23
      TabOrder = 0
    end
    object btnBuscarProduto: TButton
      Left = 128
      Top = 33
      Width = 95
      Height = 23
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnBuscarProdutoClick
    end
    object edtNomeProduto: TEdit
      Left = 231
      Top = 33
      Width = 314
      Height = 23
      ReadOnly = True
      TabOrder = 2
    end
    object edtQtd: TEdit
      Left = 560
      Top = 33
      Width = 73
      Height = 23
      TabOrder = 3
      Text = '1'
      OnChange = edtQtdChange
    end
    object edtValorUnitario: TEdit
      Left = 648
      Top = 33
      Width = 113
      Height = 23
      ReadOnly = True
      TabOrder = 4
      Text = '0'
    end
    object edtTotalItem: TEdit
      Left = 776
      Top = 33
      Width = 113
      Height = 23
      ReadOnly = True
      TabOrder = 5
      Text = '0'
    end
    object btnAdicionarItem: TButton
      Left = 24
      Top = 80
      Width = 124
      Height = 31
      Caption = 'Adicionar Item'
      TabOrder = 6
      OnClick = btnAdicionarItemClick
    end
    object btnRemoverItem: TButton
      Left = 154
      Top = 80
      Width = 124
      Height = 31
      Caption = 'Remover Item'
      TabOrder = 7
      OnClick = btnRemoverItemClick
    end
  end
  object grdItens: TDBGrid
    Left = 0
    Top = 204
    Width = 980
    Height = 180
    Align = alTop
    DataSource = dsItens
    TabOrder = 2
    Columns = <
      item
        Expanded = False
        FieldName = 'ID_PRODUTO'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME_PRODUTO'
        Width = 380
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QTD'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALOR_UNITARIO'
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TOTAL'
        Width = 130
        Visible = True
      end>
  end
  object pnlRelatorioFiltro: TPanel
    Left = 0
    Top = 384
    Width = 980
    Height = 76
    Align = alTop
    TabOrder = 3
    object lblPeriodo: TLabel
      Left = 24
      Top = 14
      Width = 130
      Height = 15
      Caption = 'Período (início / fim)'
    end
    object lblClienteRelatorio: TLabel
      Left = 264
      Top = 14
      Width = 89
      Height = 15
      Caption = 'Cliente (filtro)'
    end
    object edtDataInicio: TEdit
      Left = 24
      Top = 35
      Width = 105
      Height = 23
      TabOrder = 0
    end
    object edtDataFim: TEdit
      Left = 136
      Top = 35
      Width = 105
      Height = 23
      TabOrder = 1
    end
    object cbClienteRelatorio: TComboBox
      Left = 264
      Top = 35
      Width = 472
      Height = 23
      Style = csDropDownList
      TabOrder = 2
    end
    object btnGerarRelatorio: TButton
      Left = 752
      Top = 33
      Width = 193
      Height = 27
      Caption = 'Gerar Relatório'
      TabOrder = 3
      OnClick = btnGerarRelatorioClick
    end
  end
  object grdRelatorio: TDBGrid
    Left = 0
    Top = 460
    Width = 980
    Height = 192
    Align = alClient
    DataSource = dsRelatorio
    TabOrder = 4
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATA'
        Width = 160
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ID_CLIENTE'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CLIENTE'
        Width = 390
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TOTAL'
        Width = 140
        Visible = True
      end>
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 696
    Width = 980
    Height = 64
    Align = alBottom
    TabOrder = 6
    object lblTotalVendaTitulo: TLabel
      Left = 24
      Top = 24
      Width = 79
      Height = 15
      Caption = 'Total da Venda'
    end
    object lblTotalVenda: TLabel
      Left = 115
      Top = 23
      Width = 30
      Height = 19
      Caption = '0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnNovaVenda: TButton
      Left = 680
      Top = 17
      Width = 125
      Height = 31
      Caption = 'Nova Venda'
      TabOrder = 0
      OnClick = btnNovaVendaClick
    end
    object btnFinalizarVenda: TButton
      Left = 820
      Top = 17
      Width = 125
      Height = 31
      Caption = 'Finalizar Venda'
      TabOrder = 1
      OnClick = btnFinalizarVendaClick
    end
  end
  object pnlRodapeRelatorio: TPanel
    Left = 0
    Top = 652
    Width = 980
    Height = 44
    Align = alBottom
    TabOrder = 5
    object lblTotalRelatorioTitulo: TLabel
      Left = 24
      Top = 14
      Width = 130
      Height = 15
      Caption = 'Total do Relatório'
    end
    object lblTotalRelatorio: TLabel
      Left = 165
      Top = 12
      Width = 30
      Height = 19
      Caption = '0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object dsItens: TDataSource
    DataSet = mtItens
    Left = 920
    Top = 16
  end
  object mtItens: TFDMemTable
    Left = 920
    Top = 72
  end
  object dsRelatorio: TDataSource
    DataSet = mtRelatorio
    Left = 920
    Top = 128
  end
  object mtRelatorio: TFDMemTable
    Left = 920
    Top = 184
  end
end