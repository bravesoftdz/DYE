program DYE;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  MARS.Core.Engine,
  MARS.http.Server.Indy,
  DYE.Ressources in 'DYE.Ressources.pas';

var FEngine: TMARSEngine;
    FServer: TMARSIndyServer;

begin
  try
    FEngine := TMARSEngine.Create;
    FEngine.Parameters.Values['Port'] := 80;
    FEngine.Parameters.Values['ThreadPoolSize'] := 2;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
