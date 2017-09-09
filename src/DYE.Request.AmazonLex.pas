unit DYE.Request.AmazonLex;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Net.HTTPClientComponent,
  System.JSON.Writers,
  System.JSON.Readers;

type
  EDYEAmazonLexError = class(Exception);

  TDYEAmazonLexAPIData = packed record
  public const
    Host = 'https://runtime.lex.us-east-1.amazonaws.com';
    Key = '';
    Bot = 'dye';
    Alias = 'dyeone';
    User = 'r2d2';
    Url = Host + '/bot/' + Bot + '/alias/' + Alias + '/user/' + User + '/text';
  end;

  TDYEAmazonLexResponse = class
  private
  public
  end;

  TDYEAmazonLexRequest = class
  private
    FResponse: TDYEAmazonLexResponse;
  protected
    function Process(AResponse: TStringStream): TDYEAmazonLexResponse;
    function Request(AText: String): TStringStream;
  public
    constructor Create(AText: String);
    destructor Destroy; override;
    property Response: TDYEAmazonLexResponse read FResponse;
  end;

implementation

{ TDYEAmazonLexRequest }

constructor TDYEAmazonLexRequest.Create(AText: String);
begin
  inherited Create;
  if Length(AText) = 0 then
  begin
    raise Exception.Create('Text string must not be empty');
  end;
  Process(Request(AText));
end;

destructor TDYEAmazonLexRequest.Destroy;
begin
  Response.Free;
  inherited;
end;

function TDYEAmazonLexRequest.Process(
  AResponse: TStringStream): TDYEAmazonLexResponse;
begin

end;

function TDYEAmazonLexRequest.Request(AText: String): TStringStream;

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

        JsonWriter.WritePropertyName('inputText');
        JsonWriter.WriteValue(AText);

        JsonWriter.WriteEndObject;
      finally
        JsonWriter.Free;
      end;
    finally
      StreamWriter.Free;
      Result.Position := 0;
    end;
  end;

var
  Client: TNetHTTPClient;
begin
  Result := TStringStream.Create;
  try
    Client := TNetHTTPClient.Create(nil);
    try
      Client.Post(TDYEAmazonLexAPIData.Url, RequestBody, Result);
    finally
      Client.Free;
    end;
  finally
    Result.Position := 0;
  end;
end;

end.
