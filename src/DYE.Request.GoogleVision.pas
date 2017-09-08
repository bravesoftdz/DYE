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
    function Process(ARespone: TStringStream): TDYEGoogleVisionResponse;
    function Request(AGraphic: TBytesStream): TStringStream;
  public
    constructor Create(AGraphic: TBytesStream);
    destructor Destroy; override;
    property Response: TDYEGoogleVisionResponse read FResponse;
  end;

implementation

{ TDYEGoogleVisionRequest }

constructor TDYEGoogleVisionRequest.Create(AGraphic: TBytesStream);
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
  ARespone: TStringStream): TDYEGoogleVisionResponse;
begin
  Result := TDYEGoogleVisionResponse.Create;
end;

function TDYEGoogleVisionRequest.Request(AGraphic: TBytesStream): TStringStream;

  function RequestBody: TStringStream;
  var
    StreamWriter: TStreamWriter;
    JsonWriter: TJsonTextWriter;
  begin
    Result := TStringStream.Create;
    StreamWriter := TStreamWriter.Create(Result);
    try
      JsonWriter := TJsonTextWriter.Create(StreamWriter);
      try
        JsonWriter.WriteStartObject;

          JsonWriter.WritePropertyName('requests');
          JsonWriter.WriteStartArray;

            JsonWriter.WriteStartObject;

              JsonWriter.WritePropertyName('image');
              JsonWriter.WriteStartObject;

                JsonWriter.WritePropertyName('content');
                JsonWriter.WriteValue(AGraphic.Bytes);

              JsonWriter.WriteEndObject;

              JsonWriter.WritePropertyName('features');
              JsonWriter.WriteStartArray;

                JsonWriter.WriteStartObject;

                  JsonWriter.WritePropertyName('type');
                  JsonWriter.WriteValue('LABEL_DETECTION');

                  JsonWriter.WritePropertyName('maxResults');
                  JsonWriter.WriteValue(1);

                JsonWriter.WriteEndObject;

              JsonWriter.WriteEndArray;

            JsonWriter.WriteEndObject;

          JsonWriter.WriteEndArray;

        JsonWriter.WriteEndObject;
      finally
        JsonWriter.Free;
      end;
    finally
      StreamWriter.Free;
    end;
  end;

var
  Client: TNetHTTPClient;
begin
  Result := TStringStream.Create;
  try
    Client := TNetHTTPClient.Create(nil);
    try
      Client.Post(TDYEGoogleVisionAPIData.Url, RequestBody, Result);
    finally
      Client.Free;
    end;
  finally
    Result.Free;
  end;
end;

end.
