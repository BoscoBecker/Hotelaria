﻿unit Classe.Connection;

interface

uses  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
      FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
      FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client;

type
  TConnection = class
  private
    class var Fconnection:  TFDConnection;
    class var FInstance: TConnection;
    class var Ftransaction: TFDTransaction;
  public
    destructor Destroy; override;
    class function Instance: TConnection;
    class function GetConnection: TFDConnection;
    class procedure Disconnect;
    class function Transaction: TFDTransaction;
  end;

implementation

uses
  System.SysUtils;

destructor TConnection.Destroy;
begin
  inherited;
  if Fconnection <> nil then FreeAndNil(Fconnection);
  if Ftransaction <> nil then FreeAndNil(Ftransaction);
  if Assigned(FInstance) then FInstance := nil;
end;

class procedure TConnection.Disconnect;
begin
  self.Fconnection.Connected:= False;;
end;

class function TConnection.GetConnection: TFDConnection;
begin
  if Fconnection = nil then
    Fconnection:= TFDConnection.Create(nil);

  if Ftransaction =  nil then
    Ftransaction:= TFDTransaction.Create(nil);

  Fconnection.DriverName:= 'SQLite';
  Fconnection.loginPrompt:= False;
  Fconnection.params.DataBase:= GetCurrentDir() + '/DB/DB.DB';
  Fconnection.Connected;

  Ftransaction.connection:= Fconnection;
  result:= Fconnection;
end;

class function TConnection.Instance: TConnection;
begin
  if not Assigned(FInstance) then
    FInstance := TConnection.Create;
  Result := FInstance;
end;

class function TConnection.Transaction: TFDTransaction;
begin
  result:= Ftransaction;
end;
end.


