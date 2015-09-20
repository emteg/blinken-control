object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Form6'
  ClientHeight = 508
  ClientWidth = 648
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 102
    Top = 13
    Width = 76
    Height = 13
    Caption = 'Anzahl Lampen:'
  end
  object Label8: TLabel
    Left = 232
    Top = 13
    Width = 124
    Height = 13
    Caption = 'Nachrichten pro Sekunde:'
  end
  object LabelNachrichtenProSekunde: TLabel
    Left = 362
    Top = 13
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Port '#246'ffnen'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 39
    Width = 648
    Height = 469
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    DoubleBuffered = True
    Enabled = False
    ParentBackground = False
    ParentDoubleBuffered = False
    ShowCaption = False
    TabOrder = 1
    DesignSize = (
      648
      469)
    object GroupBox1: TGroupBox
      Left = 8
      Top = 0
      Width = 631
      Height = 281
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Moodlight'
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      DesignSize = (
        631
        281)
      object Label1: TLabel
        Left = 16
        Top = 21
        Width = 215
        Height = 13
        Caption = 'Winkeldifferenz zwischen den Lampen (Grad)'
      end
      object Label2: TLabel
        Left = 16
        Top = 85
        Width = 286
        Height = 13
        Caption = 'Farbwinkelgeschwindigkeit (in 0,01 Grad-Schritten pro Takt)'
      end
      object Label3: TLabel
        Left = 16
        Top = 147
        Width = 64
        Height = 13
        Caption = 'Helligkeit (%)'
      end
      object Label4: TLabel
        Left = 16
        Top = 211
        Width = 68
        Height = 13
        Caption = 'S'#228'ttigung (%)'
      end
      object ButtonWinkelDifferenz: TButton
        Left = 543
        Top = 38
        Width = 74
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Setzen'
        TabOrder = 0
        OnClick = ButtonWinkelDifferenzClick
      end
      object ButtonWinkelgeschwindigkeit: TButton
        Left = 543
        Top = 102
        Width = 74
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Setzen'
        TabOrder = 1
        OnClick = ButtonWinkelgeschwindigkeitClick
      end
      object EditWinkelDifferenz: TEdit
        Left = 495
        Top = 40
        Width = 42
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 2
        Text = '135'
      end
      object EditWinkelgeschwindigkeit: TEdit
        Left = 495
        Top = 104
        Width = 42
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 3
        Text = '0,01'
      end
      object TrackBarWinkelDifferenz: TTrackBar
        Left = 8
        Top = 40
        Width = 481
        Height = 45
        Anchors = [akLeft, akTop, akRight]
        Max = 360
        Position = 135
        TabOrder = 4
        OnChange = TrackBarWinkelDifferenzChange
      end
      object TrackBarWinkelgeschwindigkeit: TTrackBar
        Left = 8
        Top = 104
        Width = 481
        Height = 45
        Anchors = [akLeft, akTop, akRight]
        Max = 2000
        Position = 1
        TabOrder = 5
        OnChange = TrackBarWinkelgeschwindigkeitChange
      end
      object TrackBarHelligkeit: TTrackBar
        Left = 8
        Top = 166
        Width = 481
        Height = 45
        Anchors = [akLeft, akTop, akRight]
        Max = 200
        Position = 150
        TabOrder = 6
        OnChange = TrackBarHelligkeitChange
      end
      object EditHelligkeit: TEdit
        Left = 495
        Top = 166
        Width = 42
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 7
        Text = '75'
      end
      object ButtonHelligkeit: TButton
        Left = 543
        Top = 164
        Width = 74
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Setzen'
        TabOrder = 8
        OnClick = ButtonHelligkeitClick
      end
      object TrackBarSaettigung: TTrackBar
        Left = 8
        Top = 230
        Width = 481
        Height = 45
        Anchors = [akLeft, akTop, akRight]
        Max = 200
        Position = 180
        TabOrder = 9
        OnChange = TrackBarSaettigungChange
      end
      object EditSaettigung: TEdit
        Left = 495
        Top = 230
        Width = 42
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 10
        Text = '90'
      end
      object ButtonSaettigung: TButton
        Left = 543
        Top = 228
        Width = 74
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Setzen'
        TabOrder = 11
        OnClick = ButtonSaettigungClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 287
      Width = 185
      Height = 178
      Caption = 'Beat Steuerung'
      TabOrder = 1
      object Label6: TLabel
        Left = 16
        Top = 56
        Width = 32
        Height = 13
        Caption = 'Aktuell'
      end
      object Label7: TLabel
        Left = 102
        Top = 56
        Width = 20
        Height = 13
        Caption = 'Max'
      end
      object LabelVUMeterAktuell: TLabel
        Left = 78
        Top = 56
        Width = 6
        Height = 13
        Alignment = taRightJustify
        Caption = '0'
      end
      object LabelVUMeterMax: TLabel
        Left = 164
        Top = 56
        Width = 6
        Height = 13
        Alignment = taRightJustify
        Caption = '0'
      end
      object Label9: TLabel
        Left = 16
        Top = 75
        Width = 109
        Height = 13
        Caption = 'Winkel pro Beat (Grad)'
      end
      object LabelVUWinkel: TLabel
        Left = 164
        Top = 76
        Width = 6
        Height = 13
        Alignment = taRightJustify
        Caption = '4'
      end
      object Label10: TLabel
        Left = 16
        Top = 149
        Width = 40
        Height = 13
        Caption = 'Minimum'
      end
      object LabelVUBeats: TLabel
        Left = 164
        Top = 25
        Width = 6
        Height = 13
        Alignment = taRightJustify
        Caption = '0'
      end
      object CheckBoxVUMeter: TCheckBox
        Left = 16
        Top = 24
        Width = 81
        Height = 17
        Caption = 'Verwenden'
        TabOrder = 0
        OnClick = CheckBoxVUMeterClick
      end
      object TrackBarVUWinkel: TTrackBar
        Left = 16
        Top = 95
        Width = 161
        Height = 45
        Max = 200
        Min = 1
        Position = 40
        TabOrder = 1
        OnChange = TrackBarVUWinkelChange
      end
      object EditVUMin: TEdit
        Left = 111
        Top = 146
        Width = 59
        Height = 21
        TabOrder = 2
        Text = '100'
        OnChange = EditVUMinChange
      end
    end
    object Memo1: TMemo
      Left = 208
      Top = 293
      Width = 431
      Height = 168
      Anchors = [akLeft, akTop, akRight, akBottom]
      Lines.Strings = (
        'Memo1')
      TabOrder = 2
    end
  end
  object Edit1: TEdit
    Left = 184
    Top = 10
    Width = 33
    Height = 21
    TabOrder = 2
    Text = '6'
  end
  object ALAudioIn1: TALAudioIn
    Device.AlternativeDevices = <>
    Device.DeviceName = 'Default'
    OutputPin.Form = Form6
    OutputPin.SinkPins = (
      Form6.ALVUMeter1.InputPin)
    Left = 264
    Top = 8
  end
  object ALVUMeter1: TALVUMeter
    InputPin.Form = Form6
    InputPin.SourcePin = Form6.ALAudioIn1.OutputPin
    OutputPins.Form = Form6
    Period = 150
    OnValueChange = ALVUMeter1ValueChange
    Left = 320
    Top = 8
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 552
    Top = 16
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer2Timer
    Left = 512
    Top = 16
  end
end
