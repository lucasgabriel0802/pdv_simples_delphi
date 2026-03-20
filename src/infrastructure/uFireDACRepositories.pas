unit uFireDACRepositories;

interface

uses
  System.SysUtils,
  System.DateUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  uRepositoryInterfaces,
  uCliente,
  uProduto,
  uVenda,
  uVendaItem;

type
  TRepositoryBase = class(TInterfacedObject)
  protected
    function NewQuery: TFDQuery;
  end;

  TClienteRepositoryFireDAC = class(TRepositoryBase, IClienteRepository)
  public
    function Inserir(const ACliente: TCliente): Integer;
    procedure Atualizar(const ACliente: TCliente);
    procedure Excluir(const AId: Integer);
    function ObterPorId(const AId: Integer): TCliente;
    function ListarTodos: TObjectList<TCliente>;
  end;

  TProdutoRepositoryFireDAC = class(TRepositoryBase, IProdutoRepository)
  public
    function Inserir(const AProduto: TProduto): Integer;
    procedure Atualizar(const AProduto: TProduto);
    procedure Excluir(const AId: Integer);
    function ObterPorId(const AId: Integer): TProduto;
    function ListarTodos: TObjectList<TProduto>;
  end;

  TVendaRepositoryFireDAC = class(TRepositoryBase, IVendaRepository)
  strict private
    procedure CarregarItens(const AVenda: TVenda);
  public
    function Inserir(const AVenda: TVenda): Integer;
    function ObterPorId(const AId: Integer): TVenda;
    function ListarPorPeriodo(const ADataInicio, ADataFim: TDateTime;
      const AIdCliente: Integer = 0): TObjectList<TVenda>;
  end;

implementation

uses
  uConnection;

{ TRepositoryBase }

function TRepositoryBase.NewQuery: TFDQuery;
begin
  TConnectionSingleton.GetInstance.Connect;
  Result := TFDQuery.Create(nil);
  Result.Connection := TConnectionSingleton.GetInstance.GetConnection;
end;

{ TClienteRepositoryFireDAC }

procedure TClienteRepositoryFireDAC.Atualizar(const ACliente: TCliente);
var
  Query: TFDQuery;
begin
  Query := NewQuery;
  try
    Query.SQL.Text :=
      'UPDATE CLIENTES ' +
      'SET NOME = :NOME, TELEFONE = :TELEFONE ' +
      'WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := ACliente.Id;
    Query.ParamByName('NOME').AsString := ACliente.Nome;
    Query.ParamByName('TELEFONE').AsString := ACliente.Telefone;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TClienteRepositoryFireDAC.Excluir(const AId: Integer);
var
  Query: TFDQuery;
begin
  Query := NewQuery;
  try
    Query.SQL.Text := 'DELETE FROM CLIENTES WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AId;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

function TClienteRepositoryFireDAC.Inserir(const ACliente: TCliente): Integer;
var
  Query: TFDQuery;
begin
  Query := NewQuery;
  try
    Query.SQL.Text :=
      'INSERT INTO CLIENTES (NOME, TELEFONE) ' +
      'VALUES (:NOME, :TELEFONE) ' +
      'RETURNING ID';
    Query.ParamByName('NOME').AsString := ACliente.Nome;
    Query.ParamByName('TELEFONE').AsString := ACliente.Telefone;
    Query.Open;
    Result := Query.FieldByName('ID').AsInteger;
  finally
    Query.Free;
  end;
end;

function TClienteRepositoryFireDAC.ListarTodos: TObjectList<TCliente>;
var
  Query: TFDQuery;
begin
  Result := TObjectList<TCliente>.Create(True);
  Query := NewQuery;
  try
    Query.SQL.Text := 'SELECT ID, NOME, TELEFONE FROM CLIENTES ORDER BY NOME';
    Query.Open;
    while not Query.Eof do
    begin
      Result.Add(TCliente.Create(
        Query.FieldByName('ID').AsInteger,
        Query.FieldByName('NOME').AsString,
        Query.FieldByName('TELEFONE').AsString));
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TClienteRepositoryFireDAC.ObterPorId(const AId: Integer): TCliente;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := NewQuery;
  try
    Query.SQL.Text := 'SELECT ID, NOME, TELEFONE FROM CLIENTES WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AId;
    Query.Open;
    if not Query.IsEmpty then
      Result := TCliente.Create(
        Query.FieldByName('ID').AsInteger,
        Query.FieldByName('NOME').AsString,
        Query.FieldByName('TELEFONE').AsString);
  finally
    Query.Free;
  end;
