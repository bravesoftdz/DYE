unit DYE.Request.AmazonLex;

interface

uses
  System.Net.HTTPClientComponent;

var Client: TNetHTTPCLient;

type
  TDYELexScenarioType=(stPrice, stWTF);

  TDYEAmazonLexRequest = class
     public
     function DoRequest(AReq: string): TDYELexScenarioType;
  end;

implementation

function TDYEAmazonLexRequest.DoRequest(AReq: string): TDYELexScenarioType;
begin

end;

end.
