unit LightControl;

interface

uses
  SysUtils, Generics.Collections, Math, Windows;

type
  TLampe = class(TObject)
  private
    fR, fG, fB: Integer;              // 0..4095
    fH, fS, fV: Real;                 // 0..2*Pi, 0..1, 0..1
    fHasChanged: boolean;
    procedure RGBToHSV;
    procedure HSVToRGB;
    function BoundRGB(const aValue: Integer): Integer;
    function BoundFraction(const aValue: Real): Real;
    function BoundAngle(const aValue: Real): Real;
  public
    property R: Integer read fR;
    property G: Integer read fG;
    property B: Integer read fB;
    property H: Real read fH;
    property S: Real read fS;
    property V: Real read fV;
    property HasChanged: boolean read fHasChanged write fHasChanged;
    procedure SetColorRGB(aR, aG, aB: Integer);
    procedure SetColorHSV(aH, aSat, aV: Real);
  end;

  TLightControl = class(TObject)
  private
    fHelligkeit: Real;
    fSaettigung: Real;
    fGeschwindigkeit: Real;
    fWinkelDifferenz: Real;
  public
    fMessageCounter: Integer;
    fLampen: TList<TLampe>;
    fStartWinkel: Real;
    constructor Create(const anzahlLampen: Integer);
    destructor Destroy;
    function SetzeHelligkeit(einWert: Real): AnsiString;
    function SetzeHelligkeitProzent(einWert: Real): AnsiString;
    function SetzeSaettigung(einWert: Real): AnsiString;
    function SetzeSaettigungProzent(einWert: Real): AnsiString;
    function SetzeGeschwindigkeit(deltaPhi: Real): AnsiString;
    function SetzeGeschwindigkeitGrad(deltaPhi: Real): AnsiString;
    function StarteMoodlight(startFarbe, farbUnterschied: Real): AnsiString;
    function StarteMoodlightGrad(startFarbe, farbUnterschied: Real): AnsiString;
    function SchalteLampe(nummer: Integer; istAn: boolean): AnsiString;
    function SetzeFarbe(nummer, R, G, B: Integer): AnsiString;
    property Helligkeit: Real read fHelligkeit;
    property Saettigung: Real read fSaettigung;
    property Geschwindigkeit: Real read fGeschwindigkeit;
    property WinkelDifferenz: Real read fWinkelDifferenz;
  end;

implementation

{ TLightControl }

constructor TLightControl.Create(const anzahlLampen: Integer);
var
  i: Integer;
begin
  inherited Create;
  fHelligkeit := 0.75;
  fSaettigung := 0.9;
  fGeschwindigkeit := 0.01;
  fWinkelDifferenz := 135;
  Self.fLampen := TList<TLampe>.Create;
  for i := 0 to anzahlLampen - 1 do
    fLampen.Add(TLampe.Create);
end;

destructor TLightControl.Destroy;
var
  i: Integer;
begin
  for i := 0 to fLampen.Count - 1 do
    fLampen.Items[i].Free;
  fLampen.Free;
  inherited;
end;

function TLightControl.SchalteLampe(nummer: Integer;
  istAn: boolean): AnsiString;
begin

  if istAn then
    Result := '251,' + IntToStr(nummer) + ',1'
  else
    Result := '251,' + IntToStr(nummer) + ',0';

  Inc(fMessageCounter);

end;

function TLightControl.SetzeFarbe(nummer, R, G, B: Integer): AnsiString;
begin

  Result := IntToStr(nummer) + ',' + IntToStr(R) + ',' + IntToStr(G) +
    ',' + IntToStr(B);

  Inc(fMessageCounter);

end;

function TLightControl.SetzeGeschwindigkeit(deltaPhi: Real): AnsiString;
begin

  Result := SetzeGeschwindigkeitGrad(deltaPhi * 180 / Pi);

end;

function TLightControl.SetzeGeschwindigkeitGrad(deltaPhi: Real): AnsiString;
begin

  if (deltaPhi >= 0) and (deltaPhi <= 360) then
  begin
    fGeschwindigkeit := deltaPhi;
    DecimalSeparator := '.';
    Result := '252,' + FloatToStr(RoundTo(deltaPhi, -4));

    Inc(fMessageCounter);
  end;

end;

function TLightControl.SetzeHelligkeit(einWert: Real): AnsiString;
var
  i: Integer;
begin

  if (einWert >= 0) and (einWert <= 1) then
  begin
    fHelligkeit := einWert;
    DecimalSeparator := '.';
    Result := '254,' + FloatToStr(RoundTo(einWert, -4));

    for i := 0 to fLampen.Count - 1 do
    begin
      fLampen.Items[i].fV := einWert;
    end;

    Inc(fMessageCounter);
  end;

end;

function TLightControl.SetzeHelligkeitProzent(einWert: Real): AnsiString;
begin

  Result := SetzeHelligkeit(einWert / 100);

end;

function TLightControl.SetzeSaettigung(einWert: Real): AnsiString;
var
  i: Integer;
begin

  if (einWert >= 0) and (einWert <= 1) then
  begin
    fSaettigung := einWert;
    DecimalSeparator := '.';
    Result := '253,' + FloatToStr(RoundTo(einWert, -4));

    for i := 0 to fLampen.Count - 1 do
    begin
      fLampen.Items[i].fS := einWert;
    end;

    Inc(fMessageCounter);
  end;

end;

function TLightControl.SetzeSaettigungProzent(einWert: Real): AnsiString;
begin

  Result := SetzeSaettigung(einWert / 100);

