unit DYE.Resources;

interface

uses
  MARS.Core.Attributes,
  MARS.Core.MediaType,
  MARS.Core.Registry;

type

  [Path('/default'), Produces(TMediaType.Text_Plain)]
  TDYEResource = class

    [GET, Path('/image')]
    function Image: String;

    [GET, Path('/voice')]
    function Voice: String;

  end;

implementation

{ TDYEResource }

function TDYEResource.Image: String;
begin
  Result := 'image';
end;

function TDYEResource.Voice: String;
begin
  Result := 'voice';
end;

initialization

  TMARSResourceRegistry.Instance.RegisterResource<TDYEResource>;

end.