end;

{ TProdutoRepositoryFireDAC }

procedure TProdutoRepositoryFireDAC.Atualizar(const AProduto: TProduto);
var
  Query: TFDQuery;
begin
  Query := NewQuery;
  try
    Query.SQL.Text :=
      'UPDATE PRODUTOS ' +
      'SET NOME = :NOME, PRECO = :PRECO, ESTOQUE = :ESTOQUE ' +
      'WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AProduto.Id;
    Query.ParamByName('NOME').AsString := AProduto.Nome;
    Query.ParamByName('PRECO').AsCurrency := AProduto.Preco;
    Query.ParamByName('ESTOQUE').AsFloat := AProduto.Estoque;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TProdutoRepositoryFireDAC.Excluir(const AId: Integer);
var
  Query: TFDQuery;
begin
  Query := NewQuery;
  try
    Query.SQL.Text := 'DELETE FROM PRODUTOS WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AId;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

function TProdutoRepositoryFireDAC.Inserir(const AProduto: TProduto): Integer;
var
  Query: TFDQuery;
begin
  Query := NewQuery;
  try
    Query.SQL.Text :=
      'INSERT INTO PRODUTOS (NOME, PRECO, ESTOQUE) ' +
      'VALUES (:NOME, :PRECO, :ESTOQUE) ' +
      'RETURNING ID';
    Query.ParamByName('NOME').AsString := AProduto.Nome;
    Query.ParamByName('PRECO').AsCurrency := AProduto.Preco;
    Query.ParamByName('ESTOQUE').AsFloat := AProduto.Estoque;
    Query.Open;
    Result := Query.FieldByName('ID').AsInteger;
  finally
    Query.Free;
  end;
end;

function TProdutoRepositoryFireDAC.ListarTodos: TObjectList<TProduto>;
var
  Query: TFDQuery;
begin
  Result := TObjectList<TProduto>.Create(True);
  Query := NewQuery;
  try
    Query.SQL.Text := 'SELECT ID, NOME, PRECO, ESTOQUE FROM PRODUTOS ORDER BY NOME';
    Query.Open;
    while not Query.Eof do
    begin
      Result.Add(TProduto.Create(
        Query.FieldByName('ID').AsInteger,
        Query.FieldByName('NOME').AsString,
        Query.FieldByName('PRECO').AsCurrency,
        Query.FieldByName('ESTOQUE').AsFloat));
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TProdutoRepositoryFireDAC.ObterPorId(const AId: Integer): TProduto;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := NewQuery;
  try
    Query.SQL.Text := 'SELECT ID, NOME, PRECO, ESTOQUE FROM PRODUTOS WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AId;
    Query.Open;
    if not Query.IsEmpty then
      Result := TProduto.Create(
        Query.FieldByName('ID').AsInteger,
        Query.FieldByName('NOME').AsString,
        Query.FieldByName('PRECO').AsCurrency,
        Query.FieldByName('ESTOQUE').AsFloat);
  finally
    Query.Free;
  end;
end;

{ TVendaRepositoryFireDAC }

procedure TVendaRepositoryFireDAC.CarregarItens(const AVenda: TVenda);
var
  Query: TFDQuery;
begin
  Query := NewQuery;
  try
    Query.SQL.Text :=
      'SELECT ID, ID_VENDA, ID_PRODUTO, QTD, VALOR_UNITARIO, TOTAL ' +
      'FROM VENDAS_ITENS ' +
      'WHERE ID_VENDA = :ID_VENDA ' +
      'ORDER BY ID';
    Query.ParamByName('ID_VENDA').AsInteger := AVenda.Id;
    Query.Open;
    while not Query.Eof do
    begin
      AVenda.AdicionarItem(TVendaItem.Create(
        Query.FieldByName('ID').AsInteger,
        Query.FieldByName('ID_VENDA').AsInteger,
        Query.FieldByName('ID_PRODUTO').AsInteger,
        Query.FieldByName('QTD').AsFloat,
        Query.FieldByName('VALOR_UNITARIO').AsCurrency));
      Query.Next;
    end;

    AVenda.CalcularTotal;
  finally
    Query.Free;
  end;
