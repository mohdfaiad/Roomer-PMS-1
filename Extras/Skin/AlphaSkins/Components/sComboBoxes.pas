unit sComboBoxes;
{$I sDefs.inc}
//{$DEFINE LOGGED}
//+
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ComCtrls, ImgList, Dialogs, Forms,
  {$IFDEF LOGGED} sDebugMsgs, {$ENDIF}
  {$IFNDEF DELPHI5} types, {$ENDIF}
  {$IFNDEF DELPHI6UP} acD5Ctrls, {$ENDIF}
  sCommonData, sDefaults, sConst, acntUtils, sGraphUtils, acSBUtils, acAlphaImageList, sSpeedButton;


type
{$IFNDEF NOTFORHELP}
{$IFDEF DELPHI6UP}
  TsCustomComboBoxEx = class(TCustomComboBoxEx)
  private
    FReadOnly,
    FShowButton,
    FAllowMouseWheel: boolean;

    ExHandle: hwnd;
    State: integer;
    FBoundLabel: TsBoundLabel;
    FCommonData: TsCtrlSkinData;
    FDisabledKind: TsDisabledKind;
    procedure SetReadOnly    (const Value: boolean);
    procedure SetShowButton  (const Value: boolean);
    procedure SetDisabledKind(const Value: TsDisabledKind);
    procedure WMPaint    (var Message: TWMPaint);
    procedure WMDrawItem (var Message: TWMDrawItem); virtual;
    function GetSelectedItem: TComboExItem;
  protected
    lboxhandle: hwnd;
    FDropDown: boolean;
    ListSW: TacScrollWnd;
    FGlyphIndex: integer;
    function GetItemHt: Integer; override;
    function AllowDropDown: boolean; virtual;
    function AllowBtnStyle: boolean;
    function BrdWidth: integer;
    function DrawSkinItem(aIndex: Integer; aRect: TRect; aState: TOwnerDrawState; aDC: hdc): boolean; virtual;
    function ButtonHeight: integer;
    function ButtonRect: TRect;
    procedure PaintButton;
    procedure AnimateCtrl(AState: integer);
    procedure PrepareCache;
    procedure ComboWndProc(var Message: TMessage; ComboWnd: HWnd; ComboProc: Pointer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure UpdateIndexes;
    procedure DoDropDown; virtual;
    procedure WMLButtonDblClk (var Message: TMessage);       message WM_LBUTTONDBLCLK;
    procedure WMLButtonDown   (var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateWnd; override;
    destructor Destroy; override;
    procedure WndProc(var Message: TMessage); override;
    property SelectedItem: TComboExItem read GetSelectedItem;
  published
    property AllowMouseWheel: boolean read FAllowMouseWheel write FAllowMouseWheel default True;
    property BoundLabel: TsBoundLabel read FBoundLabel write FBoundLabel;
    property DisabledKind: TsDisabledKind read FDisabledKind write SetDisabledKind default DefDisabledKind;
    property ShowButton: boolean read FShowButton write SetShowButton default True;
    property SkinData: TsCtrlSkinData read FCommonData write FCommonData;
    property ReadOnly: boolean read FReadOnly write SetReadOnly default False;
  end;
{$ENDIF}
{$ENDIF} // NOTFORHELP


{$IFDEF DELPHI_XE3}[ComponentPlatformsAttribute(pidWin32 or pidWin64)]{$ENDIF}
  TsComboBoxEx = class(TsCustomComboBoxEx)
  published
{$IFNDEF NOTFORHELP}
{$IFDEF DELPHI7UP}
    property AutoCompleteOptions;
{$ENDIF}
    property ItemsEx;
    property Style;
{$IFDEF DELPHI6UP}
    property StyleEx;
{$ENDIF}
    property Action;
    property Align;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemIndex;
    property ItemHeight;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
{$IFDEF DELPHI6UP}
    property OnBeginEdit;
{$ENDIF}
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
{$IFDEF DELPHI6UP}
    property OnEndEdit;
{$ENDIF}
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
    property Images;
    property DropDownCount;
{$ENDIF} // NOTFORHELP
    property BoundLabel;
    property DisabledKind;
    property ShowButton;
    property SkinData;
    property ReadOnly;
  end;


{$IFNDEF NOTFORHELP}
{$IFDEF DELPHI6UP}
  TsColorBoxStyles = (cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors, cbSavedColors);
  TsColorBoxStyle = set of TsColorBoxStyles;

  TsCustomColorBox = class;
  TGetColorsEvent = procedure(Sender: TsCustomColorBox; Items: TStrings) of object;
  TOnColorName    = procedure(Sender: TsCustomColorBox; Value: TColor; var ColorName: string) of object;

  TacColorPopupMode = (pmColorList, pmPickColor);

  TsCustomColorBox = class(TsCustomComboBoxEx)
  private
    FSelectedColor,
    FNoneColorColor,
    FDefaultColorColor: TColor;

    FListSelected,
    FShowColorName: boolean;

    FMargin: integer;
    FStyle: TsColorBoxStyle;
    FPopupMode: TacColorPopupMode;
    FOnColorName: TOnColorName;
    FOnGetColors: TGetColorsEvent;
    function GetSelected: TColor;
    function GetColor(Index: Integer): TColor;
    function GetColorName(Index: Integer): string;
    procedure SetDefaultColorColor(const Value: TColor);
    procedure SetNoneColorColor   (const Value: TColor);
    procedure SetShowColorName    (const Value: boolean);
    procedure SetMargin           (const Value: integer);
    procedure SetSelected         (const AColor: TColor);
    procedure SetPopupMode        (const Value: TacColorPopupMode);
    procedure ColorCallBack       (const AName: string);
    procedure WMDrawItem(var Message: TWMDrawItem); override;
  protected
    procedure CloseUp; override;
    function AllowDropDown: boolean; override;
    function ColorRect(SourceRect: TRect; State: TOwnerDrawState): TRect;
    function DrawSkinItem(aIndex: Integer; aRect: TRect; aState: TOwnerDrawState; aDC: hdc): boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function PickCustomColor: Boolean;
    function GetItemHt: Integer; override;
    procedure PopulateList;
    procedure Select; override;
    procedure DoDropDown; override;
    procedure SetStyle(AStyle: TsColorBoxStyle); reintroduce;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateWnd; override;
    property ColorNames[Index: Integer]: string read GetColorName;
    property Colors[Index: Integer]: TColor read GetColor;
  published
    property Style: TsColorBoxStyle read FStyle write SetStyle default [cbStandardColors, cbExtendedColors, cbSystemColors];
    property Margin: integer read FMargin write SetMargin default 0;
    property ShowColorName: boolean read FShowColorName write SetShowColorName default True;

    property Selected:          TColor read GetSelected        write SetSelected          default clBlack;
    property DefaultColorColor: TColor read FDefaultColorColor write SetDefaultColorColor default clBlack;
    property NoneColorColor:    TColor read FNoneColorColor    write SetNoneColorColor    default clBlack;

    property PopupMode: TacColorPopupMode read FPopupMode write SetPopupMode default pmColorList;

    property OnColorName: TOnColorName    read FOnColorName write FOnColorName;
    property OnGetColors: TGetColorsEvent read FOnGetColors write FOnGetColors;
  end;
{$ENDIF}
{$ENDIF} // NOTFORHELP


{$IFDEF DELPHI_XE3}[ComponentPlatformsAttribute(pidWin32 or pidWin64)]{$ENDIF}
  TsColorBox = class(TsCustomColorBox)
{$IFNDEF NOTFORHELP}
  published
    property Align;
    property DisabledKind;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DropDownCount;
    property Enabled;
    property Font;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnCloseUp;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseUp;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
{$ENDIF} // NOTFORHELP
    property Style;
    property Margin;
    property Selected;
    property ShowColorName;
    property DefaultColorColor;
    property NoneColorColor;
    property SkinData;
  end;


  TsSkinSelector = class;


  TacSkinSelectBtn = class(TsSpeedButton)
  public
    FDoClick: boolean;
    procedure Click; override;
    constructor Create(AOwner: TComponent); override;
    procedure WndProc(var Message: TMessage); override;
  end;


  TacSkinSelectForm = class(TForm)
  protected
    ScrollBox: TWinControl;
    Selector: TsSkinSelector;
    ImgList: TsVirtualImageList;
  public
    BtnIndex,
    ItemCount,
    ItemWidth,
    ItemHeight: integer;
    procedure SetBtnIndex(NewIndex: integer);
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    procedure ClickBtn(AButton: TacSkinSelectBtn);
    procedure UpdateControls;
    procedure UpdateHotControl;
  end;


  TacThumbSize = (tsSmall, tsMedium, tsBig);

  TsSkinSelector = class(TsCustomComboBoxEx)
  private
    FColCount,
    FRowCount,
    FItemMargin,
    FMinItemWidth: byte;
    Form: TacSkinSelectForm;
    FShowNoSkin: boolean;
    FThumbSize: TacThumbSize;
    procedure SetThumbSize(const Value: TacThumbSize);
    procedure SetShowNoSkin(const Value: boolean);
  protected
    procedure PopulateList;
    procedure UpdateItemIndex;
    procedure DoDropDown; override;
    function AllowDropDown: boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure SetIndex(BtnIndex: integer; Step: integer);
  public
    procedure KillPopupForm;
    procedure Loaded; override;
    destructor Destroy; override;
    function DroppedDown: boolean;
    procedure CreateWnd; override;
    constructor Create(AOwner: TComponent); override;
    procedure WndProc(var Message: TMessage); override;
    procedure SetItemIndex(const Value: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure ComboWndProc(var Message: TMessage; ComboWnd: HWnd; ComboProc: Pointer); override;
  published
    property ItemMargin: byte read FItemMargin write FItemMargin default 4;
    property ColCount: byte read FColCount write FColCount default 3;
    property RowCount: byte read FRowCount write FRowCount default 5;
    property MinItemWidth: byte read FMinItemWidth write FMinItemWidth default 0;
    property ShowNoSkin: boolean read FShowNoSkin write SetShowNoSkin default True;
    property ThumbSize: TacThumbSize read FThumbSize write SetThumbSize default tsBig;

    property Align;
    property Anchors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property MaxLength;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
{
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
}
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDock;
    property OnStartDrag;
  end;


{$IFNDEF NOTFORHELP}
//var
//  ColDlg: TColorDialog = nil;

{$ENDIF} // NOTFORHELP


implementation

uses
  math, Consts, Buttons, Menus,
  {$IFDEF DELPHI7UP}Themes, {$ENDIF}
  sAlphaGraph, sMaskData, sSkinProps, sMessages, sVCLUtils, acGlow, sSkinManager, sDialogs, sFade,
  sStyleSimply, sThirdParty, sColorDialog, acPopupController, sScrollBox, sSkinProvider;


const
  StandardColorsCount = 16;
  ExtendedColorsCount = 4;
  NoColorSelected = TColor($FF000000);
  ThumbSizes: array [boolean, TacThumbSize] of integer = ((17, 50, 100), (24, 70, 140));


{$IFDEF DELPHI6UP}
function UpdateCombo_CB(Data: TObject; iIteration: integer): boolean;
var
  DC: HDC;
  R: TRect;
  Alpha: byte;
  Handle: THandle;
  sd: TsCommonData;
  cb: TsCustomComboBoxEx;
begin
  Result := False;
  if Data is TsCommonData then begin
    sd := TsCommonData(Data);
    if sd.FOwnerControl is TsCustomComboBoxEx then begin
      cb := TsCustomComboBoxEx(sd.FOwnerControl);
      Handle := cb.ExHandle;
      with sd.AnimTimer do
        if (Iterations > 0) and (Handle <> 0) then begin
          if BmpOut = nil then
            BmpOut := CreateBmp32(cb)
          else begin
            BmpOut.Width  := sd.FCacheBmp.Width;
            BmpOut.Height := sd.FCacheBmp.Height;
          end;
          BitBlt(BmpOut.Canvas.Handle, 0, 0, BmpOut.Width, BmpOut.Height, BmpFrom.Canvas.Handle, 0, 0, SRCCOPY);
          sd.AnimTimer.Value := Value + ValueStep;
          if State in [0, 2] then
            Glow := Glow - GlowStep
          else
            sd.AnimTimer.Glow := Glow + GlowStep;

          Alpha := LimitIt(Round(Value), 0, MaxByte);
          SumBmpRect(BmpOut, BmpTo, MaxByte - Alpha, MkRect(BmpOut), MkPoint);
          DC := GetDC(cb.ExHandle);
          try
            if cb.AllowBtnStyle then
              BitBlt(DC, 0, 0, BmpOut.Width, BmpOut.Height, BmpOut.Canvas.Handle, 0, 0, SRCCOPY)
            else begin
              BitBltBorder(DC, 0, 0, BmpOut.Width, BmpOut.Height, BmpOut.Canvas.Handle, 0, 0, 2);
              R := cb.ButtonRect;
              BitBlt(DC, R.Left, R.Top, WidthOf(R), HeightOf(R), BmpOut.Canvas.Handle, R.Left, R.Top, SRCCOPY);
            end;
          finally
            ReleaseDC(Handle, DC);
          end;

          Alpha := LimitIt(Round(Glow), 0, MaxByte);
          if sd.AnimTimer.Iteration >= sd.AnimTimer.Iterations then begin
            if (State = 0) and (Alpha > 0) then begin
              if sd.GlowID >= 0 then
                SetGlowAlpha(sd.GlowID, Alpha);

              Iteration := Iteration - 1;
              UpdateCombo_CB(Data, Iteration);
            end
            else
              if (State = 2) and (Value < MaxByte) then begin
                Iteration := Iteration - 1;
                UpdateCombo_CB(Data, iIteration);
              end
              else begin
                if State = 0 then
                  StopTimer(sd);

                if not (State in [1, 3]) then
                  HideGlow(sd.GlowID);
              end;
          end
          else begin
            Result := True;
            if sd.GlowID >= 0 then
              SetGlowAlpha(sd.GlowID, Alpha);
          end;
        end;
    end;
  end;
end;


procedure TsCustomComboBoxEx.UpdateIndexes;
begin
  with SkinData do
    if (SkinManager <> nil) and (SkinIndex >= 0) then
      FGlyphIndex := SkinManager.GetMaskIndex(SkinIndex, s_ItemGlyph)
    else
      FGlyphIndex := -1;
end;


function TsCustomComboBoxEx.BrdWidth: integer;
begin
  Result := 2;
end;


function TsCustomComboBoxEx.ButtonHeight: integer;
begin
  with SkinData, SkinManager.ConstData.ComboBtn do
    if Skinned and (GlyphIndex >= 0) then
      Result := SkinManager.ma[GlyphIndex].Height
    else
      Result := 16;
end;


function TsCustomComboBoxEx.ButtonRect: TRect;
var
  w: integer;
begin
  with SkinData, SkinManager.CommonSkinData do begin
    if (Style <> csExSimple) and FShowButton then
      w := GetComboBtnSize(SkinManager) - 1
    else
      w := 0;

    if UseRightToLeftAlignment then
      Result.Left := ComboBoxMargin
    else
      Result.Left := Width - w - ComboBoxMargin;

    Result.Top := ComboBoxMargin;
    Result.Right := Result.Left + w;
    Result.Bottom := Height - ComboBoxMargin;
  end;
end;


procedure TsCustomComboBoxEx.WMDrawItem(var Message: TWMDrawItem);
var
  ds: TDrawItemStruct;
  State: TOwnerDrawState;
begin
  if SkinData.Skinned then begin
    ds := Message.DrawItemStruct^;
    if ds.itemState and ODS_COMBOBOXEDIT = ODS_COMBOBOXEDIT then
      State := [odComboBoxEdit]
    else
      State := [];

    if ds.itemState and ODS_FOCUS = ODS_FOCUS then
      State := State + [odFocused];

    if ds.itemState and ODS_SELECTED = ODS_SELECTED then
      State := State + [odSelected];

    if ds.itemState and ODS_HOTLIGHT = ODS_HOTLIGHT then
      State := State + [odSelected];

    if ds.itemState and ODS_DISABLED = ODS_DISABLED then
      State := State + [odDisabled];

    Message.Result := LRESULT(DrawSkinItem(integer(ds.itemID), ds.rcItem, State, ds.hDC));
  end;
end;


procedure TsCustomComboBoxEx.ComboWndProc(var Message: TMessage; ComboWnd: HWnd; ComboProc: Pointer);
var
  DC: hdc;
  p: TPoint;
  i: integer;
  R, cR, bR: TRect;
  ps: TPaintStruct;
begin
  if FReadOnly or not AllowDropDown then
    case Message.Msg of
      WM_KEYDOWN, WM_CHAR, WM_KEYUP, WM_SYSKEYUP, CN_KEYDOWN, CN_CHAR, CN_SYSKEYDOWN, CN_SYSCHAR, WM_PASTE, WM_CUT, WM_CLEAR, WM_UNDO:
        Exit;

      WM_DRAWITEM: begin
        WMDrawItem(TWMDrawItem(Message));
        if Message.Result = 1 then
          Exit
      end;

      WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
        if ReadOnly then begin
          if not Focused then
            SetFocus;

          Exit;
        end
        else
          if not AllowDropdown then begin
            WndProc(Message);
            Exit;
          end;
    end;

  if not (csDestroying in ComponentState) and FCommonData.Skinned then
    case Message.Msg of
      SM_ALPHACMD:
        case Message.WParamHi of
          AC_MOUSELEAVE:
            if not (csDesigning in ComponentState) then
              SendMessage(Handle, CM_MOUSELEAVE, 0, 0);
        end;

      WM_MOUSEMOVE:
        if not (csDesigning in ComponentState) then begin
          SkinData.SkinManager.ActiveControl := Handle;
          if not DroppedDown and not AllowBtnStyle then begin
            GetWindowRect(Handle, R);
            bR := ButtonRect;
            OffsetRect(bR, R.Left, R.Top);
            p := acMousePos;
            i := integer(PtInRect(bR, p));
            if not ac_AllowHotEdits and (i <> State) then begin
              State := i;
              AnimateCtrl(1 + 2 * i);
            end;
          end;
          inherited;
          Exit;
        end;

      WM_KILLFOCUS, WM_SETFOCUS: begin
        SetRedraw(ExHandle, 0);
        inherited;
        SetRedraw(ExHandle, 1);
        Exit;
      end;

      WM_ERASEBKGND: begin
        Message.Result := 0;
        Exit;
      end;

      WM_NCPAINT: begin
        Message.Result := 1;
        Exit;
      end;

      WM_PAINT: begin
        if ComboWnd = ExHandle then
          if TWMPaint(Message).DC = 0 then begin
            DC := BeginPaint(ComboWnd, PS);
            if not InUpdating(SkinData) and not (SkinData.SkinManager.Effects.AllowAnimation and (SkinData.AnimTimer <> nil) and SkinData.AnimTimer.Enabled) then begin
              TWMPaint(Message).DC := DC;
              WMPaint(TWMPaint(Message));
            end;
            EndPaint(ComboWnd, PS);
          end
          else
            WMPaint(TWMPaint(Message))
        else
          if Enabled then
            inherited
          else begin
            DC := BeginPaint(ComboWnd, PS);
            if not SkinData.BGChanged then
              if not SkinData.FUpdating and not (SkinData.SkinManager.Effects.AllowAnimation and (SkinData.AnimTimer <> nil) and SkinData.AnimTimer.Enabled) then begin
                GetWindowRect(Handle, R);
                GetWindowRect(ComboWnd, cR);
                BitBlt(DC, 0, 0, Width, Height, SkinData.FCacheBmp.Canvas.Handle, cR.Left - R.Left, cR.Top - R.Top, SRCCOPY);
              end;

            EndPaint(ComboWnd, PS);
          end;

        Message.Result := 0;
        Exit;
      end;
    end;

  inherited;
end;


function TsCustomComboBoxEx.AllowDropDown: boolean;
begin
  Result := True;
end;


constructor TsCustomComboBoxEx.Create(AOwner: TComponent);
begin
  FCommonData := TsCtrlSkinData.Create(Self, True);
  FCommonData.COC := COC_TsComboBox;
  inherited;
  FDisabledKind := DefDisabledKind;
  FAllowMouseWheel := True;
  FBoundLabel := TsBoundLabel.Create(Self, FCommonData);
  FReadOnly := False;
  FDropDown := False;
  FShowButton := True;
end;


procedure TsCustomComboBoxEx.CreateWnd;
begin
  inherited;
  FCommonData.Loaded;
  ExHandle := GetWindow(Handle, GW_CHILD);
{$IFDEF DELPHI7UP}
{$IFNDEF D2009}
  if CheckWin32Version(5, 1) and ThemeServices.ThemesEnabled then
    SendMessage(Handle, $1701{CB_SETMINVISIBLE}, WPARAM(DropDownCount), 0);
{$ENDIF}
{$ENDIF}
  if HandleAllocated and FCommonData.Skinned then begin
    if not FCommonData.CustomColor then
      Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].Props[0].Color;

    if not FCommonData.CustomFont then
      Font.Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].Props[0].FontColor.Color;
  end;
  UpdateIndexes;
end;


destructor TsCustomComboBoxEx.Destroy;
begin
  if lBoxHandle <> 0 then begin
    SetWindowLong(lBoxHandle, GWL_STYLE, GetWindowLong(lBoxHandle, GWL_STYLE) and not WS_THICKFRAME or WS_BORDER);
    UninitializeACScroll(lBoxHandle, True, False, ListSW);
    lBoxHandle := 0;
  end;
  if HandleAllocated then // Avoiding of error in standard destructor under DX10 (linked with changed Style in CreateWnd)
    DestroyWindowHandle;

  inherited;
  FreeAndNil(FBoundLabel);
  FreeAndNil(FCommonData);
end;


function TsCustomComboBoxEx.DrawSkinItem(aIndex: Integer; aRect: TRect; aState: TOwnerDrawState; aDC: hdc): boolean;
var
  DC: hdc;
  Size: TSize;
  Bmp: TBitmap;
  CI: TCacheInfo;
  DrawStyle: Cardinal;
  R, gRect, rText: TRect;
  i, sNdx, imgNdx, State: integer;
  Skinned, bSelected, BtnStyle, bEdit: boolean;

  function GetFontColor: TColor;
  begin
    if Skinned then
      if (odSelected in AState) and not BtnStyle then
        Result := SkinData.SkinManager.GetHighLightFontColor(True)
      else
        if SkinData.CustomFont then
          Result := Font.Color
        else
          if bEdit then
            Result := SkinData.SkinManager.gd[SkinData.SkinIndex].Props[State].FontColor.Color
          else
            Result := SkinData.SkinManager.Palette[pcEditText]
    else
     Result := Font.Color
  end;

begin
  Result := True;
  Skinned := SkinData.Skinned;
  if aDC <> 0 then
    DC := aDC
  else
    DC := SkinData.FCacheBmp.Canvas.Handle;

  bSelected := False;
  bEdit := odComboBoxEdit in aState;
  BtnStyle := AllowBtnStyle and bEdit;
  CI.Ready := False;
  State := integer((ControlIsActive(SkinData) or Focused) and (SkinData.SkinManager.gd[SkinData.SkinIndex].States > 1));
  if bEdit then begin
    CI := MakeCacheInfo(FCommonData.FCacheBmp, aRect.Left, aRect.Top);
    CI.FillColor := SkinData.SkinManager.gd[SkinData.SkinIndex].Props[State].Color;
  end
  else begin
    CI.Bmp := nil;
    CI.Ready := False;
    CI.FillColor := SkinData.SkinManager.GetActiveEditColor;
  end;
  if (odSelected in aState) and not BtnStyle then
    if bEdit and (GetWindowLong(Handle, GWL_STYLE) and CBS_DROPDOWNLIST <> CBS_DROPDOWNLIST) {(Style <> csExDropDownList)} then
      sNdx := SkinData.SkinIndex
    else begin
      bSelected := True;
      sNdx := SkinData.SkinManager.ConstData.Sections[ssSelection];
    end
  else
    if bEdit then
      sNdx := SkinData.SkinIndex
    else
      sNdx := -1;

  Bmp := CreateBmp32(aRect);
  Bmp.Canvas.Font.Assign(Font);
  rText := MkRect(Bmp);
  if not bEdit and (aIndex >= 0) then begin
    if ItemsEx.ComboItems[aIndex].Indent >= 0 then begin
      i := 10 * ItemsEx.ComboItems[aIndex].Indent;
      FillDC(Bmp.Canvas.Handle, Rect(rText.Left, 0, rText.Left + i, Bmp.Height), CI.FillColor);
      rText.Left := rText.Left + i;
    end;
    if IsRectEmpty(rText) then
      Exit;
  end;

  if bSelected and not BtnStyle then
    if Style = csExDropDown then begin
//    if GetWindowLong(Handle, GWL_STYLE) and CBS_DROPDOWN = CBS_DROPDOWN {(Style = csExDropDown)} then begin
      FillDC(Bmp.Canvas.Handle, MkRect(Bmp), CI.FillColor);
      GetTextExtentPoint32(Bmp.Canvas.Handle, PChar(Items[aIndex]), Length(Items[aIndex]), Size);
      R := rText;
      if Images <> nil then
        R.Left := rText.Left + Images.Width + 2;

      R.Right := R.Left + Size.cx + 8;
      if sNdx < 0 then
        FillDC(Bmp.Canvas.Handle, MkRect(Bmp), SkinData.SkinManager.GetHighLightColor)
      else
        PaintItem(sNdx, CI, True, 1, R, MkPoint, Bmp, SkinData.SkinManager);
    end
    else
      if sNdx < 0 then
        FillDC(Bmp.Canvas.Handle, MkRect(Bmp), SkinData.SkinManager.GetHighLightColor)
      else
        PaintItem(sNdx, CI, True, 1, MkRect(Bmp), MkPoint, Bmp, SkinData.SkinManager)
  else
    if CI.Ready then
      BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, CI.Bmp.Canvas.Handle, CI.X, CI.Y, SRCCOPY)
    else
      FillDC(Bmp.Canvas.Handle, rText, CI.FillColor);

  DrawStyle := DT_NOPREFIX or DT_EXPANDTABS or DT_SINGLELINE or DT_VCENTER or DT_NOCLIP;
  InflateRect(rText, -2, 0);
  if Images <> nil then begin
    gRect := rText;
    gRect.Right := gRect.Left + Images.Width;
    rText.Left := gRect.Right + 4;
    if aIndex >= 0 then begin
      if bEdit and (ItemsEx.ComboItems[aIndex].SelectedImageIndex >= 0) then
        imgNdx := ItemsEx.ComboItems[aIndex].SelectedImageIndex
      else
        imgNdx := ItemsEx.ComboItems[aIndex].ImageIndex;

      if IsValidIndex(imgNdx, GetImageCount(Images)) then begin
        i := (HeightOf(gRect) - Images.Height) div 2;
        Images.Draw(Bmp.Canvas, gRect.Left, gRect.Top + i, imgNdx, True);
      end;
    end;
  end;

  if bEdit and (Style = csExDropDown) then begin
