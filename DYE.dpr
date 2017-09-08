program DYE;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,

  MARS.HTTP.Server.Indy,
  MARS.Core.Engine,
  MARS.Core.Application,

  DYE.Resources in 'src\DYE.Resources.pas';

type
  TServer = class
  private
    FEngine: TMARSEngine;
    FServer: TMARShttpServerIndy;
  public
    constructor Create;
    property Server: TMARShttpServerIndy read FServer;
    property Engine: TMARSEngine read FEngine;
  end;

{ TServer }

constructor TServer.Create;
begin
  FEngine := TMARSEngine.Create;
  try
    Engine.Port := 8066;
    Engine.ThreadPoolSize := 4;
    Engine.AddApplication('DYE', '/dye',['DYE.Resources.*']);
    FServer := TMARShttpServerIndy.Create(Engine);
    try
      Server.DefaultPort := Engine.Port;
      Server.Active := True;
    except
      Server.Free;
      raise;
    end;
  except
    Engine.Free;
    raise;
  end;
end;

var
  Server: TServer;
begin
  try
    Server := TServer.Create;
    while true do;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
