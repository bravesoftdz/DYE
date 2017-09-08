unit DYE.Resources;

interface

uses
  MARS.Core.Attributes,
  MARS.Core.MediaType,
  MARS.Core.Registry,
  MARS.Core.MessageBodyReader,
  MARS.Core.MessageBodyReaders,
  DYE.Request.GoogleVision,
  DYE.Request.AmazonLex,
  DYE.WaitStorage,
  DYE.Scenario,
  System.Classes, System.SysUtils,
  System.JSON;

type

  [Path('/default'), Produces(TMediaType.APPLICATION_JSON)]
  TDYEResource = class

    [POST, Path('/image')]
    function Image([BodyParam] Data: TBytesStream): String;

    [POST, Path('/voice')]
    function Voice([BodyParam] Data: string): String;

  end;

implementation

{ TDYEResource }

function TDYEResource.Image([BodyParam] Data: TBytesStream): String;
var GVRequ: TDYEGoogleVisionRequest;
    GVResp: TDYEGoogleVisionResponse;
    ScenarioResult: TScenarioReturnData;
begin
   try
     GVRequ := TDYEGoogleVisionRequest.Create(Data);
     GVResp := GVRequ.Response;
     ScenarioResult := GlobalWaitStorage.SetGoogleVisionResponse(GVResp);
     if not Assigned(ScenarioResult) then
       Result := '{"empty":"true"}'
     else
     Result := '';
   finally
     if Assigned(GVRequ) then
       FreeAndNil(GVRequ);
     if Assigned(ScenarioResult) then
       FreeAndNil(ScenarioResult);
   end;
end;

function TDYEResource.Voice([BodyParam] Data: string): String;
var LexReq: TDYEAmazonLexRequest;
    LexScenarioType: TDYELexScenarioType;
    ScenarioResult: TScenarioReturnData;
begin
  try
    LexReq := TDYEAmazonLexRequest.Create;
    LexScenarioType := LexReq.DoRequest(Data);
    ScenarioResult := GlobalWaitStorage.SetEventType(LexScenarioType);
    if not Assigned(ScenarioResult) then
     Result := '{"empty":"true"}'
    else
      Result := 'Yep';
  finally
     FreeAndNil(LexReq);
     if Assigned(ScenarioResult) then
       FreeAndNil(ScenarioResult);
  end;
end;

initialization

  TMARSResourceRegistry.Instance.RegisterResource<TDYEResource>;

end.
