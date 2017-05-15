program OpenWeatherDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainFrm in 'MainFrm.pas' {frmMain},
  OW.Data in 'OW.Data.pas',
  OW.API in 'OW.API.pas',
  OW.Consts in 'OW.Consts.pas',
  OW.Graphics.Net.Helpers in 'OW.Graphics.Net.Helpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
