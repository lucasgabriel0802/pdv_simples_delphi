unit uTransactionManager;

interface

uses
  uRepositoryInterfaces;

type
  TFireDACTransactionManager = class(TInterfacedObject, ITransactionManager)
  public
    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
  end;

implementation

uses
  uConnection;

{ TFireDACTransactionManager }

procedure TFireDACTransactionManager.Commit;
begin
  TConnectionSingleton.GetInstance.Commit;
end;

procedure TFireDACTransactionManager.Rollback;
begin
  TConnectionSingleton.GetInstance.Rollback;
end;

procedure TFireDACTransactionManager.StartTransaction;
begin
  TConnectionSingleton.GetInstance.StartTransaction;
end;

end.
