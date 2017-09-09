unit DYE.WaitStorage;

interface

uses DYE.Request.GoogleVision, DYE.Scenario, DYE.Request.AmazonLex, System.SyncObjs,
     System.SysUtils;

type

  TDYEWaitStorage = class
    FEventType: TDYEAmazonLexScenario;
    FGoogleVisionResponse: TDYEGoogleVisionResponse;
    CS: TCriticalSection;
  public
    constructor Create;
    function SetEventType(AType: TDYEAmazonLexScenario): TScenarioReturnData;
    function SetGoogleVisionResponse(AResponse: TDYEGoogleVisionResponse): TScenarioReturnData;
    destructor Destroy; override;
  end;

function GlobalWaitStorage: TDYEWaitStorage;

implementation

var WS: TDYEWaitStorage;

function GlobalWaitStorage: TDYEWaitStorage;
begin
  if not Assigned(WS) then
    WS := TDYEWaitStorage.Create;
  Result := WS;
end;

constructor TDYEWaitStorage.Create;
begin
 CS:=TCriticalSection.Create;
 FEventType := stNone;
end;

function TDYEWaitStorage.SetEventType(AType: TDYEAmazonLexScenario): TScenarioReturnData;
var Scenario: IScenario;
begin
  CS.Enter;
  try
    Writeln('Save Event type');
    FEventType := AType;
    if Assigned(FGoogleVisionResponse) then
    begin
      Scenario := GlobalScenarioSelector.GiveScenario(FEventType);
      Writeln('Execute scenario');
      Result := Scenario.DoScenario(FGoogleVisionResponse);
      FEventType := stNone;
      FreeAndNil(FGoogleVisionResponse);
    end
    else
      Result := nil;
  finally
    CS.Leave;
  end;
end;

function TDYEWaitStorage.SetGoogleVisionResponse(AResponse: TDYEGoogleVisionResponse): TScenarioReturnData;
var Scenario: IScenario;
begin
  CS.Enter;
  try
    Writeln('Save google response');
    FGoogleVisionResponse := AResponse;
    if FEventType <> stNone then
    begin
      Scenario := GlobalScenarioSelector.GiveScenario(FEventType);
      Writeln('Execute scenario');
      Result := Scenario.DoScenario(FGoogleVisionResponse);
      FEventType := stNone;
      FreeAndNil(FGoogleVisionResponse);
    end
    else
    begin
      Result := nil;
    end;
  finally
    CS.Leave;
  end;
end;

destructor TDYEWaitStorage.Destroy;
begin
  FreeAndNil(CS);
end;

end.
