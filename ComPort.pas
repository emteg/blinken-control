unit ComPort;

interface

uses
  Windows, SysUtils;

type
  TComPortWriteLnEvent = procedure(const aLine: AnsiString) of object;

  TComPort = class(TObject)
  private
    fHandle: THandle;
    fIsOpen, fIsSetup: boolean;
    fOnWriteLn: TComPortWriteLnEvent;
    procedure DoOnWriteLn(const aLine: AnsiString);
  public
    constructor Create;
    destructor Destroy; override;
    function Open(aDeviceName: String): boolean;
    function Setup(aBaudRate: Cardinal): boolean;
    procedure WriteLn(aString: AnsiString);
    procedure Close;
    property OnWriteLn: TComPortWriteLnEvent read fOnWriteLn write fOnWriteLn;
  end;

implementation

{ TComPort }

procedure TComPort.Close;
begin
  fIsOpen := false;
  fIsSetup := false;
  CloseHandle(fHandle);
end;

constructor TComPort.Create;
begin
  inherited Create;
  fIsOpen := false;
  fIsSetup := false;
  fOnWriteLn := nil;
end;

destructor TComPort.Destroy;
begin
  Close;
  inherited;
end;

procedure TComPort.DoOnWriteLn(const aLine: AnsiString);
begin
  if assigned(fOnWriteLn) then
    fOnWriteLn(aLine);
end;

{ First step is to open the communications device for read/write.
  This is achieved using the Win32 'CreateFile' function.
  If it fails, the function returns false. }
function TComPort.Open(aDeviceName: String): boolean;
var
  DeviceName: array[0..80] of Char;
begin
  if not fIsOpen then
  begin
    StrPCopy(DeviceName, aDeviceName);

    fHandle := CreateFile(DeviceName,
      GENERIC_READ or GENERIC_WRITE,
      0,
      nil,
      OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL,
      0);

    if fHandle = INVALID_HANDLE_VALUE then
      Result := False
    else
    begin
      Result := True;
      fIsOpen := True;
    end;
  end
  else
    Result := true;
end;

procedure TComPort.WriteLn(aString: AnsiString);
var
  BytesWritten: DWORD;
begin
  if (fIsOpen and fIsSetup) then
  begin
    aString := aString + #10;
    WriteFile(fHandle, aString[1], Length(aString), BytesWritten, nil);
    DoOnWriteLn(aString);
  end;
end;

function TComPort.Setup(aBaudRate: Cardinal): boolean;
const
  RxBufferSize = 256;
  TxBufferSize = 256;
var
  DCB: TDCB;
  Config: string;
  CommTimeouts: TCommTimeouts;
begin
  Result := True;

  if not SetupComm(fHandle, RxBufferSize, TxBufferSize) then
    Result := False;

  if not GetCommState(fHandle, DCB) then
    Result := False;

  Config := 'baud=' + IntToStr(aBaudRate) + ' parity=n data=8 stop=1';

  if not BuildCommDCB(@Config[1], DCB) then
    Result := False;

  if not SetCommState(fHandle, DCB) then
    Result := False;

  with CommTimeouts do
  begin
    ReadIntervalTimeout         := 0;
    ReadTotalTimeoutMultiplier  := 0;
    ReadTotalTimeoutConstant    := 1000;
    WriteTotalTimeoutMultiplier := 0;
    WriteTotalTimeoutConstant   := 1000;
  end;

  if not SetCommTimeouts(fHandle, CommTimeouts) then
    Result := False;

  fIsSetup := Result;
end;

end.
