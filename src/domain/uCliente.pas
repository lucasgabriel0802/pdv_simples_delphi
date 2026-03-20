unit uCliente;

interface

uses
  System.SysUtils;

type
  TCliente = class
  private
    FId: Integer;
    FNome: string;
    FTelefone: string;
    procedure SetNome(const Value: string);
    procedure SetTelefone(const Value: string);
  public
    constructor Create(const AId: Integer; const ANome, ATelefone: string);
    procedure AlterarNome(const ANome: string);
    procedure AlterarTelefone(const ATelefone: string);
    function EstaCadastrado: Boolean;

    property Id: Integer read FId;
    property Nome: string read FNome write SetNome;
    property Telefone: string read FTelefone write SetTelefone;
  end;

implementation

{ TCliente }

constructor TCliente.Create(const AId: Integer; const ANome, ATelefone: string);
begin
  inherited Create;
  if AId < 0 then
    raise Exception.Create('Id do cliente inválido.');

  FId := AId;
  SetNome(ANome);
  SetTelefone(ATelefone);
end;

procedure TCliente.AlterarNome(const ANome: string);
begin
  SetNome(ANome);
end;

procedure TCliente.AlterarTelefone(const ATelefone: string);
begin
  SetTelefone(ATelefone);
end;

function TCliente.EstaCadastrado: Boolean;
begin
  Result := FId > 0;
end;

procedure TCliente.SetNome(const Value: string);
begin
  if Trim(Value) = '' then
    raise Exception.Create('Nome do cliente é obrigatório.');

  FNome := Trim(Value);
end;

procedure TCliente.SetTelefone(const Value: string);
begin
  FTelefone := Trim(Value);
end;

end.