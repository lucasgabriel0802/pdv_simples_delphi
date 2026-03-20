unit uVendaItem;

interface

uses
  System.SysUtils;

type
  TVendaItem = class
  private
    FId: Integer;
    FIdVenda: Integer;
    FIdProduto: Integer;
    FQtd: Double;
    FValorUnitario: Currency;
    FTotal: Currency;
    procedure SetIdProduto(const Value: Integer);
    procedure SetQtd(const Value: Double);
    procedure SetValorUnitario(const Value: Currency);
    procedure RecalcularTotal;
  public
    constructor Create(
      const AId: Integer;
      const AIdVenda: Integer;
      const AIdProduto: Integer;
      const AQtd: Double;
      const AValorUnitario: Currency);
    procedure DefinirVenda(const AIdVenda: Integer);
    function EstaAssociadoAVenda: Boolean;

    property Id: Integer read FId;
    property IdVenda: Integer read FIdVenda;
    property IdProduto: Integer read FIdProduto write SetIdProduto;
    property Qtd: Double read FQtd write SetQtd;
    property ValorUnitario: Currency read FValorUnitario write SetValorUnitario;
    property Total: Currency read FTotal;
  end;

implementation

{ TVendaItem }

constructor TVendaItem.Create(const AId, AIdVenda, AIdProduto: Integer;
  const AQtd: Double; const AValorUnitario: Currency);
begin
  inherited Create;
  if AId < 0 then
    raise Exception.Create('Id do item inválido.');

  if AIdVenda < 0 then
    raise Exception.Create('Id da venda do item inválido.');

  FId := AId;
  FIdVenda := AIdVenda;
  SetIdProduto(AIdProduto);
  SetQtd(AQtd);
  SetValorUnitario(AValorUnitario);
end;

procedure TVendaItem.DefinirVenda(const AIdVenda: Integer);
begin
  if AIdVenda <= 0 then
    raise Exception.Create('Id da venda deve ser maior que zero.');

  FIdVenda := AIdVenda;
end;

function TVendaItem.EstaAssociadoAVenda: Boolean;
begin
  Result := FIdVenda > 0;
end;

procedure TVendaItem.SetIdProduto(const Value: Integer);
begin
  if Value <= 0 then
    raise Exception.Create('Produto do item é obrigatório.');

  FIdProduto := Value;
end;

procedure TVendaItem.SetQtd(const Value: Double);
begin
  if Value <= 0 then
    raise Exception.Create('Quantidade do item deve ser maior que zero.');

  FQtd := Value;
  RecalcularTotal;
end;

procedure TVendaItem.SetValorUnitario(const Value: Currency);
begin
  if Value < 0 then
    raise Exception.Create('Valor unitário do item não pode ser negativo.');

  FValorUnitario := Value;
  RecalcularTotal;
end;

procedure TVendaItem.RecalcularTotal;
begin
  FTotal := FQtd * FValorUnitario;
end;

end.