program Project1;

uses
  Forms,
  Unit6 in 'Unit6.pas' {Form6},
  ComPort in 'ComPort.pas',
  LightControl in 'LightControl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.
