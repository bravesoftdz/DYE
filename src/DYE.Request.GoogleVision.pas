unit DYE.Request.GoogleVision;

interface

uses
  System.SysUtils,
  System.Net.HttpClientComponent,
  Vcl.Graphics,
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

  TDYEGoogleVisionCustomRequest<T: TGraphic> = class
  private
    FClient: TNetHTTPClient;
    FData: TDYEGoogleVisionResponse;
  protected
    property Client: TNetHTTPClient read FClient;
    function Request: String;
  public
    constructor Create(AGraphic: T);
    destructor Destroy;
    property Response: TDYEGoogleVisionResponse read FData;
  end;

  { USE THIS TYPE FROM ABROAD! }
  TDYEGoogleVisionRequest = TDYEGoogleVisionCustomRequest<TJPEGImage>;

implementation

{ TDYEGoogleVisionRequest }

constructor TDYEGoogleVisionCustomRequest<T>.Create(AGraphic: T);
begin
  if not Assigned(AGraphic) then
  begin
    raise Exception.Create('Graphic object must not be NIL');
  end;
  FClient := TNetHTTPClient.Create(nil);
  Request;
end;

destructor TDYEGoogleVisionCustomRequest<T>.Destroy;
begin
  Client.Free;
end;

function TDYEGoogleVisionCustomRequest<T>.Request: String;
begin

end;

end.
