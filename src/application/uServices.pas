unit uServices;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  uRepositoryInterfaces,
  uCliente,
  uProduto,
  uVenda,
  uVendaItem;

type
  TProdutoService = class
  private
    FProdutoRepository: IProdutoRepository;
  public
    constructor Create(const AProdutoRepository: IProdutoRepository);

    function CriarProduto(const ANome: string; const APreco: Currency; const AEstoque: Double = 0): Integer;
    procedure AtualizarProduto(const AProduto: TProduto);
    procedure ExcluirProduto(const AId: Integer);
    function ObterProdutoPorId(const AId: Integer): TProduto;
    function ListarProdutos: TObjectList<TProduto>;
  end;

  TEstoqueService = class
  private
    FProdutoRepository: IProdutoRepository;
    FTransactionManager: ITransactionManager;
  public
    constructor Create(
      const AProdutoRepository: IProdutoRepository;
      const ATransactionManager: ITransactionManager);

    procedure EntradaEstoque(const AIdProduto: Integer; const AQuantidade: Double);
    procedure AjustarEstoque(const AIdProduto: Integer; const AQuantidade: Double);
  end;

  TVendaService = class
  private
    FVendaRepository: IVendaRepository;
    FProdutoRepository: IProdutoRepository;
    FClienteRepository: IClienteRepository;
    FTransactionManager: ITransactionManager;
  public
    constructor Create(
      const AVendaRepository: IVendaRepository;
      const AProdutoRepository: IProdutoRepository;
      const AClienteRepository: IClienteRepository;
      const ATransactionManager: ITransactionManager);

    function RegistrarVenda(const AVenda: TVenda): Integer;
    function ObterVendaPorId(const AId: Integer): TVenda;
    function ListarVendasPorPeriodo(const ADataInicio, ADataFim: TDateTime;
      const AIdCliente: Integer = 0): TObjectList<TVenda>;
  end;

implementation

{ TProdutoService }

constructor TProdutoService.Create(const AProdutoRepository: IProdutoRepository);
begin
  inherited Create;
  FProdutoRepository := AProdutoRepository;
end;

procedure TProdutoService.AtualizarProduto(const AProduto: TProduto);
begin
  if not Assigned(AProduto) then
    raise Exception.Create('Produto é obrigatório.');

  FProdutoRepository.Atualizar(AProduto);
end;

function TProdutoService.CriarProduto(const ANome: string; const APreco: Currency;
  const AEstoque: Double): Integer;
var
  Produto: TProduto;
begin
  Produto := TProduto.Create(0, ANome, APreco, AEstoque);
  try
    Result := FProdutoRepository.Inserir(Produto);
  finally
    Produto.Free;
  end;
end;

procedure TProdutoService.ExcluirProduto(const AId: Integer);
begin
  FProdutoRepository.Excluir(AId);
end;

function TProdutoService.ListarProdutos: TObjectList<TProduto>;
begin
  Result := FProdutoRepository.ListarTodos;
end;

function TProdutoService.ObterProdutoPorId(const AId: Integer): TProduto;
begin
  Result := FProdutoRepository.ObterPorId(AId);
end;

{ TEstoqueService }

constructor TEstoqueService.Create(const AProdutoRepository: IProdutoRepository;
  const ATransactionManager: ITransactionManager);
begin
  inherited Create;
  FProdutoRepository := AProdutoRepository;
  FTransactionManager := ATransactionManager;
end;

procedure TEstoqueService.AjustarEstoque(const AIdProduto: Integer;
  const AQuantidade: Double);
var
  Produto: TProduto;
begin
  FTransactionManager.StartTransaction;
  try
    Produto := FProdutoRepository.ObterPorId(AIdProduto);
    if not Assigned(Produto) then
      raise Exception.Create('Produto não encontrado.');

    try
      Produto.AjustarEstoque(AQuantidade);
      FProdutoRepository.Atualizar(Produto);
    finally
      Produto.Free;
    end;

    FTransactionManager.Commit;
  except
    FTransactionManager.Rollback;
    raise;
  end;
end;

procedure TEstoqueService.EntradaEstoque(const AIdProduto: Integer;
  const AQuantidade: Double);
var
  Produto: TProduto;
begin
  FTransactionManager.StartTransaction;
  try
    Produto := FProdutoRepository.ObterPorId(AIdProduto);
    if not Assigned(Produto) then
      raise Exception.Create('Produto não encontrado.');

    try
      Produto.EntradaEstoque(AQuantidade);
      FProdutoRepository.Atualizar(Produto);
    finally
      Produto.Free;
    end;

    FTransactionManager.Commit;
  except
    FTransactionManager.Rollback;
    raise;
  end;
end;

{ TVendaService }

constructor TVendaService.Create(const AVendaRepository: IVendaRepository;
  const AProdutoRepository: IProdutoRepository;
  const AClienteRepository: IClienteRepository;
  const ATransactionManager: ITransactionManager);
begin
  inherited Create;
  FVendaRepository := AVendaRepository;
  FProdutoRepository := AProdutoRepository;
  FClienteRepository := AClienteRepository;
  FTransactionManager := ATransactionManager;
end;

function TVendaService.ListarVendasPorPeriodo(const ADataInicio,
  ADataFim: TDateTime; const AIdCliente: Integer): TObjectList<TVenda>;
begin
  Result := FVendaRepository.ListarPorPeriodo(ADataInicio, ADataFim, AIdCliente);
end;

function TVendaService.ObterVendaPorId(const AId: Integer): TVenda;
begin
  Result := FVendaRepository.ObterPorId(AId);
end;

function TVendaService.RegistrarVenda(const AVenda: TVenda): Integer;
var
  Cliente: TCliente;
  Produto: TProduto;
  Item: TVendaItem;
begin
  if not Assigned(AVenda) then
    raise Exception.Create('Venda é obrigatória.');

  if AVenda.Itens.Count = 0 then
    raise Exception.Create('A venda deve possuir ao menos um item.');

  Cliente := FClienteRepository.ObterPorId(AVenda.IdCliente);
  try
    if not Assigned(Cliente) then
      raise Exception.Create('Cliente não encontrado.');
  finally
    Cliente.Free;
  end;

  FTransactionManager.StartTransaction;
  try
    for Item in AVenda.Itens do
    begin
      Produto := FProdutoRepository.ObterPorId(Item.IdProduto);
      if not Assigned(Produto) then
        raise Exception.CreateFmt('Produto %d não encontrado.', [Item.IdProduto]);

      try
        Item.ValorUnitario := Produto.Preco;
        Produto.BaixarEstoque(Item.Qtd);
        FProdutoRepository.Atualizar(Produto);
      finally
        Produto.Free;
      end;
    end;

    AVenda.CalcularTotal;
    Result := FVendaRepository.Inserir(AVenda);

    FTransactionManager.Commit;
  except
    FTransactionManager.Rollback;
    raise;
  end;
end;

end.
