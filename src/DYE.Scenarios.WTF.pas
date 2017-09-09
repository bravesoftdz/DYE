unit DYE.Scenarios.WTF;

interface

uses DYE.Scenario, DYE.Request.AmazonLex, DYE.Request.GoogleVision,
  System.Net.HttpClientComponent, System.JSON, System.SysUtils,
  System.Classes, System.Generics.Collections;

type
  TDYEWTFScenario = class(TInterfacedObject, IScenario)
    function DoScenario(AGoogleResponse: TDYEGoogleVisionResponse)
      : TScenarioReturnData;
  end;

implementation

function TDYEWTFScenario.DoScenario(AGoogleResponse: TDYEGoogleVisionResponse)
  : TScenarioReturnData;
var LWord: string;
    URL: string;
    Client: TNetHTTPClient;
    Response: string;
    ResponseJSON: TJSONObject;
    Query: TJSONObject;
    Pages: TJSONObject;
    Page: TJSONObject;
    i: integer;
    DefinitionObject: TJSONObject;
    Definition: string;
begin
  if Assigned(AGoogleResponse.Logo) and
        (AGoogleResponse.Logo.Description.Trim<>'') then
  begin
    LWord := AGoogleResponse.Logo.Description;
  end
  else
    LWord:=AGoogleResponse.&Label.Description;
  URL := 'https://en.wikipedia.org/w/api.php?format=json&action=query' +
    '&prop=extracts&exintro=&explaintext=&titles=' + LWord;
  Client := TNetHTTPClient.Create(nil);
  try
    try
    Response := Client.Get(URL).ContentAsString(TEncoding.UTF8);
    Writeln('Wiki queried');
    ResponseJSON := TJSONObject.ParseJSONValue(Response) as TJSONObject;
    Query := ResponseJSON.Values['query'] as TJSONObject;
    Pages := Query.Values['pages'] as TJSONObject;
    Page := Pages.Pairs[0].JsonValue as TJSONObject;
    Definition := Page.Values['extract'].ToString;

    Result := TScenarioReturnData.Create;
    Result.Title := LWord;
    Result.Content := Definition;
    except
      Result := TScenarioReturnData.Create;
      Result.Title :=LWord;
      Result.Content := '"NONE"';
    end;
  finally
     FreeAndNil(Client);
     if Assigned(ResponseJSON) then
      FreeAndNil(ResponseJSON);
  end;
end;

initialization

GlobalScenarioSelector.RegisterScenario(stWTF, TDYEWTFScenario.Create);

end.
