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
    Writeln('Image');
   try
     GVRequ := TDYEGoogleVisionRequest.Create(Data);
     GVResp := GVRequ.Response;
     ScenarioResult := GlobalWaitStorage.SetGoogleVisionResponse(GVResp);
     if not Assigned(ScenarioResult) then
       Result := '{"empty":"true"}'
     else
     Result := ScenarioResult.ToString;
     Writeln('Image result: ', Result);
   finally
     if Assigned(ScenarioResult) then
       FreeAndNil(ScenarioResult);
   end;
   Writeln('Image end');
end;

function TDYEResource.Voice([BodyParam] Data: string): String;
var LexReq: TDYEAmazonLexRequest;
    LexScenarioType: TDYEAmazonLexScenario;
    ScenarioResult: TScenarioReturnData;
begin
  Writeln('Voice');
  try
    LexReq := TDYEAmazonLexRequest.Create(Data);
    LexScenarioType := LexReq.Response.Scenario;
    ScenarioResult := GlobalWaitStorage.SetEventType(LexScenarioType);
    if not Assigned(ScenarioResult) then
     Result := '{"empty":"true"}'
    else
      Result := ScenarioResult.ToString;
    Writeln('Voice result: ', Result);
  finally
     FreeAndNil(LexReq);
     if Assigned(ScenarioResult) then
       FreeAndNil(ScenarioResult);
  end;
  Writeln('Voice end');
end;

initialization

  TMARSResourceRegistry.Instance.RegisterResource<TDYEResource>;

end.
