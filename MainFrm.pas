unit MainFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Sensors, System.Sensors.Components,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  OW.API, OW.Data;

type
  TfrmMain = class(TForm)
    LocationSensor: TLocationSensor;
    HeaderLayout: TLayout;
    WeatherImage: TImage;
    LocationLabel: TLabel;
    HeaderDetailsLayout: TLayout;
    WeatherMainLabel: TLabel;
    TemperatureLabel: TLabel;
    BackgroundImage: TImage;
    WindLayout: TLayout;
    WindLabel: TLabel;
    WindDetailsLayout: TLayout;
    HumidityLayout: TLayout;
    HumidityLabel: TLabel;
    HumidityValueLabel: TLabel;
    PressureLayout: TLayout;
    PressureLabel: TLabel;
    PressureValueLabel: TLabel;
    RainLayout: TLayout;
    RainLabel: TLabel;
    RainValueLabel: TLabel;
    WindSpeedLayout: TLayout;
    WindSpeedLabel: TLabel;
    WindSpeedValueLabel: TLabel;
    WindDirectionLayout: TLayout;
    WindDirectionLabel: TLabel;
    WindDirectionValueLabel: TLabel;
    WeatherLargeImage: TImage;
    procedure LocationSensorLocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
  private
    FAPI: TOpenWeatherAPI;
    FImagesPath: string;
    FUseFarenheit: Boolean;
    procedure APIByCoordsHandler(Sender: TObject; const AByCoords: TOpenWeatherByCoords);
    function GetTemperatureText(const AKelvin: Double): string;
    procedure Start;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.IOUtils,
  OW.Consts, OW.Graphics.Net.Helpers;

function FahrenheitToCelsius(const AFahrenheit: Double): Double;
begin
  Result := (AFahrenheit - 32.0) / 1.8;
end;

function CelsiusToFahrenheit(const ACelsius: Double): Double;
begin
  Result := ACelsius * 1.8 + 32.0;
end;

function KelvinToCelsius(const AKelvin: Double): Double;
begin
  Result := AKelvin - 273.15;
end;

function KelvinToFahrenheit(const AKelvin: Double): Double;
begin
  Result := CelsiusToFahrenheit(KelvinToCelsius(AKelvin))
end;

function BearingToDirection(const ABearing: Double): string;
const
  cDirections: array[0..8] of string = ('N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW', 'N');
var
  LDirectionIndex: Integer;
begin
  LDirectionIndex := Trunc(2 * ABearing) div 45;
  Result := cDirections[LDirectionIndex];
end;

{ TfrmMain }

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  {$IF Defined(DEBUG) and Defined(MSWINDOWS)}
  // Hack job to load the background image from the right location
  FImagesPath := TPath.GetDirectoryName(ParamStr(0));
  FImagesPath := TPath.GetDirectoryName(FImagesPath);
  FImagesPath := TPath.GetDirectoryName(FImagesPath);
  {$ELSE IF Defined(MACOS)}
  FImagesPath := TPath.Combine(TPath.GetDocumentsPath, 'OpenWeatherDemo');
  {$ELSE}
  FImagesPath := TPath.GetDocumentsPath;
  {$ENDIF}
  FImagesPath := TPath.Combine(FImagesPath, 'Images');
  FAPI := TOpenWeatherAPI.Create;
  FAPI.OnByCoords := APIByCoordsHandler;
  Start;
end;

destructor TfrmMain.Destroy;
begin
  FAPI.Free;
  inherited;
end;

function TfrmMain.GetTemperatureText(const AKelvin: Double): string;
begin
  if FUseFarenheit then
    Result := Format('%.1f°F', [KelvinToFahrenheit(AKelvin)])
  else
    Result := Format('%.1f°C', [KelvinToCelsius(AKelvin)]);
end;

procedure TfrmMain.LocationSensorLocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
begin
  // Have location now, so turn off the sensor
  LocationSensor.Active := False;
  FAPI.GetByCoords(NewLocation.Latitude, NewLocation.Longitude);
end;

procedure TfrmMain.Start;
begin
  {$IF Defined(DEBUG) and Defined(MSWINDOWS)}
  FAPI.GetByCoords(-34.8877, 138.5833); // Dave's suburb in Adelaide, Australia!
  {$ENDIF}
  LocationSensor.Active := True;
end;

procedure TfrmMain.APIByCoordsHandler(Sender: TObject; const AByCoords: TOpenWeatherByCoords);
var
  LWeather: TOpenWeatherWeatherItem;
begin
  LocationLabel.Text := AByCoords.name;
  TemperatureLabel.Text := GetTemperatureText(AByCoords.main.temp);
  if Length(AByCoords.weather) > 0 then
  begin
    LWeather := AByCoords.weather[0];
    WeatherImage.Bitmap.LoadFromURL(cOpenWeatherWeatherImagesURL + LWeather.icon + '.png');
    WeatherLargeImage.Bitmap.LoadFromFile(TPath.Combine(FImagesPath, LWeather.icon.Substring(0, 2) + '.png'));
    WeatherMainLabel.Text := LWeather.main;
  end;
  if AByCoords.rain <> nil then
    RainValueLabel.Text := Format('%.1f mm', [AByCoords.rain.vol3h])
  else
    RainValueLabel.Text := 'Nil';
  HumidityValueLabel.Text := Format('%.0f %', [AByCoords.main.humidity]);
  PressureValueLabel.Text := Format('%.1f hPa', [AByCoords.main.pressure]);
  WindSpeedValueLabel.Text := Format('%.1f km/h', [AByCoords.wind.speed]);
  WindDirectionValueLabel.Text := BearingToDirection(AByCoords.wind.degrees);
end;

end.