end;

function TLightControl.StarteMoodlight(startFarbe,
  farbUnterschied: Real): AnsiString;
begin

  Result := StarteMoodlightGrad(startFarbe * 180 / Pi,
    farbUnterschied * 180 / Pi);

end;

function TLightControl.StarteMoodlightGrad(startFarbe,
  farbUnterschied: Real): AnsiString;
begin

  if (startFarbe >= 0) and (startFarbe <= 360) and
     (farbUnterschied >= 0) and (farbUnterschied <= 360) then
  begin
    fWinkelDifferenz := farbUnterschied;
    DecimalSeparator := '.';
    Result := '255,' + FloatToStr(RoundTo(startFarbe, -4)) + ',' +
      FloatToStr(RoundTo(farbUnterschied, -4));

    Inc(fMessageCounter);
  end;

end;

{ TLampe }

{* Stellt sicher, dass ein übergebener Winkel in Radians zwischen
 * 0 und 2*Pi liegt. Bei Winkeln bis -2*Pi bzw. +4*Pi wird entsprechend
 * auf den gültigen Bereich umgerechnet. Bei allen anderen werten wird
 * auf 0..2*Pi begrenzt.}
function TLampe.BoundAngle(const aValue: Real): Real;
begin
  if (aValue >= 0) and (aValue <= 2*Pi) then
    Result := aValue
  else if aValue < 0 then
    Result := Max(2*Pi + aValue, 0)
  else
    Result := Min(aValue - 2*Pi, 2*Pi);
end;

{* Stellt sicher, dass ein übergebener Wert zwischen 0 und 1 liegt. *}
function TLampe.BoundFraction(const aValue: Real): Real;
begin
  if (aValue >= 0) and (aValue <= 1) then
    Result := aValue
  else if aValue < 0 then
    Result := 0
  else
    Result := 1;
end;

{* Stellt sicher, dass ein übergebener RGB-Wert zwischen 0 und 4095 liegt. *}
function TLampe.BoundRGB(const aValue: Integer): Integer;
begin
  if (aValue >= 0) and (aValue <= 4095) then
    Result := aValue
  else if aValue < 0 then
    Result := 0
  else
    Result := 4095;
end;

procedure TLampe.HSVToRGB;
var
  C, X, m, ht: Real;
  rs, gs, bs: Real;
  rm: Real;
begin

  if fS = 0 then              // Sonderfall weiß bzw. grau
  begin
    fR := Round(fV * 4095);
    fG := Round(fV * 4095);
    fB := Round(fV * 4095);
  end
  else                        // Alle anderen fälle
  begin
    ht := fH * 180 / Pi;      // hue in Grad umrechnen
    C := fV * fS;
    rm := ht / 60 - 2 * trunc(ht / 60 / 2);  // Modulo Division für Real
    X := C * (1 - abs(rm - 1));
    m := fV - C;

    if fH < Pi / 3 then
    begin
      rs := C;
      gs := X;
      bs := 0;
    end
    else if fH < 2 * Pi / 3 then
    begin
      rs := X;
      gs := C;
      bs := 0;
    end
    else if fH < Pi then
    begin
      rs := 0;
      gs := C;
      bs := X;
    end
    else if fH < 4 * Pi / 3 then
    begin
      rs := 0;
      gs := X;
      bs := C;
    end
    else if fH < 5 * Pi / 3 then
    begin
      rs := X;
      gs := 0;
      bs := C;
    end
    else
    begin
      rs := C;
      gs := 0;
      bs := X;
    end;

    fR := Round((rs + m) * 4095);
    fG := Round((gs + m) * 4095);
    fB := Round((bs + m) * 4095);
  end;
end;

procedure TLampe.RGBToHSV;
var
  Maximum, Minimum: Real;
  Rc, Gc, Bc: Real;
begin
  Maximum := Max(fR, Max(fG, fB));
  Minimum := Min(fR, Min(fG, fB));
  fV := Maximum / 4095;
  if Maximum <> 0 then
    fS := (Maximum - Minimum) / Maximum
  else
    fS := 0;

  if fS = 0 then
    fH := 0 // arbitrary value
  else
  begin
    Assert(Maximum <> Minimum);
    Rc := (Maximum - fR) / (Maximum - Minimum);
    Gc := (Maximum - fG) / (Maximum - Minimum);
    Bc := (Maximum - fB) / (Maximum - Minimum);
    if fR = Maximum then
      fH := Bc - Gc
    else if fG = Maximum then
      fH := 2 + Rc - Bc
    else
    begin
      Assert(fB = Maximum);
      fH := 4 + Gc - Rc;
    end;
    fH := fH * Pi / 3;
    fH := BoundAngle(fH);
  end;
end;

procedure TLampe.SetColorHSV(aH, aSat, aV: Real);
begin
  if (fH <> aH) or (fS <> aSat) or (fV <> aV) then
  begin
    fH := BoundAngle(aH);
    fS := BoundFraction(aSat);
    fV := BoundFraction(aV);
    HSVToRGB;
    fHasChanged := true;
  end;
end;

procedure TLampe.SetColorRGB(aR, aG, aB: Integer);
begin
  if (fR <> aR) or (fG <> aG) or (fB <> aB) then
  begin
    fR := BoundRGB(aR);
    fG := BoundRGB(aG);
    fB := BoundRGB(aB);
    RGBToHSV;
    fHasChanged := true;
  end;
end;

end.
