unit OW.Graphics.Net.Helpers;

interface

uses
  System.Classes,
  FMX.Graphics;

type
  TBitmapHelper = class helper for TBitmap
  private
    procedure DoLoadFromURL(const AURL: string);
    procedure SynchedLoadFromStream(const AStream: TStream);
  public
    procedure LoadFromURL(const AURL: string);
  end;

implementation

uses
  System.Threading, System.Net.HttpClient;

{ TBitmapHelper }

procedure TBitmapHelper.SynchedLoadFromStream(const AStream: TStream);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      LoadFromStream(AStream);
    end
  );
end;

procedure TBitmapHelper.DoLoadFromURL(const AURL: string);
var
  LHTTP: THTTPClient;
  LResponse: IHTTPResponse;
begin
  LHTTP := THTTPClient.Create;
  try
    LResponse := LHTTP.Get(AURL);
    if LResponse.StatusCode = 200 then
      SynchedLoadFromStream(LResponse.ContentStream)
    else ; // Left as an exercise to the reader
  finally
    LHTTP.Free;
  end;
end;

procedure TBitmapHelper.LoadFromURL(const AURL: string);
begin
  TTask.Run(
    procedure
    begin
      DoLoadFromURL(AURL);
    end
  );
end;

end.
