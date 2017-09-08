unit DYE.Scenarios.WTF;

interface

uses DYE.Scenario, DYE.Request.AmazonLex, DYE.Request.GoogleVision,
     System.Net.HttpClientComponent, System.JSON, System.SysUtils,
     System.Classes;

type
  TDYEWTFScenario = class(TInterfacedObject, IScenario)
     function DoScenario(AGoogleResponse: TDYEGoogleVisionResponse): TScenarioReturnData;
  end;

implementation

function TDYEWTFScenario.DoScenario(AGoogleResponse: TDYEGoogleVisionResponse): TScenarioReturnData;
const API_KEY = 'jEZTbYByKKmsh2k5GVnN85IRx5Yrp1gyoIwjsnSJ038XhuVKof';
var Word: string;
    URL: string;
    Client: TNetHTTPClient;
    Response: string;
    ResponseJSON: TJSONObject;
    Definitions: TJSONArray;
    i: integer;
    DefinitionObject: TJSONObject;
    Definition: string;
    DefinitionList: TStringList;
begin

  Word:=AGoogleResponse.&Label.Description;
  URL := 'https://wordsapiv1.p.mashape.com/words/' + Word + '/definitions';
  Client := TNetHTTPClient.Create(nil);
  try
    Client.CustomHeaders['X-Mashape-Key'] := API_KEY;
    Response := Client.Get(URL).ContentAsString(TEncoding.UTF8);
    ResponseJSON := TJSONObject.ParseJSONValue(Response) as TJSONObject;
    Definitions := (ResponseJSON.Values['definitions'] as TJSONArray);

    DefinitionList := TStringList.Create;
    for i:=0 to Definitions.Count-1 do
    begin
      DefinitionObject :=  Definitions.Items[i] as TJSONObject;
      Definition := DefinitionObject.Values['definition'].ToString;
      DefinitionList.Add(Definition);
    end;

    Result := TScenarioReturnData.Create;
    Result.Title := 'This is ' + Word;
    Result.Content := 'I found ' + Definitions.Count.ToString + ' definitions.';
    Result.Content := Result.Content + 'One of them is the following:';
    Randomize;
    Result.Content := Result.Content + Word + ' is ' +
        DefinitionList.ValueFromIndex[Random(Definitions.Count)];
  finally
     FreeAndNil(Client);
     if Assigned(ResponseJSON) then
      FreeAndNil(ResponseJSON);
  end;
end;

initialization

GlobalScenarioSelector.RegisterScenario(stWTF,TDYEWTFScenario.Create);

end.
