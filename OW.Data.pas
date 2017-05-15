unit OW.Data;

interface

(*
  Example:

{
  "coord":{
    "lon":138.58,
    "lat":-34.89
  },
  "weather":[
    {
      "id":800,
      "main":"Clear",
      "description":"clear sky",
      "icon":"01d"
    }
  ],
  "base":"stations",
  "main":{
    "temp":292.15,
    "pressure":1020,
    "humidity":42,
    "temp_min":292.15,
    "temp_max":292.15
  },
  "visibility":10000,
  "wind":{
    "speed":5.7,
    "deg":240
  },
  "clouds":{
    "all":0
  },
  "dt":1494738000,
  "sys":{
    "type":1,
    "id":8204,
    "message":0.0044,
    "country":"AU",
    "sunrise":1494711125,
    "sunset":1494748298
  },
  "id":2062944,
  "name":"Prospect",
  "cod":200
}

*)

type
  TOpenWeatherCoords = class(TObject)
  private
    Flon: Double;
    Flat: Double;
  public
    property lon: Double read Flon;
    property lat: Double read Flat;
  end;

  TOpenWeatherSys = class(TObject)
  private
    Fcountry: string;
    Fsunrise: Integer;
    Fsunset: Integer;
  public
    property country: string read Fcountry;
    property sunrise: Integer read Fsunrise;
    property sunset: Integer read Fsunset;
  end;

  TOpenWeatherWeatherItem = class(TObject)
  private
    Fid: Integer;
    Fmain: string;
    Fdescription: string;
    Ficon: string;
  public
    property id: Integer read Fid;
    property main: string read Fmain;
    property description: string read Fdescription;
    property icon: string  read Ficon;
  end;

  TOpenWeatherWeather = array of TOpenWeatherWeatherItem;

  TOpenWeatherMain = class(TObject)
  private
    Ftemp: Double;
    Fhumidity: Double;
    Fpressure: Double;
    Ftemp_min: Double;
    Ftemp_max: Double;
  public
    property temp: Double read Ftemp;
    property humidity: Double read Fhumidity;
    property pressure: Double read Fpressure;
    property temp_min: Double read Ftemp_min;
    property temp_max: Double read Ftemp_max;
  end;

  TOpenWeatherWind = class(TObject)
  private
    Fspeed: Double;
    Fdegrees: Double;
  public
    property speed: Double read Fspeed;
    property degrees: Double read Fdegrees;
  end;

  TOpenWeatherClouds = class(TObject)
  private
    Fall: Double;
  public
    property all: Double read Fall;
  end;

  TOpenWeatherRain = class(TObject)
  private
    F3h: Double;
  public
    property vol3h: Double read F3h;
  end;

  TOpenWeatherByCoords = class(TObject)
  private
    Fcoord: TOpenWeatherCoords;
    Fsys: TOpenWeatherSys;
    Fweather: TOpenWeatherWeather;
    Fmain: TOpenWeatherMain;
    Fwind: TOpenWeatherWind;
    Frain: TOpenWeatherRain;
    Fclouds: TOpenWeatherClouds;
    Fdt: Integer;
    Fid: Integer;
    Fname: string;
    Fcod: Integer;
  public
    property coord: TOpenWeatherCoords read Fcoord;
    property sys: TOpenWeatherSys read Fsys;
    property weather: TOpenWeatherWeather read Fweather;
    property main: TOpenWeatherMain read Fmain;
    property wind: TOpenWeatherWind read Fwind;
    property rain: TOpenWeatherRain read Frain;
    property clouds: TOpenWeatherClouds read Fclouds;
    property dt: Integer read Fdt;
    property id: Integer read Fid;
    property name: string read Fname;
    property cod: Integer read Fcod;
  end;

implementation

end.
