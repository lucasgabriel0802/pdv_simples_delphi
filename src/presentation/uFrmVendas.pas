unit uFrmVendas;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.DateUtils,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.DBGrids,
  Data.DB,
  FireDAC.Comp.Client,
  uCliente,
  uProduto,
  uVenda,
  uVendaItem,
  uServices,
  uRepositoryInterfaces;

type
  TfrmVendas = class(TForm)
    pnlVenda: TPanel;
    lblCliente: TLabel;
    lblData: TLabel;
    cbCliente: TComboBox;
    edtDataVenda: TEdit;
    pnlItem: TPanel;
    lblIdProduto: TLabel;
    lblNomeProduto: TLabel;
    lblQtd: TLabel;
    lblValorUnitario: TLabel;
    lblTotalItem: TLabel;
    edtIdProduto: TEdit;
    edtNomeProduto: TEdit;
    edtQtd: TEdit;
    edtValorUnitario: TEdit;
    edtTotalItem: TEdit;
    btnAdicionarItem: TButton;
    btnRemoverItem: TButton;
    btnBuscarProduto: TButton;
    grdItens: TDBGrid;
    pnlRodape: TPanel;
    lblTotalVendaTitulo: TLabel;
    lblTotalVenda: TLabel;
    btnNovaVenda: TButton;
    btnFinalizarVenda: TButton;
    dsItens: TDataSource;
    mtItens: TFDMemTable;
    pnlRelatorioFiltro: TPanel;
    lblPeriodo: TLabel;
    lblClienteRelatorio: TLabel;
    edtDataInicio: TEdit;
    edtDataFim: TEdit;
    cbClienteRelatorio: TComboBox;
    btnGerarRelatorio: TButton;
    grdRelatorio: TDBGrid;
    dsRelatorio: TDataSource;
    mtRelatorio: TFDMemTable;
    pnlRodapeRelatorio: TPanel;
    lblTotalRelatorioTitulo: TLabel;
    lblTotalRelatorio: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnBuscarProdutoClick(Sender: TObject);
    procedure edtQtdChange(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btnRemoverItemClick(Sender: TObject);
    procedure btnNovaVendaClick(Sender: TObject);
    procedure btnFinalizarVendaClick(Sender: TObject);
    procedure btnGerarRelatorioClick(Sender: TObject);
  private
    FProdutoRepository: IProdutoRepository;
    FClienteRepository: IClienteRepository;
    FVendaService: TVendaService;
    FClientes: TObjectList<TCliente>;
    FItens: TObjectList<TVendaItem>;
    procedure ConfigurarMemTableItens;
    procedure ConfigurarMemTableRelatorio;
    procedure CarregarClientes;
    procedure InicializarFiltrosRelatorio;
    procedure CarregarRelatorioVendas;
    function ObterNomeCliente(const AIdCliente: Integer): string;
    procedure BuscarProduto;
    procedure RecalcularTotalItem;
    procedure RecalcularTotalVenda;
    procedure LimparCamposItem;
    procedure LimparVenda;
    function ObterClienteSelecionadoId: Integer;
    function ObterClienteRelatorioId: Integer;
    function LerIdProduto: Integer;
    function LerQuantidadeItem: Double;
    function EncontrarItemPorProduto(const AIdProduto: Integer): TVendaItem;
  end;

implementation

{$R *.dfm}

uses
  Vcl.Dialogs,
  uFireDACRepositories,
  uTransactionManager;

procedure TfrmVendas.FormCreate(Sender: TObject);
begin
  FProdutoRepository := TProdutoRepositoryFireDAC.Create;
  FClienteRepository := TClienteRepositoryFireDAC.Create;
  FVendaService := TVendaService.Create(
    TVendaRepositoryFireDAC.Create,
    FProdutoRepository,
    FClienteRepository,
    TFireDACTransactionManager.Create);

  FItens := TObjectList<TVendaItem>.Create(True);
  ConfigurarMemTableItens;
  ConfigurarMemTableRelatorio;
  CarregarClientes;
  InicializarFiltrosRelatorio;
  CarregarRelatorioVendas;
  LimparVenda;
end;

procedure TfrmVendas.FormDestroy(Sender: TObject);
begin
  FItens.Free;
  FClientes.Free;
  FVendaService.Free;
end;

procedure TfrmVendas.ConfigurarMemTableItens;
begin
  if mtItens.Active then
    mtItens.Close;

  mtItens.FieldDefs.Clear;
  mtItens.FieldDefs.Add('ID_PRODUTO', ftInteger);
  mtItens.FieldDefs.Add('NOME_PRODUTO', ftString, 140);
  mtItens.FieldDefs.Add('QTD', ftFloat);
  mtItens.FieldDefs.Add('VALOR_UNITARIO', ftCurrency);
  mtItens.FieldDefs.Add('TOTAL', ftCurrency);
  mtItens.CreateDataSet;
  mtItens.Open;
end;

procedure TfrmVendas.ConfigurarMemTableRelatorio;
begin
  if mtRelatorio.Active then
    mtRelatorio.Close;

  mtRelatorio.FieldDefs.Clear;
  mtRelatorio.FieldDefs.Add('ID', ftInteger);
  mtRelatorio.FieldDefs.Add('DATA', ftDateTime);
  mtRelatorio.FieldDefs.Add('ID_CLIENTE', ftInteger);
  mtRelatorio.FieldDefs.Add('CLIENTE', ftString, 140);
  mtRelatorio.FieldDefs.Add('TOTAL', ftCurrency);
  mtRelatorio.CreateDataSet;
  mtRelatorio.Open;
end;

procedure TfrmVendas.CarregarClientes;
var
  Cliente: TCliente;
begin
  FreeAndNil(FClientes);
  FClientes := FClienteRepository.ListarTodos;

  cbCliente.Items.BeginUpdate;
  cbClienteRelatorio.Items.BeginUpdate;
  try
    cbCliente.Items.Clear;
    cbClienteRelatorio.Items.Clear;
    cbClienteRelatorio.Items.Add('Todos');
    for Cliente in FClientes do
    begin
      cbCliente.Items.Add(Format('%d - %s', [Cliente.Id, Cliente.Nome]));
      cbClienteRelatorio.Items.Add(Format('%d - %s', [Cliente.Id, Cliente.Nome]));
    end;
  finally
    cbClienteRelatorio.Items.EndUpdate;
    cbCliente.Items.EndUpdate;
  end;

  if cbCliente.Items.Count > 0 then
    cbCliente.ItemIndex := 0
  else
    cbCliente.ItemIndex := -1;

  cbClienteRelatorio.ItemIndex := 0;
end;

procedure TfrmVendas.InicializarFiltrosRelatorio;
begin
  edtDataInicio.Text := DateToStr(StartOfTheMonth(Date));
  edtDataFim.Text := DateToStr(Date);

  if cbClienteRelatorio.Items.Count > 0 then
    cbClienteRelatorio.ItemIndex := 0;
end;

function TfrmVendas.ObterClienteRelatorioId: Integer;
begin
  if cbClienteRelatorio.ItemIndex <= 0 then
    Exit(0);

  Result := FClientes[cbClienteRelatorio.ItemIndex - 1].Id;
end;

function TfrmVendas.ObterNomeCliente(const AIdCliente: Integer): string;
var
  Cliente: TCliente;
begin
  for Cliente in FClientes do
    if Cliente.Id = AIdCliente then
      Exit(Cliente.Nome);

  Result := Format('Cliente %d', [AIdCliente]);
end;

procedure TfrmVendas.CarregarRelatorioVendas;
var
  DataInicio: TDateTime;
  DataFim: TDateTime;
  Vendas: TObjectList<TVenda>;
  Venda: TVenda;
  TotalGeral: Currency;
begin
  if not TryStrToDate(Trim(edtDataInicio.Text), DataInicio) then
    raise Exception.Create('Data inicial inválida para o relatório.');

  if not TryStrToDate(Trim(edtDataFim.Text), DataFim) then
    raise Exception.Create('Data final inválida para o relatório.');

  if DataFim < DataInicio then
    raise Exception.Create('A data final deve ser maior ou igual à data inicial.');

  Vendas := FVendaService.ListarVendasPorPeriodo(DataInicio, DataFim, ObterClienteRelatorioId);
  try
    TotalGeral := 0;
    mtRelatorio.DisableControls;
    try
      mtRelatorio.EmptyDataSet;
      for Venda in Vendas do
      begin
        mtRelatorio.Append;
        mtRelatorio.FieldByName('ID').AsInteger := Venda.Id;
        mtRelatorio.FieldByName('DATA').AsDateTime := Venda.Data;
        mtRelatorio.FieldByName('ID_CLIENTE').AsInteger := Venda.IdCliente;
        mtRelatorio.FieldByName('CLIENTE').AsString := ObterNomeCliente(Venda.IdCliente);
        mtRelatorio.FieldByName('TOTAL').AsCurrency := Venda.Total;
        mtRelatorio.Post;

        TotalGeral := TotalGeral + Venda.Total;
      end;
    finally
      mtRelatorio.EnableControls;
    end;

    lblTotalRelatorio.Caption := FormatCurr('#,##0.00', TotalGeral);
  finally
    Vendas.Free;
  end;
end;

function TfrmVendas.ObterClienteSelecionadoId: Integer;
begin
  if cbCliente.ItemIndex < 0 then
    raise Exception.Create('Selecione um cliente para a venda.');

  Result := FClientes[cbCliente.ItemIndex].Id;
end;

function TfrmVendas.LerIdProduto: Integer;
begin
  if not TryStrToInt(Trim(edtIdProduto.Text), Result) then
    raise Exception.Create('Informe um código de produto válido.');

  if Result <= 0 then
    raise Exception.Create('Código de produto inválido.');
end;

function TfrmVendas.LerQuantidadeItem: Double;
begin
  if not TryStrToFloat(Trim(edtQtd.Text), Result) then
    raise Exception.Create('Quantidade inválida.');

  if Result <= 0 then
    raise Exception.Create('A quantidade deve ser maior que zero.');
end;

procedure TfrmVendas.BuscarProduto;
var
  Produto: TProduto;
begin
  Produto := FProdutoRepository.ObterPorId(LerIdProduto);
  try
    if not Assigned(Produto) then
      raise Exception.Create('Produto não encontrado.');

    edtNomeProduto.Text := Produto.Nome;
    edtValorUnitario.Text := CurrToStr(Produto.Preco);
    RecalcularTotalItem;
  finally
    Produto.Free;
  end;
end;

procedure TfrmVendas.btnBuscarProdutoClick(Sender: TObject);
begin
  BuscarProduto;
end;

procedure TfrmVendas.RecalcularTotalItem;
var
  Quantidade: Double;
  ValorUnitario: Currency;
begin
  if not TryStrToFloat(Trim(edtQtd.Text), Quantidade) then
  begin
    edtTotalItem.Text := '0';
    Exit;
  end;

  if not TryStrToCurr(Trim(edtValorUnitario.Text), ValorUnitario) then
  begin
    edtTotalItem.Text := '0';
    Exit;
  end;

  edtTotalItem.Text := CurrToStr(Quantidade * ValorUnitario);
end;

procedure TfrmVendas.edtQtdChange(Sender: TObject);
begin
  RecalcularTotalItem;
end;

function TfrmVendas.EncontrarItemPorProduto(const AIdProduto: Integer): TVendaItem;
var
  Item: TVendaItem;
begin
  Result := nil;
  for Item in FItens do
    if Item.IdProduto = AIdProduto then
      Exit(Item);
end;

procedure TfrmVendas.btnAdicionarItemClick(Sender: TObject);
var
  Produto: TProduto;
  Quantidade: Double;
  ItemExistente: TVendaItem;
begin
  Produto := FProdutoRepository.ObterPorId(LerIdProduto);
  try
    if not Assigned(Produto) then
      raise Exception.Create('Produto não encontrado.');

    Quantidade := LerQuantidadeItem;
    ItemExistente := EncontrarItemPorProduto(Produto.Id);

    if Assigned(ItemExistente) then
    begin
      ItemExistente.Qtd := ItemExistente.Qtd + Quantidade;
      if mtItens.Locate('ID_PRODUTO', Produto.Id, []) then
      begin
        mtItens.Edit;
        mtItens.FieldByName('QTD').AsFloat := ItemExistente.Qtd;
        mtItens.FieldByName('TOTAL').AsCurrency := ItemExistente.Total;
        mtItens.Post;
      end;
    end
    else
    begin
      FItens.Add(TVendaItem.Create(0, 0, Produto.Id, Quantidade, Produto.Preco));
      mtItens.Append;
      mtItens.FieldByName('ID_PRODUTO').AsInteger := Produto.Id;
      mtItens.FieldByName('NOME_PRODUTO').AsString := Produto.Nome;
      mtItens.FieldByName('QTD').AsFloat := Quantidade;
      mtItens.FieldByName('VALOR_UNITARIO').AsCurrency := Produto.Preco;
      mtItens.FieldByName('TOTAL').AsCurrency := Quantidade * Produto.Preco;
      mtItens.Post;
    end;

    RecalcularTotalVenda;
    LimparCamposItem;
    edtIdProduto.SetFocus;
  finally
    Produto.Free;
  end;
end;

procedure TfrmVendas.btnRemoverItemClick(Sender: TObject);
var
  IdProduto: Integer;
  Indice: Integer;
begin
  if mtItens.IsEmpty then
    Exit;

  IdProduto := mtItens.FieldByName('ID_PRODUTO').AsInteger;
  for Indice := FItens.Count - 1 downto 0 do
    if FItens[Indice].IdProduto = IdProduto then
      FItens.Delete(Indice);

  mtItens.Delete;
  RecalcularTotalVenda;
end;

procedure TfrmVendas.RecalcularTotalVenda;
var
  Item: TVendaItem;
  Total: Currency;
begin
  Total := 0;
  for Item in FItens do
    Total := Total + Item.Total;

  lblTotalVenda.Caption := FormatCurr('#,##0.00', Total);
end;

procedure TfrmVendas.LimparCamposItem;
begin
  edtIdProduto.Clear;
  edtNomeProduto.Clear;
  edtQtd.Text := '1';
  edtValorUnitario.Text := '0';
  edtTotalItem.Text := '0';
end;

procedure TfrmVendas.LimparVenda;
begin
  FItens.Clear;
  if mtItens.Active then
    mtItens.EmptyDataSet;

  edtDataVenda.Text := DateToStr(Date);
  LimparCamposItem;
  RecalcularTotalVenda;
end;

procedure TfrmVendas.btnNovaVendaClick(Sender: TObject);
begin
  LimparVenda;
end;

procedure TfrmVendas.btnFinalizarVendaClick(Sender: TObject);
var
  Venda: TVenda;
  Item: TVendaItem;
  IdVenda: Integer;
begin
  if FItens.Count = 0 then
    raise Exception.Create('Inclua ao menos um item para finalizar a venda.');

  Venda := TVenda.Create(0, Now, ObterClienteSelecionadoId);
  try
    for Item in FItens do
      Venda.AdicionarItem(TVendaItem.Create(
        0,
        0,
        Item.IdProduto,
        Item.Qtd,
        Item.ValorUnitario));

    IdVenda := FVendaService.RegistrarVenda(Venda);
    ShowMessage(Format('Venda %d registrada com sucesso. Total: %s',
      [IdVenda, FormatCurr('#,##0.00', Venda.Total)]));
    CarregarRelatorioVendas;
    LimparVenda;
  finally
    Venda.Free;
  end;
end;

procedure TfrmVendas.btnGerarRelatorioClick(Sender: TObject);
begin
  CarregarRelatorioVendas;
end;

end.