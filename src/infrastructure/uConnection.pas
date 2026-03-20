unit uConnection;

interface

uses
  System.SysUtils,
  System.IniFiles,
  System.IOUtils,
  System.SyncObjs,
  FireDAC.Comp.Client;

type
  TConnectionSingleton = class
  strict private
    class var FInstance: TConnectionSingleton;
    class var FLock: TCriticalSection;
    FConnection: TFDConnection;
    constructor Create;
    procedure ConfigureConnection;
    procedure LoadServerConfig(
      out AHost: string;
      out APort: Integer;
      out ADatabase: string;
      out AUser: string;
      out APassword: string;
      out ADebug: Boolean);
  public
    destructor Destroy; override;

    class constructor CreateClass;
    class destructor DestroyClass;

    class function GetInstance: TConnectionSingleton;
    class procedure ReleaseInstance;

    function GetConnection: TFDConnection;
    procedure Connect;
    procedure Disconnect;

    procedure StartTransaction;
    procedure Commit;
    procedure Rollback;
  end;

implementation

uses
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Stan.Option,
  FireDAC.Stan.Intf,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.UI.Intf;

{ TConnectionSingleton }

class constructor TConnectionSingleton.CreateClass;
begin
  FLock := TCriticalSection.Create;
end;

class destructor TConnectionSingleton.DestroyClass;
begin
  ReleaseInstance;
  FLock.Free;
end;

constructor TConnectionSingleton.Create;
begin
  inherited Create;
  FConnection := TFDConnection.Create(nil);
  ConfigureConnection;
end;

destructor TConnectionSingleton.Destroy;
begin
  if Assigned(FConnection) then
  begin
    if FConnection.Connected then
      FConnection.Connected := False;
    FConnection.Free;
  end;

  inherited Destroy;
end;

procedure TConnectionSingleton.ConfigureConnection;
var
  Host: string;
  Port: Integer;
  Database: string;
  User: string;
  Password: string;
  DebugMode: Boolean;
begin
  LoadServerConfig(Host, Port, Database, User, Password, DebugMode);

  FConnection.LoginPrompt := False;
  FConnection.Params.Clear;
  FConnection.Params.Add('DriverID=FB');
  if Trim(Host) <> '' then
  begin
    FConnection.Params.Add('Protocol=TCPIP');
    FConnection.Params.Add('Server=' + Host);
    FConnection.Params.Add('Port=' + IntToStr(Port));
  end
  else
    FConnection.Params.Add('Protocol=Local');

  FConnection.Params.Add('Database=' + Database);
  FConnection.Params.Add('User_Name=' + User);
  FConnection.Params.Add('Password=' + Password);
  FConnection.Params.Add('CharacterSet=UTF8');

  FConnection.ResourceOptions.SilentMode := not DebugMode;
end;

procedure TConnectionSingleton.LoadServerConfig(out AHost: string;
  out APort: Integer; out ADatabase, AUser, APassword: string;
  out ADebug: Boolean);
var
  Ini: TIniFile;
  IniPath: string;
begin
  IniPath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'database.ini');
  if not FileExists(IniPath) then
    raise Exception.CreateFmt('Arquivo de configuração não encontrado: %s', [IniPath]);

  Ini := TIniFile.Create(IniPath);
  try
    AHost := Trim(Ini.ReadString('SERVIDOR', 'Host', ''));
    APort := Ini.ReadInteger('SERVIDOR', 'Port', 3050);
    ADebug := Ini.ReadBool('SERVIDOR', 'Debug', False);
    ADatabase := Trim(Ini.ReadString('SERVIDOR', 'Database', ''));
    AUser := Trim(Ini.ReadString('SERVIDOR', 'User', ''));
    APassword := Ini.ReadString('SERVIDOR', 'Password', '');
  finally
    Ini.Free;
  end;

  if APort <= 0 then
    raise Exception.Create('Porta inválida na configuração do banco de dados.');

  if ADatabase = '' then
    raise Exception.Create('Database é obrigatório na configuração do banco de dados.');

  if AUser = '' then
    raise Exception.Create('User é obrigatório na configuração do banco de dados.');
end;

class function TConnectionSingleton.GetInstance: TConnectionSingleton;
begin
  FLock.Acquire;
  try
    if not Assigned(FInstance) then
      FInstance := TConnectionSingleton.Create;

    Result := FInstance;
  finally
    FLock.Release;
  end;
end;

class procedure TConnectionSingleton.ReleaseInstance;
begin
  FLock.Acquire;
  try
    FreeAndNil(FInstance);
  finally
    FLock.Release;
  end;
end;

function TConnectionSingleton.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

procedure TConnectionSingleton.Connect;
begin
  if not FConnection.Connected then
    FConnection.Connected := True;
end;

procedure TConnectionSingleton.Disconnect;
begin
  if FConnection.Connected then
    FConnection.Connected := False;
end;

procedure TConnectionSingleton.StartTransaction;
begin
  Connect;
  if not FConnection.InTransaction then
    FConnection.StartTransaction;
end;

procedure TConnectionSingleton.Commit;
begin
  if FConnection.InTransaction then
    FConnection.Commit;
end;

procedure TConnectionSingleton.Rollback;
begin
  if FConnection.InTransaction then
    FConnection.Rollback;
end;

end.
