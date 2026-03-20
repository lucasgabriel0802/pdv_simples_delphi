unit uFrmPrincipal;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TfrmPrincipal = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    btnProdutos: TButton;
    btnVendas: TButton;
    btnTestarConexao: TButton;
    procedure btnProdutosClick(Sender: TObject);
    procedure btnVendasClick(Sender: TObject);
    procedure btnTestarConexaoClick(Sender: TObject);
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses
  Vcl.Dialogs,
  uFrmProdutos,
  uFrmVendas,
  uConnection;

procedure TfrmPrincipal.btnProdutosClick(Sender: TObject);
begin
  with TfrmProdutos.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmPrincipal.btnVendasClick(Sender: TObject);
begin
  with TfrmVendas.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmPrincipal.btnTestarConexaoClick(Sender: TObject);
begin
  TConnectionSingleton.GetInstance.Connect;
  ShowMessage('Conexão com o banco estabelecida com sucesso.');
end;

end.