//  if bEdit and (GetWindowLong(Handle, GWL_STYLE) and CBS_DROPDOWN = CBS_DROPDOWN {(Style = csExDropDown)}) then begin
    OffsetRect(rText, -1, 1);
    WriteTextEx(Bmp.Canvas, PChar(Text), True, rText, DrawStyle, sNdx, True, SkinData.SkinManager);
  end
  else
    if IsValidIndex(aIndex, Items.Count) then
      if sNdx < 0 then begin
        if odSelected in aState then
          Bmp.Canvas.Font.Color := SkinData.SkinManager.GetHighLightFontColor(True)
        else
          Bmp.Canvas.Font.Color := GetFontColor;//FCommonData.SkinManager.GetActiveEditFontColor;

        Bmp.Canvas.Brush.Style := bsClear;
        AcDrawText(Bmp.Canvas.Handle, Items[aIndex], rText, DrawStyle);
      end
      else
        WriteTextEx(Bmp.Canvas, PChar(Items[aIndex]), True, rText, DrawStyle, sNdx, bSelected or (State > 0), SkinData.SkinManager);

  BitBlt(DC, aRect.Left, aRect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
  if (odFocused in aState) and (sNdx < 0) then
    DrawFocusRect(DC, aRect);

  FreeAndNil(Bmp);
end;


procedure TsCustomComboBoxEx.WMLButtonDblClk(var Message: TMessage);
begin
  if ReadOnly then begin
    SetFocus;
    if Assigned(OnDblClick) then
      OnDblClick(Self);
  end
  else
    if not AllowDropDown then
      DoDropDown
    else
      inherited;
end;


procedure TsCustomComboBoxEx.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if ReadOnly then
    SetFocus
  else
    if not AllowDropDown then
      DoDropDown
    else
      inherited
end;


procedure TsCustomComboBoxEx.DoDropDown;
begin
  if CanFocus then
    SetFocus;

  if Assigned(OnDropDown) then begin
    FDropDown := True;
    State := 2;
    AnimateCtrl(2);
    OnDropDown(Self);
  end;
end;


procedure TsCustomComboBoxEx.AnimateCtrl(AState: integer);
begin
  FCommonData.BGChanged := False;
  FCommonData.FMouseAbove := AState <> 0;
  if (AState in [1, 3]) and AllowBtnStyle then
    ShowGlowingIfNeeded(SkinData, AState > 1, Handle, MaxByte * integer(not SkinData.SkinManager.Effects.AllowAnimation), False);

  DoChangePaint(SkinData, AState, UpdateCombo_CB, SkinData.SkinManager.Effects.AllowAnimation, AState in [2, 4], not AllowBtnStyle and (SkinData.GlowID < 0));
end;


procedure TsCustomComboBoxEx.PaintButton;
var
  R: TRect;
  C: TColor;
  Mode: integer;
  TmpBtn: TBitmap;
begin
  if FDropDown then
    Mode := 2
  else
    Mode := integer((State = 1) or (AllowBtnStyle and (FCommonData.FMouseAbove or FCommonData.FFocused)));

  R := ButtonRect;
  with FCommonData.SkinManager do
    if not AllowBtnStyle then
      with ConstData.ComboBtn do begin
        if SkinIndex >= 0 then begin
          TmpBtn := CreateBmpLike(FCommonData.FCacheBmp);
          BitBlt(TmpBtn.Canvas.Handle, 0, 0, TmpBtn.Width, TmpBtn.Height, FCommonData.FCacheBmp.Canvas.Handle, 0, 0, SRCCOPY);
          PaintItem(SkinIndex, MakeCacheInfo(FCommonData.FCacheBmp), True, Mode, R, MkPoint, FCommonData.FCacheBmp, FCommonData.SkinManager, BGIndex[0], BGIndex[1]);
          FreeAndNil(TmpBtn);
        end;
        if not gd[FCommonData.SkinIndex].GiveOwnFont and IsValidImgIndex(GlyphIndex) then
          DrawSkinGlyph(FCommonData.FCacheBmp, Point(R.Left + (WidthOf(R) - ma[GlyphIndex].Width) div 2,
                        (Height - ButtonHeight) div 2), Mode, 1, ma[GlyphIndex], MakeCacheInfo(SkinData.FCacheBmp))
        else begin // Paint without glyph
          if (SkinIndex >= 0) and not AllowBtnStyle then
            C := gd[SkinIndex].Props[min(Mode, ac_MaxPropsIndex)].FontColor.Color
          else
            C := ColorToRGB(clWindowText);

          DrawColorArrow(FCommonData.FCacheBmp, C, R, asBottom);
        end;
      end
    else
      if not gd[FCommonData.SkinIndex].GiveOwnFont and IsValidImgIndex(FGlyphIndex) then
        DrawSkinGlyph(FCommonData.FCacheBmp, Point(R.Left + (WidthOf(R) - ma[FGlyphIndex].Width) div 2,
                      (Height - ButtonHeight) div 2), Mode, 1, ma[FGlyphIndex], MakeCacheInfo(SkinData.FCacheBmp))
      else begin // Paint without glyph
        if FCommonData.SkinIndex >= 0 then
          C := gd[FCommonData.SkinIndex].Props[min(Mode, ac_MaxPropsIndex)].FontColor.Color
        else
          C := ColorToRGB(clWindowText);

        DrawColorArrow(FCommonData.FCacheBmp, C, R, asBottom);
      end;
end;


procedure TsCustomComboBoxEx.PrepareCache;
var
  R: TRect;
  State: integer;
  odState: TOwnerDrawState;
begin
  InitCacheBmp(SkinData);
  if FDropDown and AllowBtnStyle then
    State := 2
  else
    State := integer(ControlIsActive(FCommonData) or AllowBtnStyle and FCommonData.FMouseAbove);

  if Style <> csExSimple then begin
    PaintItem(FCommonData, GetParentCache(FCommonData), True, State, MkRect(Width, FCommonData.FCacheBmp.Height), Point(Left, top), FCommonData.FCacheBmp, True);//False);
    if FShowButton then
      PaintButton;

    if UseRightToLeftAlignment then
      R := Rect(WidthOf(ButtonRect) + BrdWidth + 2, BrdWidth + 1, Width - BrdWidth + 1, Height - BrdWidth - 1)
    else
      R := Rect(BrdWidth + 1, BrdWidth + 1, ButtonRect.Left - 2, Height - BrdWidth - 1);

    odState := [odComboBoxEdit];
    if (GetFocus <> 0) and (Focused or SkinData.FFocused) and (GetWindowLong(Handle, GWL_STYLE) and CBS_DROPDOWNLIST = CBS_DROPDOWNLIST){(Style = csExDropDownList)} and Enabled then
      odState := odState + [odFocused, odSelected];

    DrawSkinItem(ItemIndex, R, odState, 0);
  end
  else
    PaintItem(FCommonData, GetParentCache(FCommonData), True, integer(ControlIsActive(FCommonData)), MkRect(Width, FCommonData.FCacheBmp.Height), Point(Left, top), FCommonData.FCacheBmp, True);//False);

  if not Enabled then
    BmpDisabledKind(FCommonData.FCacheBmp, FDisabledKind, Parent, GetParentCache(FCommonData), Point(Left, Top));

  FCommonData.BGChanged := False;
end;


procedure TsCustomComboBoxEx.SetDisabledKind(const Value: TsDisabledKind);
begin
  if FDisabledKind <> Value then begin
    FDisabledKind := Value;
    FCommonData.Invalidate;
  end;
end;


procedure TsCustomComboBoxEx.SetReadOnly(const Value: boolean);
begin
  if FReadOnly <> Value then
    FReadOnly := Value;
end;


procedure TsCustomComboBoxEx.SetShowButton(const Value: boolean);
begin
  if FShowButton <> Value then begin
    FShowButton := Value;
    FCommonData.Invalidate;
  end;
end;


procedure TsCustomComboBoxEx.WMPaint(var Message: TWMPaint);
var
  DC: hdc;
  btnRect: TRect;
begin
  if SkinData.BGChanged then
    PrepareCache;

  UpdateCorners(FCommonData, 0);
  if Message.DC <> 0 then
    DC := Message.DC
  else
    DC := GetDC(Handle);

  if not FDropDown or AllowBtnStyle then
    if (Style <> csExSimple) or AllowBtnStyle then
      BitBlt(DC, 0, 0, Width, Height, SkinData.FCacheBmp.Canvas.Handle, 0, 0, SRCCOPY)
    else
      BitBltBorder(DC, 0, 0, Width, Height, SkinData.FCacheBmp.Canvas.Handle, 0, 0, 3)
  else begin
    btnRect := ButtonRect;
    BitBltBorder(DC, 0, 0, Width, Height, SkinData.FCacheBmp.Canvas.Handle, 0, 0, 3);
    BitBlt(DC, btnRect.Left, btnRect.Top, WidthOf(btnRect), HeightOf(btnRect), SkinData.FCacheBmp.Canvas.Handle, btnRect.Left, btnRect.Top, SRCCOPY);
  end;
  if Message.DC <> DC then
    ReleaseDC(Handle, DC);
end;


procedure TsCustomComboBoxEx.WndProc(var Message: TMessage);
var
  i: integer;
  bR, R: TRect;
  P: TPoint;
begin
{$IFDEF LOGGED}
  AddToLog(Message);
{$ENDIF}
    case Message.Msg of
      SM_ALPHACMD:
        case Message.WParamHi of
          AC_CTRLHANDLED: begin
            Message.Result := 1;
            Exit;
          end; // AlphaSkins supported

          AC_SETSCALE: begin
            if BoundLabel <> nil then BoundLabel.UpdateScale(Message.LParam);
            Exit;
          end;

          AC_REMOVESKIN:
            if ACUInt(Message.LParam) = ACUInt(SkinData.SkinManager) then begin
              CommonWndProc(Message, FCommonData);
              if not FCommonData.CustomColor then
                Color := clWindow;

              if not FCommonData.CustomFont then
                Font.Color := clWindowText;

              if lBoxHandle <> 0 then begin
                SetWindowLong(lBoxHandle, GWL_STYLE, GetWindowLong(lBoxHandle, GWL_STYLE) and not WS_THICKFRAME or WS_BORDER);
                UninitializeACScroll(lBoxHandle, True, False, ListSW);
                lBoxHandle := 0;
              end;
              Exit
            end;

          AC_REFRESH:
            if ACUInt(Message.LParam) = ACUInt(SkinData.SkinManager) then begin
              if FDropDown and (ExHandle <> 0) then // Close up
                SendMessage(Handle, CB_SHOWDROPDOWN, 0, 0);

              CommonWndProc(Message, FCommonData);
              if FCommonData.Skinned then begin
                if not FCommonData.CustomColor then
                  Color := FCommonData.SkinManager.gd[FCommonData.SkinIndex].Props[0].Color;

                if not FCommonData.CustomFont then
                  Font.Color := ColorToRGB(FCommonData.SkinManager.gd[FCommonData.SkinIndex].Props[0].FontColor.Color);

                if ListSW <> nil then begin
                  TacComboListWnd(ListSW).SkinData.CustomColor := True;
                  if not FCommonData.CustomColor then
                    TacComboListWnd(ListSW).Color := FCommonData.SkinManager.GetActiveEditColor
                  else
                    TacComboListWnd(ListSW).Color := Color;
                end;
              end;
              if HandleAllocated then
                RedrawWindow(Handle, nil, 0, RDW_ALLCHILDREN or RDW_INVALIDATE or RDW_UPDATENOW);

              Exit
            end;

          AC_SETNEWSKIN:
            if ACUInt(Message.LParam) = ACUInt(SkinData.SkinManager) then begin
              CommonWndProc(Message, FCommonData);
              UpdateIndexes;
              if ListSW <> nil then
                ListSW.acWndProc(Message);

              Exit
            end;

          AC_ENDPARENTUPDATE:
            if FCommonData.FUpdating then begin
              FCommonData.FUpdating := False;
              RedrawWindow(Handle, nil, 0, RDW_ALLCHILDREN or RDW_INVALIDATE or RDW_UPDATENOW);
              Exit
            end;

          AC_INVALIDATE: begin
            SkinData.BGChanged := True;
            RedrawWindow(Handle, nil, 0, RDW_ALLCHILDREN or RDW_INVALIDATE or RDW_UPDATENOW);
          end;

          AC_PREPARECACHE:
            PrepareCache;

          AC_GETDEFINDEX: begin
            if FCommonData.SkinManager <> nil then
              if AllowBtnStyle then
                Message.Result := FCommonData.SkinManager.ConstData.Sections[ssButton] + 1
              else
                Message.Result := FCommonData.SkinManager.ConstData.Sections[ssComboBox] + 1;

            Exit;
          end;

          AC_MOUSELEAVE:
            SendMessage(Handle, CM_MOUSELEAVE, 0, 0);
        end;

      WM_MOUSEWHEEL: if not FAllowMouseWheel then
        Exit;

      WM_SYSCHAR, WM_SYSKEYDOWN, CN_SYSCHAR, CN_SYSKEYDOWN, WM_KEYDOWN, CN_KEYDOWN:
        case TWMKey(Message).CharCode of
          VK_SPACE..VK_DOWN, $39..$39, $41..$5A:
            if ReadOnly or not AllowDropDown then
                Exit;
        end;

      WM_CHAR:
        if ReadOnly or not AllowDropDown then
          Exit;

      WM_COMMAND, CN_COMMAND:
        if (Message.WParamHi in [CBN_DROPDOWN, CBN_SELCHANGE, CBN_EDITCHANGE]) and (FReadOnly or not AllowDropDown) then begin
          Message.Result := 1;
          Exit;
        end;

      WM_DRAWITEM: begin
        WMDrawItem(TWMDrawItem(Message));
        if Message.Result = 1 then
          Exit
      end;
    end;

  if not ControlIsReady(Self) or not FCommonData.Skinned then
    inherited
  else begin
    case Message.Msg of
      WM_CTLCOLOREDIT:
        if (Win32MajorVersion < 6) and (GetWindowLong(Handle, GWL_STYLE) and CBS_DROPDOWNLIST <> 0){(Style = csExDropDownList)} then begin // Forbid a filling by system
          if Message.WParam <> 0 then
            SetBkMode(hdc(Message.WParam), TRANSPARENT);

          Message.Result := LRESULT(GetStockObject(NULL_BRUSH));
          Exit;
        end;

{$IFDEF D2010} // Catch when control is hot
      WM_SETCURSOR:
        if not (csDesigning in ComponentState) and (SkinData.SkinManager.ActiveControl <> ExHandle) and (SkinData.SkinManager.ActiveControl <> Handle) then begin
          SkinData.SkinManager.ActiveControl := Handle;
          SendMessage(Handle, CM_MOUSEENTER, 0, 0);
        end;
{$ENDIF} // D2010

      WM_STYLECHANGED: begin
        lBoxHandle := 0;
        if Assigned(ListSW) then
          FreeAndNil(ListSW);
      end;

      CM_COLORCHANGED, CM_MOUSEWHEEL:
        FCommonData.BGChanged := True;

      CN_COMMAND:
        case TWMCommand(Message).NotifyCode of
          CBN_CLOSEUP: begin
            FDropDown := False;
            FCommonData.BGChanged := True;
            if SkinData.AnimTimer <> nil then
              SkinData.AnimTimer.Glow := 0;

            if not acMouseInControl(Self) then begin
              State := 0;
              SkinData.FMouseAbove := False;
            end;
            RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
            if FCommonData.AnimTimer <> nil then
              FCommonData.AnimTimer.CopyFrom(FCommonData.AnimTimer.BmpOut, FCommonData.FCacheBmp, MkRect(FCommonData.FCacheBmp));

            if AllowBtnStyle then
              AnimateCtrl(integer(SkinData.FMouseAbove))
          end;

          CBN_DROPDOWN: begin
            FDropDown := True;
            FCommonData.BGChanged := True;
            State := 2;
            AnimateCtrl(2);
            inherited;
            Exit;
          end;
        end;

      WM_SETFOCUS, CM_ENTER:
        if CanFocus and (FCommonData.CtrlSkinState and ACS_FOCUSCHANGING = 0) then begin
          FCommonData.CtrlSkinState := FCommonData.CtrlSkinState or ACS_FOCUSCHANGING;
          FinishTimer(SkinData.AnimTimer);
          inherited;
          FCommonData.FFocused := True;
          FCommonData.FMouseAbove := False;
          FCommonData.BGChanged := True;
          FCommonData.CtrlSkinState := FCommonData.CtrlSkinState and not ACS_FOCUSCHANGING;
          RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
          Exit;
        end;

      WM_KILLFOCUS, CM_EXIT:
        if FCommonData.CtrlSkinState and ACS_FOCUSCHANGING = 0 then begin
          FCommonData.CtrlSkinState := FCommonData.CtrlSkinState or ACS_FOCUSCHANGING;
          StopTimer(SkinData);
          if not SkinData.FMouseAbove then
            HideGlow(SkinData.GlowID);

          DroppedDown := False;
          FCommonData.FFocused := False;
          FCommonData.FMouseAbove := False;
          FCommonData.BGChanged := True;
          inherited;
          FCommonData.CtrlSkinState := FCommonData.CtrlSkinState and not ACS_FOCUSCHANGING;
          RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
          Exit;
        end;

      WM_NCPAINT: begin
        SkinData.FUpdating := SkinData.Updating;
        Message.Result := 0;
        Exit;
      end;

      WM_DRAWITEM: begin
        if not SkinData.FUpdating then
          WMDrawItem(TWMDrawItem(Message));

        if Message.Result = 1 then
          Exit;
      end;

      WM_ERASEBKGND: begin
        Message.Result := 1;
        Exit;
      end;

      WM_PAINT: begin
        inherited;
        Exit;
      end;

      WM_MOUSEMOVE:
        if not (csDesigning in ComponentState) then begin
          if not DroppedDown and not AllowBtnStyle then begin
            GetWindowRect(Handle, R);
            bR := ButtonRect;
            OffsetRect(bR, R.Left, R.Top);
            p := acMousePos;
            i := integer(PtInRect(bR, p));
            if not ac_AllowHotEdits and (i <> State) then begin
              State := i;
              AnimateCtrl(1 + 2 * i);
            end;
          end;
          inherited;
          Exit;
        end;

      CM_MOUSEENTER:
        if not (csDesigning in ComponentState) then begin
          if not DroppedDown or (Style = csExSimple) then begin
            if not FCommonData.FMouseAbove then begin
              GetWindowRect(Handle, R);
              FCommonData.FMouseAbove := True;
              SkinData.SkinManager.ActiveControl := Handle;
              FCommonData.BGChanged := True;
              bR := ButtonRect;
              InflateRect(bR, 1, 1);
              OffsetRect(bR, R.Left, R.Top);
              p := acMousePos;
              i := integer(PtInRect(bR, p));
              State := i;
              AnimateCtrl(1 + 2 * i)
            end;
          end
          else
            inherited;

          Exit;
        end;

      CM_MOUSELEAVE:
        if not (csDesigning in ComponentState) then begin
          if not DroppedDown or (Style = csExSimple) then begin
            GetWindowRect(Handle, R);
            P := acMousePos;
            if not PtInRect(R, P) then begin
              FCommonData.FMouseAbove := False;
              State := 0;
              AnimateCtrl(0);
            end;
          end
          else
            inherited;

          Exit;
        end;

      WM_COMMAND:
        case Message.WParamHi of
          CBN_DROPDOWN:
            if ReadOnly or not AllowDropDown then
              Exit;

          CBN_CLOSEUP: begin
            FDropDown := False;
            Repaint;
          end;
        end;

{$IFNDEF TNTUNICODE}
      WM_CTLCOLORLISTBOX:
        if not (csLoading in ComponentState) and (lBoxHandle = 0) then begin
          lBoxHandle := hwnd(Message.LParam);
          ListSW := TacComboListWnd.CreateEx(lboxhandle, nil, SkinData.SkinManager, s_Edit, True, Style = csExSimple);
          TacComboListWnd(ListSW).SkinData.CustomColor := True;
          if not FCommonData.CustomColor then
            TacComboListWnd(ListSW).Color := FCommonData.SkinManager.GetActiveEditColor
          else
            TacComboListWnd(ListSW).Color := Color;
        end;
{$ENDIF} // TNTUNICODE

      CB_SETITEMHEIGHT, CM_VISIBLECHANGED, CM_ENABLEDCHANGED, WM_SETFONT:
        FCommonData.BGChanged := True;

      WM_PRINT: begin
        SkinData.FUpdating := False;
        WMPaint(TWMPaint(Message));
        Exit;
      end;
    end;
    if CommonWndProc(Message, FCommonData) then
      Exit;

    inherited;
    case Message.Msg of
      SM_ALPHACMD:
        case Message.WParamHi of
          AC_DROPPEDDOWN:
            Message.Result := LRESULT(DroppedDown);
        end;

      CM_VISIBLECHANGED:
        if SkinData.CtrlSkinState and ACS_CHANGING = 0 then
          Repaint;

      WM_SIZE, CM_CHANGED, CM_TEXTCHANGED, CB_SETCURSEL: begin
        FCommonData.BGChanged := True;
        if ExHandle <> 0 then
          RedrawWindow(ExHandle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
      end;

      CM_ENABLEDCHANGED: begin
        FCommonData.BGChanged := True;
        if ExHandle <> 0 then
          RedrawWindow(ExHandle, nil, 0, RDW_INVALIDATE or RDW_UPDATENOW or RDW_ALLCHILDREN);
      end;
    end;
  end;
  if Assigned(BoundLabel) then
    BoundLabel.HandleOwnerMsg(Message, Self);
end;


procedure TsCustomComboBoxEx.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or CBS_OWNERDRAWFIXED and not CBS_OWNERDRAWVARIABLE;
end;


function TsCustomComboBoxEx.GetSelectedItem: TComboExItem;
begin
  if ItemIndex >= 0 then
    Result := ItemsEx.ComboItems[ItemIndex]
  else
    Result := nil
end;


function TsCustomComboBoxEx.AllowBtnStyle: boolean;
begin
  Result := (GetWindowLong(Handle, GWL_STYLE) and CBS_DROPDOWNLIST = CBS_DROPDOWNLIST){(Style in [csExDropDownList])} and (SkinData.SkinSection = '');
end;


function TsCustomComboBoxEx.GetItemHt: Integer;
begin
  Result := Perform(CB_GETITEMHEIGHT, 0, 0);
end;


procedure TsCustomColorBox.CloseUp;
begin
  inherited CloseUp;
  FListSelected := True;
end;


procedure TsCustomColorBox.ColorCallBack(const AName: string);
var
  I, LStart: Integer;
  LColor: TColor;
  LName: string;
begin
  LColor := StringToColor(AName);
  if Assigned(FOnColorName) then begin
    LName := AName;
    FOnColorName(Self, LColor, LName);
  end
  else
    if cbPrettyNames in Style then begin
      if Copy(AName, 1, 2) = 'cl' then
        LStart := 3
      else
        LStart := 1;

      LName := '';
      for I := LStart to Length(AName) do begin
        case AName[I] of
          'A'..'Z': if (LName <> '') and (LName <> '3') then
            LName := LName + s_Space;
        end;
        LName := LName + AName[I];
      end;
    end
    else
      LName := AName;

  Items.AddObject(LName, TObject(LColor));
end;


function TsCustomColorBox.ColorRect(SourceRect: TRect; State: TOwnerDrawState): TRect;
begin
  Result := SourceRect;
  if ShowColorName then
    Result.Right := 2 * (Result.Bottom - Result.Top) + Result.Left
  else
    Result.Right := Result.Right - WidthOf(ButtonRect) - 3 * integer(FShowButton);

  if odComboBoxEdit in State then
    InflateRect(Result, - 1 - FMargin, - 1 - FMargin)
  else
    InflateRect(Result, - 1, - 1);
end;


constructor TsCustomColorBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStyle := [cbStandardColors, cbExtendedColors, cbSystemColors];
  FSelectedColor := clBlack;
  FDefaultColorColor := clBlack;
  FPopupMode := pmColorList;
  FShowColorName := True;
  FNoneColorColor := clBlack;
  FCommonData.COC := COC_TsColorBox;
end;


procedure TsCustomColorBox.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or CBS_DROPDOWNLIST;
end;


procedure TsCustomColorBox.CreateWnd;
begin
  if not (csDesigning in ComponentState) then
    inherited Style := csExDropDownList;

  inherited CreateWnd;
  PopulateList;
end;


function TsCustomColorBox.DrawSkinItem(aIndex: Integer; aRect: TRect; aState: TOwnerDrawState; aDC: hdc): boolean;
var
  DC: hdc;
  C: TColor;
  Bmp: TBitmap;
  CI: TCacheInfo;
  DrawStyle: Cardinal;
  gRect, rText: TRect;
  sNdx, State: integer;
  BtnStyle, bEdit, Skinned: boolean;

  function ColorToBorderColor(AColor: TColor): TColor;
  begin
    if (TsColor(AColor).R > 128) or (TsColor(AColor).G > 128) or (TsColor(AColor).B > 128) then
      Result := clGray
    else
      if odSelected in aState then
        Result := clWhite
      else
        Result := AColor;
  end;

  function GetFontColor: TColor;
  begin
    if Skinned then
      if (odSelected in AState) and not BtnStyle then
        Result := SkinData.SkinManager.GetHighLightFontColor(True)
      else
        if SkinData.CustomFont then
          Result := Font.Color
        else
          if bEdit then
            Result := SkinData.SkinManager.gd[SkinData.SkinIndex].Props[State].FontColor.Color
          else
            Result := SkinData.SkinManager.Palette[pcEditText]
    else
      Result := Font.Color;
  end;

begin
  Result := False;
  if aIndex >= 0 then begin
    Skinned := SkinData.Skinned;
    if aDC <> 0 then
      DC := aDC
    else
      if Skinned and (SkinData.FCacheBmp <> nil) then
        DC := SkinData.FCacheBmp.Canvas.Handle
      else
        Exit;

    if (ControlIsActive(SkinData) or (SkinData.FMouseAbove and AllowBtnStyle)) and Skinned and (SkinData.SkinManager.gd[SkinData.SkinIndex].States > 1) then
      State := 1
    else
      State := 0;

    bEdit := odComboBoxEdit in aState;
    BtnStyle := AllowBtnStyle and bEdit;

    Result := True;
    CI.Ready := False;
    if Skinned then begin
      if bEdit then begin
        CI := MakeCacheInfo(FCommonData.FCacheBmp, aRect.Left, aRect.Top);
        CI.FillColor := SkinData.SkinManager.gd[SkinData.SkinIndex].Props[State].Color;
      end
      else begin
        CI.Bmp := nil;
        CI.Ready := False;
        CI.FillColor := Color;
      end;
      if (odSelected in aState) and not BtnStyle then
        sNdx := SkinData.SkinManager.ConstData.Sections[ssSelection]
      else
        if bEdit then
          sNdx := SkinData.SkinIndex
        else begin
          sNdx := -1;
          CI.FillColor := SkinData.SkinManager.Palette[pcEditBG];
        end
    end
    else begin
      sNdx := -1;
      CI.FillColor := Color;
    end;

    Bmp := CreateBmp32(aRect);
    Bmp.Canvas.Font.Assign(Font);
    rText := MkRect(Bmp);
    // Paint BG
    if (odSelected in aState) and (ShowcolorName or not (odComboBoxEdit in aState)) and not BtnStyle then
      if Skinned then
        if sNdx >= 0 then
          PaintItem(sNdx, CI, True, 1{Focused}, MkRect(Bmp), MkPoint, Bmp, SkinData.SkinManager)
        else
          FillDC(Bmp.Canvas.Handle, rText, SkinData.SkinManager.GetHighLightColor)
      else
        FillDC(Bmp.Canvas.Handle, rText, clHighlight)
    else
      if CI.Ready then
        BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, CI.Bmp.Canvas.Handle, CI.X, CI.Y, SRCCOPY)
      else
        FillDC(Bmp.Canvas.Handle, rText, CI.FillColor);

    C := GetColor(aIndex);
    if C = clDefault then
      C := DefaultColorColor
    else
      if C = clNone then
        C := NoneColorColor;

    gRect := rText;
    if odComboBoxEdit in aState then
      InflateRect(gRect, - 1 - FMargin, - 1 - FMargin)
    else
      InflateRect(gRect, - 1, - 1);

    if ShowColorName or not bEdit then begin
      InflateRect(gRect, -2, 0);
      gRect.Left := gRect.Left - 2;
      gRect.Right := gRect.Left + 2 * (gRect.Bottom - gRect.Top);

      FillDC(Bmp.Canvas.Handle, gRect, C);
      Bmp.Canvas.Brush.Color := ColorToBorderColor(ColorToRGB(C));
      Bmp.Canvas.Brush.Style := bsSolid;
      Bmp.Canvas.FrameRect(gRect);

      rText.Left := gRect.Right + 5;
      DrawStyle := DT_NOPREFIX or DT_EXPANDTABS or DT_SINGLELINE or DT_VCENTER or DT_NOCLIP;
      if IsValidIndex(aIndex, Items.Count) then
        if Skinned and (sNdx >= 0) then
          if odSelected in aState then
            WriteTextEx(Bmp.Canvas, PChar(Items[aIndex]), True, rText, DrawStyle, sNdx, True, SkinData.SkinManager)
          else
            WriteTextEx(Bmp.Canvas, PChar(Items[aIndex]), True, rText, DrawStyle, sNdx, State > 0, SkinData.SkinManager)
        else begin
          Bmp.Canvas.Brush.Style := bsClear;
          Bmp.Canvas.Font.Color := GetFontColor;
          acDrawText(Bmp.Canvas.Handle, Items[aIndex], rText, DrawStyle);
          if not Skinned and (odFocused in aState) then begin
            rText.Left := 0;
            DrawFocusRect(Bmp.Canvas.Handle, rText);
          end;
        end;
    end
    else
      if odSelected in aState then begin
        gRect := MkRect(Bmp);
        FillDC(Bmp.Canvas.Handle, gRect, C);
        if odFocused in aState then
          DrawFocusRect(Bmp.Canvas.Handle, gRect);
      end
      else begin
        FillDC(Bmp.Canvas.Handle, gRect, C);
        Bmp.Canvas.Brush.Color := ColorToBorderColor(ColorToRGB(C));
        Bmp.Canvas.Brush.Style := bsSolid;
        Bmp.Canvas.FrameRect(gRect);
      end;

    BitBlt(DC, aRect.Left, aRect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
    FreeAndNil(Bmp);
  end;
end;


function TsCustomColorBox.GetColor(Index: Integer): TColor;
begin
  if Index < 0 then
    Result := clNone
  else
    Result := TColor(Items.Objects[Index]);
end;


function TsCustomColorBox.AllowDropDown: boolean;
begin
  Result := PopupMode = pmColorList;
end;


function TsCustomColorBox.GetColorName(Index: Integer): string;
begin
  Result := Items[Index];
end;


function TsCustomColorBox.GetItemHt: Integer;
begin
  Result := Perform(CB_GETITEMHEIGHT, 0, 0);
end;


function TsCustomColorBox.GetSelected: TColor;
begin
  if HandleAllocated then
    if ItemIndex >= 0 then
      Result := GetColor(ItemIndex)
    else
      Result := NoColorSelected
  else
    Result := FSelectedColor;
end;


procedure TsCustomColorBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  FListSelected := False;
  inherited KeyDown(Key, Shift);
end;


procedure TsCustomColorBox.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (cbCustomColor in Style) and (Key = #13) and (ItemIndex = 0) then begin
    PickCustomColor;
    Key := #0;
  end;
end;


function TsCustomColorBox.PickCustomColor: Boolean;
begin
  if ColDlg = nil then
    ColDlg := TsColorDialog.Create(nil);

  ColDlg.Color := ColorToRGB(TColor(Items.Objects[0]));
  Result := ColDlg.Execute;
  if Result then begin
    SendMessage(ExHandle, WM_SETREDRAW, 0, 0);
    if cbSavedColors in Style then
      PopulateList;

    SendMessage(ExHandle, WM_SETREDRAW, 1, 0);
    TComboBoxExStrings(Items).ItemsEx[0].Data := TObject(ColDlg.Color);
    Selected := ColDlg.Color;
    ItemIndex := 0;
    Self.Invalidate;
  end;
end;


procedure TsCustomColorBox.PopulateList;

  procedure DeleteRange(const AMin, AMax: Integer);
  var
    I: Integer;
  begin
    for I := AMax downto AMin do
      Items.Delete(I);
  end;

  procedure DeleteColor(const AColor: TColor);
  var
    I: Integer;
  begin
    I := Items.IndexOfObject(TObject(AColor));
    if I >= 0 then
      Items.Delete(I);
  end;

var
  lSelectedColor, lCustomColor, C: TColor;
  i: integer;
begin
  if HandleAllocated and not (csDestroying in ComponentState) then begin
    Items.BeginUpdate;
    try
      lCustomColor := clBlack;
      if (cbCustomColor in Style) and (Items.Count > 0) then
        LCustomColor := TColor(Items.Objects[0]);

      LSelectedColor := FSelectedColor;
      while Items.Count > 0 do
        Items.Delete(0);

      GetColorValues(ColorCallBack);
      if not (cbIncludeNone in Style) then
        DeleteColor(clNone);

      if not (cbIncludeDefault in Style) then
        DeleteColor(clDefault);

      if not (cbSystemColors in Style) then
        DeleteRange(StandardColorsCount + ExtendedColorsCount, Items.Count - 1);

      if not (cbExtendedColors in Style) then
        DeleteRange(StandardColorsCount, StandardColorsCount + ExtendedColorsCount - 1);

      if not (cbStandardColors in Style) then
        DeleteRange(0, StandardColorsCount - 1);

      if (cbSavedColors in Style) and (ColDlg <> nil) then
        for i := 0 to acCustomColors.Count - 1 do
          if acCustomColors[i] <> 'FFFFFF' then begin
            Items.Insert(0, acCustomColors[i]);
            C := HexToInt(acCustomColors[i]);
            C := SwapRedBlue(C);
            TComboBoxExStrings(Items).ItemsEx[0].Data := TObject(C);
          end;

      if cbCustomColor in Style then begin
        Items.Insert(0, SColorBoxCustomCaption);
        TComboBoxExStrings(Items).ItemsEx[0].Data := TObject(LCustomColor);
      end;
      if (cbCustomColors in Style) and Assigned(OnGetColors) then begin
        OnGetColors(Self, Items);
        for i := 0 to Items.Count - 1 do
          TComboBoxExStrings(Items).ItemsEx[i].Data := Items.Objects[i];
      end;
      Selected := LSelectedColor;
    finally
      Items.EndUpdate;
    end;
  end;
end;


procedure TsCustomColorBox.Select;
begin
  if FListSelected then begin
    FListSelected := False;
    if (cbCustomColor in Style) and (ItemIndex = 0) and not PickCustomColor then
      Exit;
  end;
  inherited Select;
end;


procedure TsCustomColorBox.SetDefaultColorColor(const Value: TColor);
begin
  if Value <> FDefaultColorColor then begin
    FDefaultColorColor := Value;
    FCommonData.Invalidate;
  end;
end;


procedure TsCustomColorBox.SetMargin(const Value: integer);
begin
  if FMargin <> Value then begin
    FMargin := Value;
    FMargin := min(FMargin, Height div 2);
    FCommonData.Invalidate;
  end;
end;


procedure TsCustomColorBox.SetNoneColorColor(const Value: TColor);
begin
  if Value <> FNoneColorColor then begin
    FNoneColorColor := Value;
    FCommonData.Invalidate;
  end;
end;


procedure TsCustomColorBox.SetPopupMode(const Value: TacColorPopupMode);
begin
  if FPopupMode <> Value then begin
    FPopupMode := Value;
    if Value = pmPickColor then
      Style := Style + [cbCustomColor];
  end;
end;


procedure TsCustomColorBox.SetSelected(const AColor: TColor);
var
  I, J: Integer;
begin
  if HandleAllocated then begin
    I := Items.IndexOfObject(TObject(AColor));
    if AColor <> 0 then begin
      if ((cbCustomColor in Style) or (PopupMode = pmPickColor)) and (AColor <> NoColorSelected) then
        TComboBoxExStrings(Items).ItemsEx[0].Data := TObject(AColor);

      if I = -1 then
        ItemIndex := 0
      else
        ItemIndex := I;
    end
    else
      if cbCustomColor in Style then begin
        if (I = -1) and (AColor <> NoColorSelected) then begin
          TComboBoxExStrings(Items).ItemsEx[0].Data := TObject(AColor);
          I := 0;
        end;
        if (I = 0) and (Items.Objects[0] = TObject(AColor)) then begin
          ItemIndex := 0;
          for J := 1 to Items.Count - 1 do
            if Items.Objects[0] = TObject(AColor) then begin
              ItemIndex := J;
              Break;
            end;
        end
        else
          ItemIndex := I;
      end
      else
        ItemIndex := I;

    SendAMessage(Handle, AC_INVALIDATE);
  end;
  FSelectedColor := AColor;
end;


procedure TsCustomColorBox.SetShowColorName(const Value: boolean);
begin
  if FShowColorName <> Value then begin
    FShowColorName := Value;
    FCommonData.Invalidate;
  end;
end;


procedure TsCustomColorBox.SetStyle(AStyle: TsColorBoxStyle);
begin
  if AStyle <> Style then begin
    FStyle := AStyle;
    PopulateList;
    SkinData.Invalidate;
  end;
end;


procedure TsCustomColorBox.DoDropDown;
begin
  if AllowDropDown then
    inherited
  else
    if not FDropDown then begin
      FDropDown := True;
      if sColorDialogForm = nil then
        sColorDialogForm := TsColorDialogForm.Create(Application);

      sColorDialogForm.InitControls(True, False, Selected, bsNone);
      sColorDialogForm.SetCurrentColor(Selected);

      StopTimer(SkinData);
      SkinData.Invalidate(True);

      ShowPopupForm(sColorDialogForm, Self);
      // Allow showing of Dlg when screen is captured
      SetWindowLong(sColorDialogForm.Handle, GWL_EXSTYLE, GetWindowLong(sColorDialogForm.Handle, GWL_EXSTYLE) and not WS_EX_LAYERED);
    end
    else
      if (sColorDialogForm <> nil) and IsWindowVisible(sColorDialogForm.Handle) then begin
        FDropDown := False;
        StopTimer(SkinData);
        SkinData.Invalidate(True);
        sColorDialogForm.Close;
      end;
end;


procedure TsCustomColorBox.WMDrawItem(var Message: TWMDrawItem);
var
  ds: TDrawItemStruct;
  State: TOwnerDrawState;
begin
  ds := Message.DrawItemStruct^;
  if ds.itemState and ODS_COMBOBOXEDIT <> 0 then
    State := [odComboBoxEdit]
  else
    State := [];

  if ds.itemState and
    ODS_FOCUS = ODS_FOCUS then State := State + [odFocused];

  if ds.itemState and ODS_SELECTED <> 0 then
    State := State + [odSelected];

  if ds.itemState and ODS_HOTLIGHT <> 0 then
    State := State + [odSelected];

  if ds.itemState and ODS_DISABLED <> 0 then
    State := State + [odDisabled];

  Message.Result := LRESULT(DrawSkinItem(integer(ds.itemID), ds.rcItem, State, ds.hDC))
end;


procedure TsCustomColorBox.WndProc(var Message: TMessage);
begin
{$IFDEF LOGGED}
//  AddToLog(Message);
{$ENDIF}
  case Message.Msg of
    SM_ALPHACMD:
      case Message.WParamHi of
        AC_POPUPCLOSED: begin
          FDropDown := False;
          StopTimer(SkinData);
          SkinData.Invalidate(True);
        end;

        AC_SETSCALE:
          if sColorDialogForm <> nil then
            FreeAndNil(sColorDialogForm);
      end;

    CN_COMMAND:
      case TWMCommand(Message).NotifyCode of
        CBN_DROPDOWN:
          if cbSavedColors in Style then
            PopulateList;
      end;
  end;
  inherited;
end;
{$ENDIF} // DELPHI6UP


procedure TacSkinSelectBtn.Click;
begin
  FDoClick := True;
end;


constructor TacSkinSelectBtn.Create(AOwner: TComponent);
begin
  inherited;
  FDoClick := False;
end;


procedure TacSkinSelectBtn.WndProc(var Message: TMessage);
begin
  inherited;
  case Message.Msg of
    WM_LBUTTONUP:
      if FDoClick then begin
        FDoClick := False;
        Application.ProcessMessages;
        TacSkinSelectForm(Parent.Parent).ClickBtn(Self);
      end;
  end;
end;


type
  TAccessScrollBox = class(TsScrollBox);

constructor TacSkinSelectForm.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
const
  gMargin = 4;
var
  sbWidth: integer;
begin
  inherited;
  TsSkinProvider.Create(Self);
  Position := poDesigned;
  AutoScroll := False;
  Selector := TsSkinSelector(AOwner);
  BorderStyle := bsNone;

  ItemCount := Selector.ItemsEx.Count;
  if Selector.ThumbSize <> tsSmall then
    inc(ItemHeight, 20);

  if Selector.ShowNoSkin then
    inc(ItemCount);

  ItemWidth := max(Selector.MinItemWidth, ThumbSizes[True, Selector.ThumbSize] + Selector.ItemMargin * 2);
  ItemHeight := ThumbSizes[False, Selector.ThumbSize] + Selector.ItemMargin * 2;
  if Selector.ThumbSize <> tsSmall then
    inc(ItemHeight, GetFontHeight(Selector.Handle) + 4 {Spacing});

  Height := min(Selector.RowCount, ItemCount div Selector.ColCount + integer((ItemCount mod Selector.ColCount) <> 0)) * ItemHeight + gMargin;
  Width := min(Selector.ColCount, ItemCount) * ItemWidth + gMargin;

  ImgList := TsVirtualImageList.Create(Self);
  ImgList.Width := Selector.SkinData.SkinManager.ScaleInt(ThumbSizes[True, Selector.ThumbSize]);
  ImgList.Height := Selector.SkinData.SkinManager.ScaleInt(ThumbSizes[False, Selector.ThumbSize]);
  ImgList.AlphaImageList := TsAlphaImageList(Selector.SkinData.SkinManager.SkinListController.ImgList);
  ImgList.Loaded;

  ScrollBox := TsScrollBox.Create(Self);
  with TAccessScrollBox(ScrollBox) do begin
    HorzScrollBar.Visible := False;
    AutoMouseWheel := True;
    VertScrollBar.Tracking := True;
    SkinData.VertScrollData.ButtonsSize := 0;
    SkinData.SkinSection := s_MainMenu;
    Parent := Self;
    Align := alClient;
    Visible := True;

    if ItemCount > Selector.RowCount * Selector.ColCount then begin
      AutoScroll := True;
      if ListSW = nil then begin
        HandleNeeded;
        RefreshScrolls(SkinData, ListSW);
      end;
      if ListSW <> nil then
        sbWidth := GetScrollMetric(ListSW.sBarVert, SM_SCROLLWIDTH) + 4
      else
        sbWidth := GetSystemMetrics(SM_CXVSCROLL) + 4;

      Self.Width := Self.Width + sbWidth;
    end
    else begin
      sbWidth := 0;
      AutoScroll := False;
    end;

    if Selector.MinItemWidth <= 0 then begin
      Self.Width := max(Self.Width, Selector.Width);
      ItemWidth := (Self.Width - sbWidth - gMargin) div min(Selector.ColCount, ItemCount);
    end;
  end;
end;


//type
//  TAccessSpeedButton = class(TsSpeedButton);


procedure TacSkinSelectForm.UpdateControls;
var
  X, Y, i: integer;
  sb: TAccessScrollBox;

  function AddBtn(ACaption: string; ImgIndex: integer): TacSkinSelectBtn;
  begin
    Result := TacSkinSelectBtn.Create(ScrollBox);
    Result.Width := ItemWidth;
    Result.Height := ItemHeight;
    Result.Left := X * ItemWidth;
    Result.Top := Y * ItemHeight;
    Result.Parent := ScrollBox;
    Result.Visible := True;
    Result.Caption := ACaption;
    Result.ImageIndex := ImgIndex;
    Result.SkinData.SkinSection := s_MenuItem;
    Result.Images := ImgList;
    if Selector.ThumbSize = tsSmall then begin
      Result.Margin := Selector.ItemMargin;
      Result.TextAlignment := taLeftJustify;
      Result.Layout := blGlyphLeft;
      Result.Alignment := taLeftJustify;
      Result.WordWrap := False;
    end
    else
      Result.Layout := blGlyphTop;

    Result.Flat := True;
    Result.Tag := i;
    if Selector.SkinData.SkinManager.SkinName = Result.Caption then begin
      BtnIndex := i + integer(Selector.ShowNoSkin);
      Result.FHotState := True;
    end;
    inc(X);
    if X >= Selector.ColCount then begin
      X := 0;
      inc(Y);
    end;
  end;

begin
{  X := Selector.SkinData.SkinManager.ScaleInt(ThumbSizes[True, Selector.ThumbSize]);
  Y := Selector.SkinData.SkinManager.ScaleInt(ThumbSizes[False, Selector.ThumbSize]);
  if X <> ImgList.Width then
    ImgList.Width := X;

  if Y <> ImgList.Height then
    ImgList.Height := Y;
}
//  ImgList.UpdateList;
  Font.Name := Selector.Font.Name;
  sb := TAccessScrollBox(Scrollbox);
  sb.DisableAlign;

  X := 0;
  Y := 0;

  for i := ScrollBox.ControlCount - 1 downto 0 do
    ScrollBox.Controls[i].Free;

  i := -1;
  if Selector.ShowNoSkin then
    with AddBtn('Standard theme', -1) do
      if not Selector.SkinData.SkinManager.CommonSkinData.Active then
        Enabled := False;

  for i := 0 to Selector.ItemsEx.Count - 1 do
    AddBtn(Selector.ItemsEx[i].Caption, Selector.ItemsEx[i].ImageIndex);

  ScrollBox.EnableAlign;
end;


procedure TacSkinSelectForm.UpdateHotControl;
var
  i: integer;
begin
  for i := 0 to ScrollBox.ControlCount - 1 do
    if ScrollBox.Controls[i] is TacSkinSelectBtn then
      with TacSkinSelectBtn(ScrollBox.Controls[i]) do
        if FHotState <> (Caption = Selector.SkinData.SkinManager.SkinName) then begin
          FHotState := Caption = Selector.SkinData.SkinManager.SkinName;
          SkinData.Invalidate(True);
        end;

  if Selector.ShowNoSkin and (ScrollBox.ControlCount > 0) then begin
    TacSkinSelectBtn(ScrollBox.Controls[0]).Enabled := Selector.SkinData.SkinManager.Active;
    if not Selector.SkinData.SkinManager.Active then
      TacSkinSelectBtn(ScrollBox.Controls[0]).FHotState := True;
  end;
end;


procedure TacSkinSelectForm.ClickBtn(AButton: TacSkinSelectBtn);
var
  sName: string;
begin
  if Selector.ShowNoSkin and (AButton.Tag = -1) then
    sName := ''
  else
    sName := AButton.Caption;

  Close;
  AButton.Flat := False;
  Selector.KillPopupForm;
  Selector.ItemIndex := Selector.Items.IndexOf(sName);
end;


procedure TacSkinSelectForm.SetBtnIndex(NewIndex: integer);
begin
  if BtnIndex <> NewIndex then begin
    with TacSkinSelectBtn(ScrollBox.Controls[BtnIndex]) do begin
      FHotState := False;
      SkinData.Invalidate(True);
    end;
    BtnIndex := NewIndex;
    with TacSkinSelectBtn(ScrollBox.Controls[BtnIndex]) do begin
      FHotState := True;
      SkinData.Invalidate(True);
    end;
    if (TsScrollBox(ScrollBox).ListSW <> nil) and TsScrollBox(ScrollBox).ListSW.sBarVert.fScrollVisible then begin
      TsScrollBox(ScrollBox).ScrollInView(ScrollBox.Controls[BtnIndex]);
      UpdateScrolls(TsScrollBox(ScrollBox).ListSW, True);
    end;
  end;
end;


function TsSkinSelector.AllowDropDown: boolean;
begin
  Result := False;
end;


constructor TsSkinSelector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowNoSkin := True;
  FThumbSize := tsBig;
  FColCount := 3;
  FRowCount := 5;
  FItemMargin := 4;
  FMinItemWidth := 0;
end;


procedure TsSkinSelector.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or CBS_DROPDOWNLIST;
end;


procedure TsSkinSelector.CreateWnd;
begin
{$IFDEF DELPHI6UP}
  if not (csDesigning in ComponentState) then
    inherited Style := csExDropDownList;
{$ENDIF}

  inherited CreateWnd;
  if SkinData.SkinManager <> nil then
    SkinData.SkinManager.SkinListController.AddControl(Self);

  PopulateList;
  UpdateItemIndex;
end;


procedure TsSkinSelector.Loaded;
begin
  inherited;
end;


destructor TsSkinSelector.Destroy;
begin
  if SkinData.SkinManager <> nil then
    SkinData.SkinManager.SkinListController.DelControl(Self);

  inherited;
end;


procedure TsSkinSelector.KeyDown(var Key: Word; Shift: TShiftState);
var
  sc: TShortCut;
begin
  inherited KeyDown(Key, Shift);
  sc := ShortCut(Key, Shift);
  if sc = scAlt + vk_Down then begin
    ReleaseCapture;
    DoDropDown;
    Key := 0;
  end
  else
    case Key of
      VK_ESCAPE:
        if Form <> nil then begin
          Key := 0;
          Form.Close;
        end;

      VK_HOME:
        if ReadOnly then
          MessageBeep(0)
        else
          SetIndex(0, 0);

      VK_END:
        if ReadOnly then
          MessageBeep(0)
        else
          SetIndex(Items.Count - 1, 0);

      VK_LEFT:
        if ReadOnly then
          MessageBeep(0)
        else
          SetIndex(0, -1);

      VK_UP:
        if ReadOnly then
          MessageBeep(0)
        else
          if (Form <> nil) and FDropDown then
            SetIndex(0, -Self.ColCount)
          else
            SetIndex(0, -1);

      VK_RIGHT:
        if ReadOnly then
          MessageBeep(0)
        else
          SetIndex(0, 1);

      VK_DOWN:
        if ReadOnly then
          MessageBeep(0)
        else
          if (Form <> nil) and FDropDown then
            SetIndex(0, Self.ColCount)
          else
            SetIndex(0, 1);

      VK_RETURN:
        if (Form <> nil) and IsValidIndex(Form.BtnIndex, Form.ScrollBox.ControlCount) then
          TacSkinSelectBtn(Form.ScrollBox.Controls[Form.BtnIndex]).Click;
    end;
end;


procedure TsSkinSelector.KillPopupForm;
begin
  if Form <> nil then begin
    Form.Release;
    Form := nil;
  end;
end;


procedure TsSkinSelector.DoDropDown;
begin
  if AllowDropDown then
    inherited
  else
    if not FDropDown then begin
      if SkinData.SkinManager <> nil then begin
        if CanFocus then
          SetFocus;

        FDropDown := True;
        StopTimer(SkinData);
        SkinData.Invalidate(True);
        if Form = nil then begin
          Form := TacSkinSelectForm.CreateNew(Self);
          Form.UpdateControls;
        end
        else
          Form.UpdateHotControl;

        ShowPopupForm(Form, Self);
      end;
    end
    else
      if (Form <> nil) and IsWindowVisible(Form.Handle) then begin
        FDropDown := False;
        StopTimer(SkinData);
        SkinData.Invalidate(True);
        Form.Close;
      end;
end;


function TsSkinSelector.DroppedDown: boolean;
begin
  Result := FDropDown;
end;


procedure TsSkinSelector.SetIndex(BtnIndex: integer; Step: integer);
begin
  if (Form <> nil) and FDropDown and (Form.ScrollBox <> nil) and (Form.ScrollBox.ControlCount > 0) then
    if Step <> 0 then
      Form.SetBtnIndex(max(0, min(ItemCount - 1, Form.BtnIndex + Step)))
    else
      Form.SetBtnIndex(BtnIndex)
  else
    if Step <> 0 then
      ItemIndex := max(0, min(ItemCount - 1, ItemIndex + Step))
    else
      ItemIndex := BtnIndex;
end;


procedure TsSkinSelector.SetItemIndex(const Value: Integer);
begin
  if ItemIndex <> Value then begin
    inherited;
    if IsValidIndex(ItemIndex, Items.Count) then begin
      if SkinData.SkinManager.SkinName <> ItemsEx[ItemIndex].Caption then
        SkinData.SkinManager.SkinName := ItemsEx[ItemIndex].Caption;

      SkinData.SkinManager.Active := True;
    end
    else
      SkinData.SkinManager.Active := False;
  end;
end;


procedure TsSkinSelector.SetShowNoSkin(const Value: boolean);
begin
  if FShowNoSkin <> Value then begin
    FShowNoSkin := Value;
    if not (csLoading in ComponentState) then begin
      PopulateList;
      UpdateItemIndex;
    end;
  end;
end;


procedure TsSkinSelector.SetThumbSize(const Value: TacThumbSize);
begin
  if FThumbSize <> Value then begin
    FThumbSize := Value;
    if not (csLoading in ComponentState) then begin
      PopulateList;
      UpdateItemIndex;
    end;
  end;
end;


procedure TsSkinSelector.PopulateList;
var
  i: integer;
begin
  ItemsEx.Clear;
  ItemsEx.BeginUpdate;
  if Assigned(SkinData.SkinManager) then
    for i := 0 to Length(SkinData.SkinManager.SkinListController.SkinList) - 1 do
      with SkinData.SkinManager.SkinListController.SkinList[i], ItemsEx.Add do begin
        Caption := skName;
        ImageIndex := skImageIndex;
{$IFNDEF DELPHI6UP}
        Items.Add(skName);
{$ENDIF}
      end;

{$IFDEF DELPHI6UP}
  ItemsEx.Sort;
{$ENDIF}
  ItemsEx.EndUpdate;
  KillPopupForm;
end;


procedure TsSkinSelector.UpdateItemIndex;
var
  i: integer;
begin
  if (SkinData.SkinManager <> nil) and SkinData.SkinManager.Active and (SkinData.SkinManager.SkinName <> '') then begin
    i := Items.IndexOf(SkinData.SkinManager.SkinName);
    if i >= 0 then
      ItemIndex := i;
  end
  else
    ItemIndex := -1;
end;


procedure TsSkinSelector.ComboWndProc(var Message: TMessage; ComboWnd: HWnd; ComboProc: Pointer);
var
  m: TCMMouseWheel;
begin
  case Message.Msg of
    WM_DESTROY:
      ItemsEx.Clear;

    WM_MOUSEWHEEL: begin
      if (Form <> nil) and (Form.ScrollBox <> nil) and FDropDown then begin
        m := TCMMouseWheel(Message);
        TsScrollBox(Form.ScrollBox).DoMouseWheel(m.ShiftState, m.WheelDelta * Form.ItemHeight div 2, Point(m.XPos, m.YPos))
      end
      else
        if TCMMouseWheel(Message).WheelDelta < 0 then
          ItemIndex := min(ItemIndex + 1, Items.Count - 1)
        else
          ItemIndex := max(ItemIndex - 1, -1);

      Exit;
    end;
  end;
  inherited;
  case Message.Msg of
    WM_KEYDOWN:
      KeyDown(TWMKey(Message).CharCode, KeysToShiftState(word(TWMKeyDown(Message).KeyData)));
  end;
end;


procedure TsSkinSelector.WndProc(var Message: TMessage);
begin
{$IFDEF LOGGED}
//  AddToLog(Message);
{$ENDIF}
  case Message.Msg of
    SM_ALPHACMD:
      case Message.WParamHi of
        AC_SETNEWSKIN: begin
          inherited;
          if Form <> nil then
            AlphaBroadCast(Form, Message);

          UpdateItemIndex;
          Exit;
        end;

        AC_POPUPCLOSED: begin
          FDropDown := False;
          StopTimer(SkinData);
          SkinData.Invalidate(True);
        end;

        AC_SKINLISTCHANGED: begin
          PopulateList;
          UpdateItemIndex;
        end;

        AC_SKINCHANGED: begin
          UpdateItemIndex;
          if ItemIndex < 0 then // Not skinned
            KillPopupForm;
        end;

        AC_SETSCALE:
          KillPopupForm;

        AC_REMOVESKIN: begin
          KillPopupForm;
          if sColorDialogForm <> nil then
            FreeAndNil(sColorDialogForm);
        end;
      end;


    CN_COMMAND:
      case TWMCommand(Message).NotifyCode of
        CBN_DROPDOWN:
          DoDropDown;
      end;
  end;
  inherited;
end;


initialization

finalization
  if ColDlg <> nil then
    FreeAndNil(ColDlg);

end.


