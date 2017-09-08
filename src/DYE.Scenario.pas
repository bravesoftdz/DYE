unit DYE.Scenario;

interface

uses Vcl.Graphics, Dye.Request.GoogleVision, DYE.Request.AmazonLex,
    System.Generics.Collections, System.SysUtils;

type

  TScenarioReturnData = class
    private
    FTitle: string;
    FContent: string;
    public
    property Title: string read FTitle write FTitle;
    property Content: string read FContent write FContent;
    function ToString: string;
  end;

  IScenario = interface
    function DoScenario(AGoogleResponse: TDYEGoogleVisionResponse): TScenarioReturnData;
  end;

  TScenarioSelector = class
    private
     FDict: TDictionary<TDYELexScenarioType,IScenario>;
    public
     constructor Create;
     function GiveScenario(ScenarioType: TDYELexScenarioType): IScenario;
     procedure RegisterScenario(ScenarioType: TDYELexScenarioType; Scenario: IScenario);
     destructor Destroy; override;
  end;

  function GlobalScenarioSelector: TScenarioSelector;

implementation

var GScenarioSelector: TScenarioSelector;

function GlobalScenarioSelector: TScenarioSelector;
begin
  if not Assigned(GScenarioSelector) then
    GScenarioSelector := TScenarioSelector.Create;
  Result := GScenarioSelector;
end;

function TScenarioReturnData.ToString: string;
begin
  Result :=
    '{"title":"' + Title + '","content":"' + Content + '"}';
end;

constructor TScenarioSelector.Create;
begin
  FDict := TDictionary<TDYELexScenarioType,IScenario>.Create;
end;

function TScenarioSelector.GiveScenario(ScenarioType: TDYELexScenarioType): IScenario;
begin
  Result := FDict.Items[ScenarioType];
end;

procedure TScenarioSelector.RegisterScenario(ScenarioType: TDYELexScenarioType; Scenario: IScenario);
begin
  FDict.Add(ScenarioType,Scenario);
end;

destructor TScenarioSelector.Destroy;
begin
  FreeAndNil(FDict);
end;

end.
