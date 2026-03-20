unit uEstoqueMov;

interface

uses
  System.SysUtils;

type
  TTipoMovimentoEstoque = (tmeEntrada, tmeSaida, tmeAjuste);

  TEstoqueMov = class
  private
    FId: Integer;
    FIdProduto: Integer;
    FData: TDateTime;
    FTipo: TTipoMovimentoEstoque;
    FQuantidade: Double;
    procedure SetIdProduto(const Value: Integer);
    procedure SetData(const Value: TDateTime);
    procedure SetQuantidade(const Value: Double);
  public
    constructor Create(
      const AId: Integer;
      const AIdProduto: Integer;
      const AData: TDateTime;
      const ATipo: TTipoMovimentoEstoque;
      const AQuantidade: Double);

    class function CriarEntrada(const AIdProduto: Integer; const AQuantidade: Double;
      const AData: TDateTime = 0): TEstoqueMov;
    class function CriarSaida(const AIdProduto: Integer; const AQuantidade: Double;
      const AData: TDateTime = 0): TEstoqueMov;
    class function CriarAjuste(const AIdProduto: Integer; const AQuantidade: Double;
      const AData: TDateTime = 0): TEstoqueMov;

    function TipoComoChar: Char;

    property Id: Integer read FId;
    property IdProduto: Integer read FIdProduto write SetIdProduto;
    property Data: TDateTime read FData write SetData;
    property Tipo: TTipoMovimentoEstoque read FTipo;
    property Quantidade: Double read FQuantidade write SetQuantidade;
  end;

implementation

{ TEstoqueMov }

constructor TEstoqueMov.Create(const AId, AIdProduto: Integer; const AData: TDateTime;
  const ATipo: TTipoMovimentoEstoque; const AQuantidade: Double);
begin
  inherited Create;
  if AId < 0 then
    raise Exception.Create('Id da movimentação inválido.');

  FId := AId;
  FTipo := ATipo;
  SetIdProduto(AIdProduto);
  SetData(AData);
  SetQuantidade(AQuantidade);
end;

class function TEstoqueMov.CriarEntrada(const AIdProduto: Integer;
  const AQuantidade: Double; const AData: TDateTime): TEstoqueMov;
var
  DataMov: TDateTime;
begin
  DataMov := AData;
  if DataMov <= 0 then
    DataMov := Now;

  Result := TEstoqueMov.Create(0, AIdProduto, DataMov, tmeEntrada, AQuantidade);
end;

class function TEstoqueMov.CriarSaida(const AIdProduto: Integer;
  const AQuantidade: Double; const AData: TDateTime): TEstoqueMov;
var
  DataMov: TDateTime;
begin
  DataMov := AData;
  if DataMov <= 0 then
    DataMov := Now;

  Result := TEstoqueMov.Create(0, AIdProduto, DataMov, tmeSaida, AQuantidade);
end;

class function TEstoqueMov.CriarAjuste(const AIdProduto: Integer;
  const AQuantidade: Double; const AData: TDateTime): TEstoqueMov;
var
  DataMov: TDateTime;
begin
  DataMov := AData;
  if DataMov <= 0 then
    DataMov := Now;

  Result := TEstoqueMov.Create(0, AIdProduto, DataMov, tmeAjuste, AQuantidade);
end;

procedure TEstoqueMov.SetIdProduto(const Value: Integer);
begin
  if Value <= 0 then
    raise Exception.Create('Produto da movimentação é obrigatório.');

  FIdProduto := Value;
end;

procedure TEstoqueMov.SetData(const Value: TDateTime);
begin
  if Value <= 0 then
    raise Exception.Create('Data da movimentação é obrigatória.');

  FData := Value;
end;

procedure TEstoqueMov.SetQuantidade(const Value: Double);
begin
  if Value <= 0 then
    raise Exception.Create('Quantidade da movimentação deve ser maior que zero.');

  FQuantidade := Value;
end;

function TEstoqueMov.TipoComoChar: Char;
begin
  case FTipo of
    tmeEntrada: Result := 'E';
    tmeSaida: Result := 'S';
  else
    Result := 'A';
  end;
end;

end.
