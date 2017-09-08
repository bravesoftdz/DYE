unit DYE.Request.GoogleVision;

interface

uses
  System.SysUtils,
  System.Net.HttpClientComponent,
  System.Classes,
  Vcl.Imaging.jpeg;

type
  EDYEGoogleVisionRequestError = class(Exception);

  TDYEGoogleVisionAPIData = packed record
  public
    const
      Key = 'AIzaSyDlPE7zDiXzSRt-OQpeq-E3x8bXTFcV16c';
  end;

  TDYEGoogleVisionResponse = record

  end;

  TDYEGoogleVisionRequest = class
  private
    FResponse: TDYEGoogleVisionResponse;
  protected
    function Process(ARespone: String): TDYEGoogleVisionResponse;
    function Request(AGraphic: TStream): String;
  public
    constructor Create(AGraphic: TStream);
    destructor Destroy; override;
    property Response: TDYEGoogleVisionResponse read FResponse;
  end;

implementation

{ TDYEGoogleVisionRequest }

constructor TDYEGoogleVisionRequest.Create(AGraphic: TStream);
begin
  if not Assigned(AGraphic) then
  begin
    raise Exception.Create('Graphic object must not be NIL');
  end;
  if AGraphic.Size = 0 then
  begin
    raise Exception.Create('Graphic must not be empty');
  end;
  FResponse := Process(Request(AGraphic));
end;

destructor TDYEGoogleVisionRequest.Destroy;
begin
end;

function TDYEGoogleVisionRequest.Process(
  ARespone: String): TDYEGoogleVisionResponse;
begin
end;

function TDYEGoogleVisionRequest.Request(AGraphic: TStream): String;
var
  Client: TNetHTTPClient;
begin
  Client := TNetHTTPClient.Create(nil);
  try
  finally
    Client.Free;
  end;
end;

end.
