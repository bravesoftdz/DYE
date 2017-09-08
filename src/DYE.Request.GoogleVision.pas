unit DYE.Request.GoogleVision;

interface

uses
  System.SysUtils,
  System.Net.HttpClientComponent,
  Vcl.Graphics,
  Vcl.Imaging.jpeg;

type
  EDYEGoogleVisionRequestError = class(Exception);

  TDYEGoogleVisionResponse<T: TGraphic> = record

  end;

  TDYEGoogleVisionCustomRequest<T: TGraphic> = class
  private
    FClient: TNetHTTPClient;
    FData: TDYEGoogleVisionResponse<T>;
  protected
    property Client: TNetHTTPClient read FClient;
  public
    constructor Create(AGraphic: T);
    destructor Destroy;
    property Response: TDYEGoogleVisionResponse<T> read FData;
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
end;

destructor TDYEGoogleVisionCustomRequest<T>.Destroy;
begin
  Client.Free;
end;

end.
