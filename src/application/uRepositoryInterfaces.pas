unit uRepositoryInterfaces;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  uCliente,
  uProduto,
  uVenda;

type
  ITransactionManager = interface
    ['{6486F95C-57ED-463C-A6E8-BCC27D3FDFE5}']
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
  end;

  IClienteRepository = interface
    ['{662A3D5A-D0E0-48CF-9A70-703CFD8E117D}']
    function Inserir(const ACliente: TCliente): Integer;
    procedure Atualizar(const ACliente: TCliente);
    procedure Excluir(const AId: Integer);
    function ObterPorId(const AId: Integer): TCliente;
    function ListarTodos: TObjectList<TCliente>;
  end;

  IProdutoRepository = interface
    ['{FA6A5D9B-F8E3-4DCC-BCA9-3C7520509F4C}']
    function Inserir(const AProduto: TProduto): Integer;
    procedure Atualizar(const AProduto: TProduto);
    procedure Excluir(const AId: Integer);
    function ObterPorId(const AId: Integer): TProduto;
    function ListarTodos: TObjectList<TProduto>;
  end;

  IVendaRepository = interface
    ['{C7775E6B-0529-462B-B40F-973F38C44357}']
    function Inserir(const AVenda: TVenda): Integer;
    function ObterPorId(const AId: Integer): TVenda;
    function ListarPorPeriodo(const ADataInicio, ADataFim: TDateTime;
      const AIdCliente: Integer = 0): TObjectList<TVenda>;
  end;

implementation

end.