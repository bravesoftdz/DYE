unit DYE.Request.GoogleVision;

interface

uses
  System.SysUtils,
  System.Types,
  System.Net.HttpClientComponent,
  System.Classes,
  System.JSON.Writers,
  System.JSON.Readers,
  Vcl.Imaging.jpeg;

type
  EDYEGoogleVisionError = class(Exception);

  TDYEGoogleVisionAPIData = packed record
  public const
    Host = 'https://vision.googleapis.com/v1/images:annotate';
    Key = 'AIzaSyDlPE7zDiXzSRt-OQpeq-E3x8bXTFcV16c';
    Url = Host + '?key=' + Key;
  end;

  TDYEGoogleVisionEntity = class
  private
    FDescription: String;
    FScore: Extended;
  public
    constructor Create(ADescription: String; AScore: Extended);
    property Description: String read FDescription;
    property Score: Extended read FScore;
  end;

  TDYEGoogleVisionResponse = class
  private
    FLogo: TDYEGoogleVisionEntity;
    FLabel: TDYEGoogleVisionEntity;
  public
    constructor Create(ALogo: TDYEGoogleVisionEntity;
      ALabel: TDYEGoogleVisionEntity);
    property Logo: TDYEGoogleVisionEntity read FLogo;
    property &Label: TDYEGoogleVisionEntity read FLabel;
  end;

  TDYEGoogleVisionRequest = class
  private
    FResponse: TDYEGoogleVisionResponse;
  protected
    function Process(AResponse: TStringStream): TDYEGoogleVisionResponse;
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
  inherited Create;
  if not Assigned(AGraphic) then
  begin
    raise Exception.Create('Graphic object must not be NIL');
  end;
  if AGraphic.Size = 0 then
  begin
    raise Exception.Create('Graphic must not be empty');
  end;
  Process(Request(AGraphic));
end;

destructor TDYEGoogleVisionRequest.Destroy;
begin
  inherited;
  Response.Free;
end;

function TDYEGoogleVisionRequest.Process(AResponse: TStringStream)
  : TDYEGoogleVisionResponse;
var
  StreamReader: TStreamReader;
  JsonReader: TJsonTextReader;
  LogoDescription: String;
  LogoScore: Extended;
  LabelDescription: String;
  LabelScore: Extended;
begin
  StreamReader := TStreamReader.Create(AResponse);
  try
    JsonReader := TJsonTextReader.Create(StreamReader);
    try
      while JsonReader.Read do
      begin
        if JsonReader.Path = 'responses[0].logoAnnotations[0].description' then
        begin
          LogoDescription := JsonReader.Value.AsString;
          Continue;
        end;
        if JsonReader.Path = 'responses[0].logoAnnotations[0].score' then
        begin
          LogoScore := JsonReader.Value.AsExtended;
          Continue;
        end;
        if JsonReader.Path = 'responses[0].logoAnnotations[1].description' then
        begin
          LabelDescription := JsonReader.Value.AsString;
          Continue;
        end;
        if JsonReader.Path = 'responses[0].logoAnnotations[1].score' then
        begin
          LabelScore := JsonReader.Value.AsExtended;
          Continue;
        end;
      end;
      FResponse := TDYEGoogleVisionResponse.Create
        (TDYEGoogleVisionEntity.Create(LogoDescription, LogoScore), TDYEGoogleVisionEntity.Create(LabelDescription,
        LabelScore));
    finally
      JsonReader.Free;
    end;
  finally
    StreamReader.Free;
  end;
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
        JsonWriter.WriteValue('LOGO_DETECTION');

        JsonWriter.WritePropertyName('maxResults');
        JsonWriter.WriteValue(1);

        JsonWriter.WriteEndObject;

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

{ TDYEGoogleVisionResponse }

constructor TDYEGoogleVisionResponse.Create(ALogo: TDYEGoogleVisionEntity;
  ALabel: TDYEGoogleVisionEntity);
begin
  inherited Create;
  if Assigned(ALogo) then
  begin
    FLogo := ALogo;
  end;
  if Assigned(ALabel) then
  begin
    FLabel := ALabel;
  end;
end;

{ TDYEGoogleVisionEntity }

constructor TDYEGoogleVisionEntity.Create(ADescription: String; AScore: Extended);
begin
  inherited Create;
  FDescription := ADescription;
  if AScore >= 1.0 then
  begin
    FScore := 1;
  end
  else
  begin
    FScore := AScore;
  end;
end;

end.
