unit DYE.Scenarios.Pricing;

interface

uses DYE.Scenario, DYE.Request.AmazonLex, DYE.Request.GoogleVision;

type
  TDYEPricingScenario = class(TinterfacedObject, IScenario)
    function DoScenario(AGoogleResponse: TDYEGoogleVisionResponse): TScenarioReturnData;
  end;

implementation

function TDYEPricingScenario.DoScenario(AGoogleResponse: TDYEGoogleVisionResponse): TScenarioReturnData;
begin

end;

initialization

GlobalScenarioSelector.RegisterScenario(stPrice,TDYEPricingScenario.Create);

end.
