unit OW.API;

interface

uses
  OW.Data;

type
  TOpenWeatherByCoordsEvent = procedure(Sender: TObject; const ByCoords: TOpenWeatherByCoords) of object;

  TOpenWeatherRequest = (ByCoords);

  TOpenWeatherAPI = class(TObject)
  private
    FOnByCoords: TOpenWeatherByCoordsEvent;
    procedure DoByCoords(const AByCoords: TOpenWeatherByCoords);
    procedure DoProcessContent(const AContent: string; const ARequest: TOpenWeatherRequest);
    procedure DoProcessContentByCoords(const AContent: string);
    procedure DoSendRequest(const AURL: string; const ARequest: TOpenWeatherRequest);
  public
    procedure GetByCoords(const ALatitude, ALongitude: Double);
    property OnByCoords: TOpenWeatherByCoordsEvent read FOnByCoords write FOnByCoords;
  end;

implementation

uses
  System.Classes, System.Threading, System.SysUtils, System.Net.HttpClient, System.NetEncoding,
  REST.Json,
  OW.Consts;

{ TOpenWeatherAPI }

procedure TOpenWeatherAPI.DoProcessContent(const AContent: string; const ARequest: TOpenWeatherRequest);
begin
  case ARequest of
    TOpenWeatherRequest.ByCoords:
      DoProcessContentByCoords(AContent);
  end;
end;

procedure TOpenWeatherAPI.DoProcessContentByCoords(const AContent: string);
var
  LByCoords: TOpenWeatherByCoords;
begin
  try
    LByCoords := TJson.JsonToObject<TOpenWeatherByCoords>(AContent);
    TThread.Synchronize(nil,
      procedure
      begin
        DoByCoords(LByCoords);
      end
    );
  except
    // Left as an exercise to the reader
  end;
end;

procedure TOpenWeatherAPI.DoByCoords(const AByCoords: TOpenWeatherByCoords);
begin
  if Assigned(FOnByCoords) then
    FOnByCoords(Self, AByCoords);
end;

procedure TOpenWeatherAPI.DoSendRequest(const AURL: string; const ARequest: TOpenWeatherRequest);
var
  LHTTP: THTTPClient;
  LResponse: IHTTPResponse;
begin
  LHTTP := THTTPClient.Create;
  try
    LResponse := LHTTP.Get(AURL);
    if LResponse.StatusCode = cHTTPResultOK then
      DoProcessContent(LResponse.ContentAsString, ARequest)
    else ; // Left as an exercise to the reader
  finally
    LHTTP.Free;
  end;
end;

procedure TOpenWeatherAPI.GetByCoords(const ALatitude, ALongitude: Double);
var
 LQuery: string;
begin
  LQuery := Format(cOpenWeatherByCoordsQuery, [cOpenWeatherAPIKey, ALatitude, ALongitude]);
  TTask.Run(
    procedure
    begin
      DoSendRequest(cOpenWeatherByCoordsURL + LQuery, TOpenWeatherRequest.ByCoords);
    end
  );
end;

end.
