unit DYE.Scenarios.WTF;

interface

uses DYE.Scenario, DYE.Request.AmazonLex, DYE.Request.GoogleVision;

type
  TDYEWTFScenario = class(TInterfacedObject, IScenario)
     function DoScenario(AGoogleResponse: TDYEGoogleVisionResponse): TScenarioReturnData;
  end;

implementation

function TDYEWTFScenario.DoScenario(AGoogleResponse: TDYEGoogleVisionResponse): TScenarioReturnData;
begin

end;

initialization

GlobalScenarioSelector.RegisterScenario(stPrice,TDYEWTFScenario.Create);

end.
