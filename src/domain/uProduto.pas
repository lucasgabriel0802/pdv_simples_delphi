unit uProduto;

interface

uses
  System.SysUtils;

type
  TProduto = class
  private
    FId: Integer;
    FNome: string;
    FPreco: Currency;
    FEstoque: Double;
    procedure SetNome(const Value: string);
    procedure SetPreco(const Value: Currency);
    procedure SetEstoque(const Value: Double);
  public
    constructor Create(
      const AId: Integer;
      const ANome: string;
      const APreco: Currency;
      const AEstoque: Double = 0);

    procedure AlterarNome(const ANome: string);
    procedure AlterarPreco(const APreco: Currency);
    procedure EntradaEstoque(const AQuantidade: Double);
    procedure BaixarEstoque(const AQuantidade: Double);
    procedure AjustarEstoque(const AQuantidade: Double);
    function PossuiEstoque(const AQuantidade: Double): Boolean;
    function EstaCadastrado: Boolean;

    property Id: Integer read FId;
    property Nome: string read FNome write SetNome;
    property Preco: Currency read FPreco write SetPreco;
    property Estoque: Double read FEstoque write SetEstoque;
  end;

implementation

{ TProduto }

constructor TProduto.Create(const AId: Integer; const ANome: string;
  const APreco: Currency; const AEstoque: Double);
begin
  inherited Create;
  if AId < 0 then
    raise Exception.Create('Id do produto inválido.');

  FId := AId;
  SetNome(ANome);
  SetPreco(APreco);
  SetEstoque(AEstoque);
end;

procedure TProduto.AlterarNome(const ANome: string);
begin
  SetNome(ANome);
end;

procedure TProduto.AlterarPreco(const APreco: Currency);
begin
  SetPreco(APreco);
end;

procedure TProduto.SetNome(const Value: string);
begin
  if Trim(Value) = '' then
    raise Exception.Create('Nome do produto é obrigatório.');

  FNome := Trim(Value);
end;

procedure TProduto.SetPreco(const Value: Currency);
begin
  if Value < 0 then
    raise Exception.Create('Preço do produto não pode ser negativo.');

  FPreco := Value;
end;

procedure TProduto.SetEstoque(const Value: Double);
begin
  if Value < 0 then
    raise Exception.Create('Estoque não pode ser negativo.');

  FEstoque := Value;
end;

procedure TProduto.EntradaEstoque(const AQuantidade: Double);
begin
  if AQuantidade <= 0 then
    raise Exception.Create('Quantidade de entrada deve ser maior que zero.');

  FEstoque := FEstoque + AQuantidade;
end;

procedure TProduto.BaixarEstoque(const AQuantidade: Double);
begin
  if AQuantidade <= 0 then
    raise Exception.Create('Quantidade para baixa deve ser maior que zero.');

  if not PossuiEstoque(AQuantidade) then
    raise Exception.Create('Estoque insuficiente para a operação.');

  FEstoque := FEstoque - AQuantidade;
end;

procedure TProduto.AjustarEstoque(const AQuantidade: Double);
var
  NovoEstoque: Double;
begin
  NovoEstoque := FEstoque + AQuantidade;
  if NovoEstoque < 0 then
    raise Exception.Create('Ajuste resultaria em estoque negativo.');

  FEstoque := NovoEstoque;
end;

function TProduto.PossuiEstoque(const AQuantidade: Double): Boolean;
begin
  if AQuantidade <= 0 then
    raise Exception.Create('Quantidade deve ser maior que zero para validar estoque.');

  Result := FEstoque >= AQuantidade;
end;

function TProduto.EstaCadastrado: Boolean;
begin
  Result := FId > 0;
end;

end.