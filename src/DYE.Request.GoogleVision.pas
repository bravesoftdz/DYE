unit DYE.Request.GoogleVision;

interface

uses
  System.SysUtils,
  System.Net.HttpClientComponent,
  System.Classes,
  System.JSON.Writers,
  Vcl.Imaging.jpeg;

type
  EDYEGoogleVisionRequestError = class(Exception);

  TDYEGoogleVisionAPIData = packed record
  public
    const
      Host = 'https://vision.googleapis.com/v1/images:annotate';
      Key = 'AIzaSyDlPE7zDiXzSRt-OQpeq-E3x8bXTFcV16c';
      Url = Host + '?key=' + Key;
  end;

  TDYEGoogleVisionResponse = class

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
  Response.Free;
end;

function TDYEGoogleVisionRequest.Process(
  ARespone: TStream): TDYEGoogleVisionResponse;
begin
  Result := TDYEGoogleVisionResponse.Create;
end;

function TDYEGoogleVisionRequest.Request(AGraphic: TStream): TStream;
var
  Client: TNetHTTPClient;
  JsonWriter: TJsonWriter;
begin
  Result := TMemoryStream.Create;
  try
    Client := TNetHTTPClient.Create(nil);
    try

      Client.Post(TDYEGoogleVisionAPIData.Url, AGraphic, Result);
    finally
      Client.Free;
    end;
  finally
    Result.Free;
  end;
end;

end.
