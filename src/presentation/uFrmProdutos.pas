unit uFrmProdutos;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.DBGrids,
  Data.DB,
  FireDAC.Comp.Client,
  uProduto,
  uServices,
  uRepositoryInterfaces;

type
  TfrmProdutos = class(TForm)
    pnlTopo: TPanel;
    lblId: TLabel;
    lblNome: TLabel;
    lblPreco: TLabel;
    lblEstoque: TLabel;
    edtId: TEdit;
    edtNome: TEdit;
    edtPreco: TEdit;
    edtEstoque: TEdit;
    btnNovo: TButton;
    btnSalvar: TButton;
    btnExcluir: TButton;
    btnAtualizar: TButton;
    grdProdutos: TDBGrid;
    dsProdutos: TDataSource;
    mtProdutos: TFDMemTable;
    btnLimpar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure grdProdutosCellClick(Column: TColumn);
  private
    FProdutoService: TProdutoService;
    FProdutos: TObjectList<TProduto>;
    procedure ConfigurarMemTable;
    procedure CarregarProdutos;
    procedure LimparCampos;
    procedure PreencherCamposDoGrid;
    function LerProdutoDosCampos: TProduto;
    function ObterIdSelecionado: Integer;
  end;

implementation

{$R *.dfm}

uses
  Vcl.Dialogs,
  uFireDACRepositories;

procedure TfrmProdutos.FormCreate(Sender: TObject);
begin
  FProdutoService := TProdutoService.Create(TProdutoRepositoryFireDAC.Create);
  ConfigurarMemTable;
  CarregarProdutos;
  LimparCampos;
end;

procedure TfrmProdutos.FormDestroy(Sender: TObject);
begin
  FProdutos.Free;
  FProdutoService.Free;
end;

procedure TfrmProdutos.ConfigurarMemTable;
begin
  if mtProdutos.Active then
    mtProdutos.Close;

  mtProdutos.FieldDefs.Clear;
  mtProdutos.FieldDefs.Add('ID', ftInteger);
  mtProdutos.FieldDefs.Add('NOME', ftString, 120);
  mtProdutos.FieldDefs.Add('PRECO', ftCurrency);
  mtProdutos.FieldDefs.Add('ESTOQUE', ftFloat);
  mtProdutos.CreateDataSet;
  mtProdutos.Open;
end;

procedure TfrmProdutos.CarregarProdutos;
var
  Produto: TProduto;
begin
  FreeAndNil(FProdutos);
  FProdutos := FProdutoService.ListarProdutos;

  mtProdutos.DisableControls;
  try
    mtProdutos.EmptyDataSet;
    for Produto in FProdutos do
    begin
      mtProdutos.Append;
      mtProdutos.FieldByName('ID').AsInteger := Produto.Id;
      mtProdutos.FieldByName('NOME').AsString := Produto.Nome;
      mtProdutos.FieldByName('PRECO').AsCurrency := Produto.Preco;
      mtProdutos.FieldByName('ESTOQUE').AsFloat := Produto.Estoque;
      mtProdutos.Post;
    end;
  finally
    mtProdutos.EnableControls;
  end;

  if not mtProdutos.IsEmpty then
    mtProdutos.First;
end;

procedure TfrmProdutos.LimparCampos;
begin
  edtId.Clear;
  edtNome.Clear;
  edtPreco.Clear;
  edtEstoque.Clear;
  edtNome.SetFocus;
end;

procedure TfrmProdutos.PreencherCamposDoGrid;
begin
  if mtProdutos.IsEmpty then
    Exit;

  edtId.Text := mtProdutos.FieldByName('ID').AsString;
  edtNome.Text := mtProdutos.FieldByName('NOME').AsString;
  edtPreco.Text := CurrToStr(mtProdutos.FieldByName('PRECO').AsCurrency);
  edtEstoque.Text := FloatToStr(mtProdutos.FieldByName('ESTOQUE').AsFloat);
end;

function TfrmProdutos.LerProdutoDosCampos: TProduto;
var
  IdProduto: Integer;
  Preco: Currency;
  Estoque: Double;
begin
  if Trim(edtNome.Text) = '' then
    raise Exception.Create('Informe o nome do produto.');

  if not TryStrToCurr(Trim(edtPreco.Text), Preco) then
    raise Exception.Create('Preço inválido.');

  if not TryStrToFloat(Trim(edtEstoque.Text), Estoque) then
    raise Exception.Create('Estoque inválido.');

  if Trim(edtId.Text) = '' then
    IdProduto := 0
  else if not TryStrToInt(Trim(edtId.Text), IdProduto) then
    raise Exception.Create('ID inválido.');

  Result := TProduto.Create(IdProduto, Trim(edtNome.Text), Preco, Estoque);
end;

function TfrmProdutos.ObterIdSelecionado: Integer;
begin
  if Trim(edtId.Text) = '' then
    raise Exception.Create('Selecione um produto para excluir.');

  if not TryStrToInt(Trim(edtId.Text), Result) then
    raise Exception.Create('ID inválido para exclusão.');
end;

procedure TfrmProdutos.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TfrmProdutos.btnSalvarClick(Sender: TObject);
var
  Produto: TProduto;
  NovoId: Integer;
begin
  Produto := LerProdutoDosCampos;
  try
    if Produto.Id = 0 then
    begin
      NovoId := FProdutoService.CriarProduto(Produto.Nome, Produto.Preco, Produto.Estoque);
      ShowMessage(Format('Produto incluído com sucesso. ID: %d', [NovoId]));
    end
    else
    begin
      FProdutoService.AtualizarProduto(Produto);
      ShowMessage('Produto atualizado com sucesso.');
    end;

    CarregarProdutos;
    LimparCampos;
  finally
    Produto.Free;
  end;
end;

procedure TfrmProdutos.btnExcluirClick(Sender: TObject);
var
  IdProduto: Integer;
begin
  IdProduto := ObterIdSelecionado;

  if MessageDlg('Deseja realmente excluir este produto?', mtConfirmation,
    [mbYes, mbNo], 0) <> mrYes then
    Exit;

  FProdutoService.ExcluirProduto(IdProduto);
  CarregarProdutos;
  LimparCampos;
  ShowMessage('Produto excluído com sucesso.');
end;

procedure TfrmProdutos.btnAtualizarClick(Sender: TObject);
begin
  CarregarProdutos;
end;

procedure TfrmProdutos.btnLimparClick(Sender: TObject);
begin
  LimparCampos;
end;

procedure TfrmProdutos.grdProdutosCellClick(Column: TColumn);
begin
  PreencherCamposDoGrid;
end;

end.
