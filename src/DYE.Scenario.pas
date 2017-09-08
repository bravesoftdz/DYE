unit DYE.Scenario;

interface

uses Vcl.Graphics, Dye.Request.GoogleVision, DYE.Request.AmazonLex;

type

  TScenarioReturnData = class
    private
    FTitle: string;
    FContent: string;
    FImage: TGraphic;
    public
    property Title: string read FTitle write FTitle;
    property Content: string read FContent write FContent;
    property Image: TGraphic read FImage write FImage;
  end;

  IScenario = interface
    function DoScenario(AGoogleResponse: TDYEGoogleVisionResponse): TScenarioReturnData;
  end;

  TScenarioSelector = class
    private

    public
     function GiveScenario(ScenarioType: TDYELexScenarioType): IScenario;
     procedure RegisterScenario(ScenarioType: TDYELexScenarioType; Scenario: IScenario);
  end;
implementation

function TScenarioSelector.GiveScenario(ScenarioType: TDYELexScenarioType): IScenario;
begin

end;

procedure TScenarioSelector.RegisterScenario(ScenarioType: TDYELexScenarioType; Scenario: IScenario);
begin

end;

end.
