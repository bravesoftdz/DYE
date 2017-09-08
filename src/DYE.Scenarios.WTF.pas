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
const
  API_KEY = 'jEZTbYByKKmsh2k5GVnN85IRx5Yrp1gyoIwjsnSJ038XhuVKof';
var
  LLogo, LLabel, LWord: string;
  URL: string;
  Client: TNetHTTPClient;
  Response: string;
  ResponseJSON: TJSONObject;
  Definitions: TJSONArray;
  i: integer;
  DefinitionObject: TJSONObject;
  Definition: string;
  DefinitionList: TList<string>;
begin
  if Assigned(AGoogleResponse.Logo) then
  begin
    LLogo := AGoogleResponse.Logo.Description;
    LWord := LLogo;
  end
  else
    LWord := AGoogleResponse.&Label.Description;
  LLabel := AGoogleResponse.&Label.Description;
  URL := 'https://wordsapiv1.p.mashape.com/words/' + LWord + '/definitions';
  Client := TNetHTTPClient.Create(nil);
  try
    Client.CustomHeaders['X-Mashape-Key'] := API_KEY;
    Response := Client.Get(URL).ContentAsString(TEncoding.UTF8);
    ResponseJSON := TJSONObject.ParseJSONValue(Response) as TJSONObject;
    Definitions := (ResponseJSON.Values['definitions'] as TJSONArray);

    DefinitionList := TList<string>.Create;
    for i := 0 to Definitions.Count - 1 do
    begin
      DefinitionObject := Definitions.Items[i] as TJSONObject;
      Definition := DefinitionObject.Values['definition'].ToString;
      DefinitionList.Add(Definition);
    end;

    Result := TScenarioReturnData.Create;
    Result.Title := 'This is ';
    if UpCase(LWord[1]) in ['a','e','i','o','u'] then
    begin
      Result.Title := Result.Title + LWord + ',';
    end;
    Result.Content := 'It ';
    case Definitions.Count of
    0:    Result.Content := Result.Content + ' is ';
    1:    Result.Content := Result.Content + '';
    2..5: Result.Content := Result.Content + '';
    else  Result.Content := Result.Content + '';
    end;

    {if Definitions.Count > 0 then
    begin
      Result.Content := 'I found ' + Definitions.Count.ToString +
        ' definitions.';
      Result.Content := Result.Content + 'One of them is the following: ';
      Randomize;
      Result.Content := Result.Content + LWord + ' is ' + DefinitionList.Items
        [Random(DefinitionList.Count - 1)];
    end
    else
    begin
      Result.Content := 'I haven''t found any definitions.';
    end;  }
  finally
    FreeAndNil(Client);
    if Assigned(ResponseJSON) then
      FreeAndNil(ResponseJSON);
  end;
end;

initialization

GlobalScenarioSelector.RegisterScenario(stWTF, TDYEWTFScenario.Create);

end.
