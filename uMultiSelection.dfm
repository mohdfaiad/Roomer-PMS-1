object frmMultiSelection: TfrmMultiSelection
  Left = 0
  Top = 0
  Caption = 'List Selection'
  ClientHeight = 401
  ClientWidth = 245
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  Padding.Left = 5
  Padding.Right = 5
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object sPanel1: TsPanel
    Left = 5
    Top = 368
    Width = 235
    Height = 33
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object sButton1: TsButton
      Left = 81
      Top = 3
      Width = 70
      Height = 25
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'OK'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 82
      Images = DImages.PngImageList1
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      SkinData.SkinSection = 'BUTTON'
    end
    object sButton2: TsButton
      Left = 155
      Top = 4
      Width = 70
      Height = 25
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Cancel = True
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 10
      Images = DImages.PngImageList1
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object pnlHeader: TsPanel
    Left = 5
    Top = 0
    Width = 235
    Height = 31
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
    object lblHeader: TsLabel
      Left = 6
      Top = 10
      Width = 45
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'lblHeader'
      ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
  end
  object lstItems: TsCheckListBox
    Left = 5
    Top = 31
    Width = 235
    Height = 337
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alClient
    BorderStyle = bsSingle
    Color = 3355443
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 15724527
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    MultiSelect = True
    ParentFont = False
    TabOrder = 2
    OnClick = lstItemsClick
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -13
    BoundLabel.Font.Name = 'Tahoma'
    BoundLabel.Font.Style = []
    SkinData.SkinSection = 'EDIT'
  end
end
