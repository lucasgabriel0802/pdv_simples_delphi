program ProjetoVendas;

uses
  Vcl.Forms,
  uFrmPrincipal in 'src\presentation\uFrmPrincipal.pas' {frmPrincipal},
  uFrmProdutos in 'src\presentation\uFrmProdutos.pas' {frmProdutos},
  uFrmVendas in 'src\presentation\uFrmVendas.pas' {frmVendas},
  uCliente in 'src\domain\uCliente.pas',
  uProduto in 'src\domain\uProduto.pas',
  uVendaItem in 'src\domain\uVendaItem.pas',
  uVenda in 'src\domain\uVenda.pas',
  uEstoqueMov in 'src\domain\uEstoqueMov.pas',
  uRepositoryInterfaces in 'src\application\uRepositoryInterfaces.pas',
  uServices in 'src\application\uServices.pas',
  uConnection in 'src\infrastructure\uConnection.pas',
  uTransactionManager in 'src\infrastructure\uTransactionManager.pas',
  uFireDACRepositories in 'src\infrastructure\uFireDACRepositories.pas';

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
  TConnectionSingleton.ReleaseInstance;
end.
