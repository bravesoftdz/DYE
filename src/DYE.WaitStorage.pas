unit DYE.WaitStorage;

interface

uses DYE.Request.GoogleVision, DYE.Scenario, DYE.Request.AmazonLex;

type

  TDYEWaitStorage = class
  public
    procedure SetEventType(AType: TDYELexScenarioType);
    procedure SetGoogleVisionResponse(AResponse: TDYEGoogleVisionResponse);
  end;

implementation

procedure TDYEWaitStorage.SetEventType(AType: TDYELexScenarioType);
begin

end;

procedure TDYEWaitStorage.SetGoogleVisionResponse(AResponse: TDYEGoogleVisionResponse);
begin

end;

end.
