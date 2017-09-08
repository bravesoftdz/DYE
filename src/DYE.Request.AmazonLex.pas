unit DYE.Request.AmazonLex;

interface

uses
  System.Net.HTTPClientComponent, DYE.Scenario;

var Client: TNetHTTPCLient;

type
  TDYEAmazonLexRequest = class
     public
     function DoRequest(AReq: string): TDYEScenarioType;
  end;

implementation

function TDYEAmazonLexRequest.DoRequest(AReq: string): TDYEScenarioType;
begin

end;

end.
