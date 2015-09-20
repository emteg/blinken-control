unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ComPort, LightControl, ALCommonMeter,
  ALVUMeter, LPComponent, ALAudioIn, Math;

type
  TForm6 = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    TrackBarWinkelDifferenz: TTrackBar;
    Label1: TLabel;
    EditWinkelDifferenz: TEdit;
    ButtonWinkelDifferenz: TButton;
    Label2: TLabel;
    TrackBarWinkelgeschwindigkeit: TTrackBar;
    EditWinkelgeschwindigkeit: TEdit;
    ButtonWinkelgeschwindigkeit: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    TrackBarHelligkeit: TTrackBar;
    EditHelligkeit: TEdit;
    ButtonHelligkeit: TButton;
    Label4: TLabel;
    TrackBarSaettigung: TTrackBar;
    EditSaettigung: TEdit;
    ButtonSaettigung: TButton;
    GroupBox2: TGroupBox;
    CheckBoxVUMeter: TCheckBox;
    Edit1: TEdit;
    Label5: TLabel;
    ALAudioIn1: TALAudioIn;
    ALVUMeter1: TALVUMeter;
    Label6: TLabel;
    Label7: TLabel;
    LabelVUMeterAktuell: TLabel;
    LabelVUMeterMax: TLabel;
    Timer1: TTimer;
    Label8: TLabel;
    LabelNachrichtenProSekunde: TLabel;
    Memo1: TMemo;
    TrackBarVUWinkel: TTrackBar;
    Label9: TLabel;
    LabelVUWinkel: TLabel;
    EditVUMin: TEdit;
    Label10: TLabel;
    LabelVUBeats: TLabel;
    Timer2: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonWinkelDifferenzClick(Sender: TObject);
    procedure TrackBarWinkelDifferenzChange(Sender: TObject);
    procedure ButtonWinkelgeschwindigkeitClick(Sender: TObject);
    procedure TrackBarWinkelgeschwindigkeitChange(Sender: TObject);
    procedure ButtonHelligkeitClick(Sender: TObject);
    procedure TrackBarHelligkeitChange(Sender: TObject);
    procedure TrackBarSaettigungChange(Sender: TObject);
    procedure ButtonSaettigungClick(Sender: TObject);
    procedure CheckBoxVUMeterClick(Sender: TObject);
    procedure ALVUMeter1ValueChange(Sender: TObject; AChannel: Integer; AValue,
      AMin, AMax: Real);
    procedure Timer1Timer(Sender: TObject);
    procedure TrackBarVUWinkelChange(Sender: TObject);
    procedure EditVUMinChange(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    procedure OnComPortWriteLn(const aLine: AnsiString);
    procedure DetectBeats(aValue: Real);
    procedure OnBeatDetected;
  public
    { Public-Deklarationen }
  end;

var
  Form6: TForm6;
  ComPort: TComPort;
  LightControl: TLightControl;
  VUmax, VUaktuell, VUMin: Extended;
  VUWinkel: Real;
  VUBeats: Integer;

implementation

{$R *.dfm}

procedure TForm6.ALVUMeter1ValueChange(Sender: TObject; AChannel: Integer;
  AValue, AMin, AMax: Real);
begin
  if CheckBoxVUMeter.Checked then
    DetectBeats(aValue);
end;

procedure TForm6.Button1Click(Sender: TObject);
begin
  if not assigned(ComPort) then
  begin
    ComPort := TComPort.Create;
    ComPort.OnWriteLn := OnComPortWriteLn;
  end;

  if assigned(LightControl) then
  begin
    LightControl.Free;
    LightControl := nil;
  end;

  LightControl := TLightControl.Create(StrToInt(Edit1.Text));

  if ComPort.Open('COM5:') and ComPort.Setup(9600) then
  begin
    Button1.Enabled := false;
    Panel1.Enabled := true;
    Edit1.Enabled := false;
  end
  else
    ShowMessage('COM-Port konnte nicht eingerichtet werden.');
end;


procedure TForm6.ButtonHelligkeitClick(Sender: TObject);
var
  brightness: Extended;
begin

  if TryStrToFloat(EditHelligkeit.Text, brightness) then
    ComPort.WriteLn(
      LightControl.SetzeHelligkeitProzent(brightness));

end;

procedure TForm6.Timer1Timer(Sender: TObject);
begin
  if assigned(LightControl) then
  begin
    LabelNachrichtenProSekunde.Caption := IntToStr(LightControl.fMessageCounter);
    LightControl.fMessageCounter := 0;
  end;
end;

procedure TForm6.Timer2Timer(Sender: TObject);
begin
  LabelVUBeats.Caption := IntToStr(VUBeats * 6) + ' BPM';
  VUBeats := 0;
end;

procedure TForm6.TrackBarHelligkeitChange(Sender: TObject);
var
  brightness: Extended;
begin

  brightness := TrackBarHelligkeit.Position / 2;
  ComPort.WriteLn(LightControl.SetzeHelligkeitProzent(brightness));
  EditHelligkeit.Text := FloatToStr(TrackBarHelligkeit.Position / 2);

end;

procedure TForm6.ButtonSaettigungClick(Sender: TObject);
var
  saturation: Extended;
begin

  if TryStrToFloat(EditSaettigung.Text, saturation) then
    ComPort.WriteLn(
      LightControl.SetzeSaettigungProzent(saturation));
end;

procedure TForm6.TrackBarSaettigungChange(Sender: TObject);
var
  saturation: Extended;
begin

  saturation := TrackBarSaettigung.Position / 2;
  ComPort.WriteLn(LightControl.SetzeSaettigungProzent(saturation));
  EditSaettigung.Text := FloatToStr(TrackBarSaettigung.Position / 2);

end;

procedure TForm6.TrackBarVUWinkelChange(Sender: TObject);
begin
  VUWinkel := TrackBarVUWinkel.Position / 10;
  LabelVUWinkel.Caption := FloatToStr(RoundTo(TrackBarVUWinkel.Position / 10, -2));
end;

procedure TForm6.ButtonWinkelDifferenzClick(Sender: TObject);
var
  diff: Extended;
begin

  if TryStrToFloat(EditWinkelDifferenz.Text, diff) then
    ComPort.WriteLn(LightControl.StarteMoodLightGrad(0, diff));

end;

procedure TForm6.TrackBarWinkelDifferenzChange(Sender: TObject);
var
  diff: Integer;
begin

  diff := TrackBarWinkelDifferenz.Position;
  ComPort.WriteLn(LightControl.StarteMoodLightGrad(0, diff));
  EditWinkelDifferenz.Text := IntToStr(diff);

end;

procedure TForm6.ButtonWinkelgeschwindigkeitClick(Sender: TObject);
var
  diff: Extended;
begin

  DecimalSeparator := ',';
  if TryStrToFloat(EditWinkelgeschwindigkeit.Text, diff) then
    ComPort.WriteLn(LightControl.SetzeGeschwindigkeitGrad(diff));

end;

procedure TForm6.CheckBoxVUMeterClick(Sender: TObject);
var
  anzahlLampen: Integer;
  deltaPhi: Real;
begin
  if TryStrToInt(Edit1.Text, anzahlLampen) and CheckBoxVUMeter.Checked then
  begin
    LightControl.fStartWinkel := 0;
    VUWinkel := TrackBarVUWinkel.Position / 10;
    ComPort.WriteLn(LightControl.SetzeGeschwindigkeitGrad(0));
    ComPort.WriteLn(LightControl.StarteMoodlightGrad(LightControl.fStartWinkel,
      LightControl.WinkelDifferenz));
    VUBeats := 0;
  end
  else if not CheckBoxVUMeter.Checked then
  begin
    deltaPhi := TrackBarWinkelgeschwindigkeit.Position / 100;
    ComPort.WriteLn(LightControl.SetzeGeschwindigkeitGrad(deltaPhi));
    ComPort.WriteLn(LightControl.StarteMoodlightGrad(LightControl.fStartWinkel,
      LightControl.WinkelDifferenz));
  end;
  if not TryStrToFloat(EditVUMin.Text, VUMin) then
    VUMin := 100;
  ALAudioIn1.Enabled := CheckBoxVUMeter.Checked;
  Timer2.Enabled := CheckBoxVUMeter.Checked;
end;

procedure TForm6.DetectBeats(aValue: Real);
begin
  if aValue > VUmax then
  begin
    VUmax := aValue;

    if aValue > VUMin then
      OnBeatDetected;
  end
  else
    VUmax := VUmax - 10;

  if VUmax < 0 then
    VUmax := 0;

  if VUmax > 2 * aValue then
    VUmax := VUmax / 2;

  VUaktuell := aValue;

  LabelVUMeterAktuell.Caption := IntToStr(Round(VUaktuell));
  LabelVUMeterMax.Caption := IntToStr(Round(VUmax));
end;

procedure TForm6.EditVUMinChange(Sender: TObject);
var
  neu: Integer;
begin
  if not TryStrToInt(EditVUMin.Text, neu) then
    neu := 100;

  VUMin := neu;
end;

procedure TForm6.OnBeatDetected;
begin
  LightControl.fStartWinkel := LightControl.fStartWinkel + VUWinkel;
  if LightControl.fStartWinkel > 360 then
    LightControl.fStartWinkel := LightControl.fStartWinkel - 360;

  ComPort.WriteLn(LightControl.StarteMoodlightGrad(LightControl.fStartWinkel,
    LightControl.WinkelDifferenz));

  Inc(VUBeats);
end;

procedure TForm6.OnComPortWriteLn(const aLine: AnsiString);
begin
  Memo1.Lines.Add(aLine);
end;

procedure TForm6.TrackBarWinkelgeschwindigkeitChange(Sender: TObject);
var
  deltaPhi: Extended;
begin

  deltaPhi := TrackBarWinkelgeschwindigkeit.Position / 100;
  ComPort.WriteLn(LightControl.SetzeGeschwindigkeitGrad(deltaPhi));
  DecimalSeparator := ',';
  EditWinkelgeschwindigkeit.Text := FloatToStr(deltaPhi);

end;

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if assigned(ComPort) then
    ComPort.Close;
end;

end.

