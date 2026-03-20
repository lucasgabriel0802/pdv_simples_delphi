unit uVenda;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  uVendaItem;

type
  TVenda = class
  private
    FId: Integer;
    FData: TDateTime;
    FIdCliente: Integer;
    FTotal: Currency;
    FItens: TObjectList<TVendaItem>;
    procedure SetData(const Value: TDateTime);
    procedure SetIdCliente(const Value: Integer);
  public
    constructor Create(const AId: Integer; const AData: TDateTime; const AIdCliente: Integer);
    destructor Destroy; override;

    procedure DefinirId(const AId: Integer);
    procedure AdicionarItem(const AItem: TVendaItem);
    procedure RemoverItemPorProduto(const AIdProduto: Integer);
    procedure CalcularTotal;
    procedure ValidarParaRegistro;
    function PossuiItens: Boolean;

    property Id: Integer read FId;
    property Data: TDateTime read FData write SetData;
    property IdCliente: Integer read FIdCliente write SetIdCliente;
    property Total: Currency read FTotal;
    property Itens: TObjectList<TVendaItem> read FItens;
  end;

implementation

{ TVenda }

constructor TVenda.Create(const AId: Integer; const AData: TDateTime;
  const AIdCliente: Integer);
begin
  inherited Create;
  if AId < 0 then
    raise Exception.Create('Id da venda inválido.');

  FId := AId;
  SetData(AData);
  SetIdCliente(AIdCliente);
  FItens := TObjectList<TVendaItem>.Create(True);
  FTotal := 0;
end;

destructor TVenda.Destroy;
begin
  FItens.Free;
  inherited Destroy;
end;

procedure TVenda.SetIdCliente(const Value: Integer);
begin
  if Value <= 0 then
    raise Exception.Create('Cliente da venda é obrigatório.');

  FIdCliente := Value;
end;

procedure TVenda.SetData(const Value: TDateTime);
begin
  if Value <= 0 then
    raise Exception.Create('Data da venda é obrigatória.');

  FData := Value;
end;

procedure TVenda.DefinirId(const AId: Integer);
begin
  if AId <= 0 then
    raise Exception.Create('Id da venda deve ser maior que zero.');

  FId := AId;
end;

procedure TVenda.AdicionarItem(const AItem: TVendaItem);
begin
  if not Assigned(AItem) then
    raise Exception.Create('Item da venda é obrigatório.');

  if AItem.IdProduto <= 0 then
    raise Exception.Create('Produto do item é obrigatório.');

  FItens.Add(AItem);
  CalcularTotal;
end;

procedure TVenda.RemoverItemPorProduto(const AIdProduto: Integer);
var
  Indice: Integer;
begin
  if AIdProduto <= 0 then
    raise Exception.Create('Produto do item é obrigatório para remoção.');

  for Indice := FItens.Count - 1 downto 0 do
    if FItens[Indice].IdProduto = AIdProduto then
      FItens.Delete(Indice);

  CalcularTotal;
end;

procedure TVenda.CalcularTotal;
var
  Item: TVendaItem;
begin
  FTotal := 0;
  for Item in FItens do
    FTotal := FTotal + Item.Total;
end;

procedure TVenda.ValidarParaRegistro;
begin
  if not PossuiItens then
    raise Exception.Create('A venda deve possuir ao menos um item.');

  if FIdCliente <= 0 then
    raise Exception.Create('Cliente da venda é obrigatório.');

  if FData <= 0 then
    raise Exception.Create('Data da venda é obrigatória.');
end;

function TVenda.PossuiItens: Boolean;
begin
  Result := FItens.Count > 0;
end;

end.