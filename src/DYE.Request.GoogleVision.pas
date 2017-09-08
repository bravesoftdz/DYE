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
      Host = '';
      Key = 'AIzaSyDlPE7zDiXzSRt-OQpeq-E3x8bXTFcV16c';
  end;

  TDYEGoogleVisionResponse = record

  end;

  TDYEGoogleVisionRequest = class
  private
    FResponse: TDYEGoogleVisionResponse;
  protected
    function Process(ARespone: TStream): TDYEGoogleVisionResponse;
    function Request(AGraphic: TStream): TStream;
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

function TDYEGoogleVisionRequest.Request(AGraphic: TStream): TStream;
var
  Client: TNetHTTPClient;
begin
  Result := TMemoryStream.Create;
  try
    Client := TNetHTTPClient.Create(nil);
    try
      Client.Post(TDYEGoogleVisionAPIData, AGraphic, Result);
    finally
      Client.Free;
    end;
  finally
    Result.Free;
  end;
end;

end.