end;

function TVendaRepositoryFireDAC.Inserir(const AVenda: TVenda): Integer;
var
  Query: TFDQuery;
  Item: TVendaItem;
begin
  Query := NewQuery;
  try
    Query.SQL.Text :=
      'INSERT INTO VENDAS (DATA, ID_CLIENTE, TOTAL) ' +
      'VALUES (:DATA, :ID_CLIENTE, :TOTAL) ' +
      'RETURNING ID';
    Query.ParamByName('DATA').AsDateTime := AVenda.Data;
    Query.ParamByName('ID_CLIENTE').AsInteger := AVenda.IdCliente;
    Query.ParamByName('TOTAL').AsCurrency := AVenda.Total;
    Query.Open;

    Result := Query.FieldByName('ID').AsInteger;
    AVenda.DefinirId(Result);

    Query.Close;
    Query.SQL.Text :=
      'INSERT INTO VENDAS_ITENS (ID_VENDA, ID_PRODUTO, QTD, VALOR_UNITARIO, TOTAL) ' +
      'VALUES (:ID_VENDA, :ID_PRODUTO, :QTD, :VALOR_UNITARIO, :TOTAL)';

    for Item in AVenda.Itens do
    begin
      Query.ParamByName('ID_VENDA').AsInteger := AVenda.Id;
      Query.ParamByName('ID_PRODUTO').AsInteger := Item.IdProduto;
      Query.ParamByName('QTD').AsFloat := Item.Qtd;
      Query.ParamByName('VALOR_UNITARIO').AsCurrency := Item.ValorUnitario;
      Query.ParamByName('TOTAL').AsCurrency := Item.Total;
      Query.ExecSQL;
    end;
  finally
    Query.Free;
  end;
end;

function TVendaRepositoryFireDAC.ListarPorPeriodo(const ADataInicio,
  ADataFim: TDateTime; const AIdCliente: Integer): TObjectList<TVenda>;
var
  Query: TFDQuery;
  Venda: TVenda;
begin
  Result := TObjectList<TVenda>.Create(True);
  Query := NewQuery;
  try
    Query.SQL.Text :=
      'SELECT ID, DATA, ID_CLIENTE, TOTAL ' +
      'FROM VENDAS ' +
      'WHERE DATA >= :DATA_INICIO AND DATA < :DATA_FIM ';

    if AIdCliente > 0 then
      Query.SQL.Add('AND ID_CLIENTE = :ID_CLIENTE ');

    Query.SQL.Add('ORDER BY DATA, ID');

    Query.ParamByName('DATA_INICIO').AsDateTime := ADataInicio;
    Query.ParamByName('DATA_FIM').AsDateTime := IncDay(ADataFim, 1);

    if AIdCliente > 0 then
      Query.ParamByName('ID_CLIENTE').AsInteger := AIdCliente;

    Query.Open;
    while not Query.Eof do
    begin
      Venda := TVenda.Create(
        Query.FieldByName('ID').AsInteger,
        Query.FieldByName('DATA').AsDateTime,
        Query.FieldByName('ID_CLIENTE').AsInteger);
      CarregarItens(Venda);
      Venda.CalcularTotal;
      Result.Add(Venda);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TVendaRepositoryFireDAC.ObterPorId(const AId: Integer): TVenda;
var
  Query: TFDQuery;
begin
  Result := nil;
  Query := NewQuery;
  try
    Query.SQL.Text :=
      'SELECT ID, DATA, ID_CLIENTE, TOTAL ' +
      'FROM VENDAS ' +
      'WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := AId;
    Query.Open;
    if not Query.IsEmpty then
    begin
      Result := TVenda.Create(
        Query.FieldByName('ID').AsInteger,
        Query.FieldByName('DATA').AsDateTime,
        Query.FieldByName('ID_CLIENTE').AsInteger);
      CarregarItens(Result);
      Result.CalcularTotal;
    end;
  finally
    Query.Free;
  end;
end;

end.