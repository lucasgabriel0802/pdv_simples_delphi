object frmProdutos: TfrmProdutos
  Left = 0
  Top = 0
  Caption = 'Cadastro de Produtos'
  ClientHeight = 530
  ClientWidth = 860
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 860
    Height = 177
    Align = alTop
    TabOrder = 0
    object lblId: TLabel
      Left = 24
      Top = 18
      Width = 11
      Height = 15
      Caption = 'ID'
    end
    object lblNome: TLabel
      Left = 96
      Top = 18
      Width = 37
      Height = 15
      Caption = 'Nome'
    end
    object lblPreco: TLabel
      Left = 528
      Top = 18
      Width = 34
      Height = 15
      Caption = 'Preço'
    end
    object lblEstoque: TLabel
      Left = 648
      Top = 18
      Width = 46
      Height = 15
      Caption = 'Estoque'
    end
    object edtId: TEdit
      Left = 24
      Top = 39
      Width = 57
      Height = 23
      ReadOnly = True
      TabOrder = 0
    end
    object edtNome: TEdit
      Left = 96
      Top = 39
      Width = 417
      Height = 23
      TabOrder = 1
    end
    object edtPreco: TEdit
      Left = 528
      Top = 39
      Width = 105
      Height = 23
      TabOrder = 2
      Text = '0'
    end
    object edtEstoque: TEdit
      Left = 648
      Top = 39
      Width = 105
      Height = 23
      TabOrder = 3
      Text = '0'
    end
    object btnNovo: TButton
      Left = 24
      Top = 96
      Width = 96
      Height = 31
      Caption = 'Novo'
      TabOrder = 4
      OnClick = btnNovoClick
    end
    object btnSalvar: TButton
      Left = 126
      Top = 96
      Width = 96
      Height = 31
      Caption = 'Salvar'
      TabOrder = 5
      OnClick = btnSalvarClick
    end
    object btnExcluir: TButton
      Left = 228
      Top = 96
      Width = 96
      Height = 31
      Caption = 'Excluir'
      TabOrder = 6
      OnClick = btnExcluirClick
    end
    object btnAtualizar: TButton
      Left = 330
      Top = 96
      Width = 96
      Height = 31
      Caption = 'Atualizar'
      TabOrder = 7
      OnClick = btnAtualizarClick
    end
    object btnLimpar: TButton
      Left = 432
      Top = 96
      Width = 96
      Height = 31
      Caption = 'Limpar'
      TabOrder = 8
      OnClick = btnLimparClick
    end
  end
  object grdProdutos: TDBGrid
    Left = 0
    Top = 177
    Width = 860
    Height = 353
    Align = alClient
    DataSource = dsProdutos
    TabOrder = 1
    OnCellClick = grdProdutosCellClick
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME'
        Width = 330
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRECO'
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ESTOQUE'
        Width = 120
        Visible = True
      end>
  end
  object dsProdutos: TDataSource
    DataSet = mtProdutos
    Left = 776
    Top = 24
  end
  object mtProdutos: TFDMemTable
    Left = 776
    Top = 80
  end
end
