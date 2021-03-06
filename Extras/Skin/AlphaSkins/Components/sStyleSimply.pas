unit sStyleSimply;
{$I sDefs.inc}
//+
interface

uses
  Windows, Graphics, Classes, Controls, SysUtils, Forms, StdCtrls, Messages,
  {$IFDEF DELPHI7UP} Types, {$ENDIF}
  acntUtils, sConst, sSkinProps;


type
  TacSection =
    (ssMenuItem, ssCheckBox, ssSpeedButton, ssSpeedButton_Small, ssToolButton, ssTransparent, ssGroupBox, ssDivider, ssWebBtn, // <- Transparent sections
    ssButton, ssButtonHuge, ssToolBar, ssEdit, ssGauge, ssSelection, ssStatusBar, ssPanel, ssPanelLow, ssTrackBar, ssColHeader, ssProgressV,
    ssDragBar, ssGripH, ssGripV, ssProgressH, ssTabSheet, ssMenuButton, ssUpDown, ssComboBox, ssCaption, ssMenuLine, ssMainMenu,
    ssSplitter, ssSlider_Off, ssSlider_On, ssThumb_Off, ssThumb_On, ssComboBtn, ssFormTitle, ssHint, ssMenuCaption, ssDividerV);


  TacTitleGlyph =
    (tgCloseAlone,
     tgClose, tgMax, tgMin, tgNormal, tgHelp,
     tgSmallClose, tgSmallMax, tgSmallMin, tgSmallNormal, tgSmallHelp, tgUser, tgNone);


const
  acGlowedGlyphs = [tgCloseAlone..tgNormal];


  acSectNames: array [TacSection] of string =
    (s_MenuItem, s_CheckBox, s_SpeedButton, s_SpeedButton_Small, s_ToolButton, s_Transparent, s_GroupBox, s_Divider, s_WebBtn,
    s_Button, s_ButtonHuge, s_ToolBar, s_Edit, s_Gauge, s_Selection, s_StatusBar, s_Panel, s_PanelLow, s_TrackBar, s_ColHeader, s_ProgressV,
    s_DragBar, s_GripH, s_GripV, s_ProgressH, s_TabSheet, s_MenuButton, s_UpDown, s_ComboBox, s_Caption, s_MenuLine, s_MainMenu,
    s_Splitter, s_Slider_Off, s_Slider_On, s_Thumb_Off, s_Thumb_On, s_ComboBtn, s_FormTitle, s_Hint, s_MenuCaption, s_DividerV);


  acTitleGlyphs: array [TacTitleGlyph] of string =
    (s_BorderIconCloseAlone,
     s_BorderIconClose, s_BorderIconMaximize, s_BorderIconMinimize, s_BorderIconNormalize, s_BorderIconHelp,
     s_SmallIconClose, s_SmallIconMaximize, s_SmallIconMinimize, s_SmallIconNormalize, s_SmallIconHelp, s_TitleButtonMask, '');


  ProgArray:  array [boolean] of string = (s_ProgVert, s_ProgHorz);
  ThickArray: array [boolean] of string = (s_TickVert, s_TickHorz);


type
  TsSkinData = class(TObject)
    Active,
    UseAeroBluring: boolean;

    Author,
    SkinPath,
    Description: string;

    Shadow1Offset,
    Shadow1Blur,
    Shadow1Transparency,

    // Extended borders
    ExBorderWidth,
    ExTitleHeight,
    ExMaxHeight,
    ExContentOffs,
    ExCenterOffs,
    ExDrawMode,

    ExShadowOffs,
    ExShadowOffsR,
    ExShadowOffsT,
    ExShadowOffsB,

    BISpacing,
    BIVAlign,       // 0 - center, 1 - top, 2 - bottom
    BIRightMargin,
    BILeftMargin,
    BITopMargin,
    BIKeepHUE,      // 0 - variable HUE, 1 - keep unchanged

    ComboBoxMargin,
    SliderMargin,

    BrightMin,
    BrightMax,
    //
    TabsCovering,
    RibbonCovering: integer;

    FXColor,
    Shadow1Color,
    SysInactiveBorderColor: TColor;

    Version: real;
  public
    destructor Destroy; override;
  end;


  TacConstElementData = record
    SkinIndex,
    MaskIndex,
    GlyphIndex: integer;
    BGIndex: array [0..ac_MaxPropsIndex] of integer;
    SkinSection: string;
  end;


  TacTrackBarData = record
    SkinIndex,
    MaskIndex,
    GlyphIndex: integer;
    BGIndex: array [0..ac_MaxPropsIndex] of integer;
    TickIndex,
    ProgIndex,
    SlideIndex: integer;
  end;


  TacIntSections  = array [TacSection]   of integer;
  TacSideElements = array [TacSide]      of TacConstElementData;
  TacBoolElements = array [boolean]      of TacConstElementData;
  TacAllTabs      = array [TacTabLayout] of TacSideElements;

  TConstantSkinData = record
    // Some sections indexes
    IndexGLobalInfo: integer;
    Sections: TacIntSections;
    Tabs: TacAllTabs;

    Scrolls,
    ScrollBtns,
    UpDownBtns: TacSideElements;

    Sliders: TacBoolElements;

    MenuItem,
    ComboBtn: TacConstElementData;

    // Glyphs indexes
    TitleGlows:    array [tgCloseAlone..tgSmallClose] of array of integer;
    GlowMargins:   array [tgCloseAlone..tgSmallClose] of integer;
    TitleGlyphs:   array [TacTitleGlyph]  of integer;
    RadioButton:   array [boolean]        of integer;
    CheckBox:      array [TCheckBoxState] of integer;
    SmallCheckBox: array [TCheckBoxState] of integer;

    TrackBar: array [boolean] of TacTrackBarData;

    // Other indexes
    ExBorder,
    GripRightBottom,
    GripHorizontal,
    GripVertical: integer;
  end;


procedure CopyExForms(SkinManager: TComponent);
procedure LockForms  (SkinManager: TComponent);
procedure UnLockForms(SkinManager: TComponent; Repaint: boolean = True);
procedure AppBroadCastS(var Message);
procedure SendToHooked (var Message);
procedure IntSkinForm  (Form: TCustomForm);
procedure IntUnSkinForm(Form: TCustomForm);

function SectionInArray(const Sections: TacIntSections; const Value: integer; RangeMin: TacSection = ssMenuItem; RangeMax: TacSection = ssWebBtn): boolean;


var
  AppIcon, AppIconLarge: TIcon;
  aSkinChanging: boolean = False;
  HookedComponents: array of TComponent;


implementation

uses
  ShellAPI,
  sVclUtils, sMessages, sCommonData, sSkinProvider, sSkinManager, acDials;


type
  TAccessSkinProvider = class(TsSkinProvider);
  TacFormCallBack = procedure(sp: TAccessSkinProvider; Data: integer = 0);


function SectionInArray(const Sections: TacIntSections; const Value: integer; RangeMin: TacSection = ssMenuItem; RangeMax: TacSection = ssWebBtn): boolean;
var
  Section: TacSection;
begin
  for Section := RangeMin to RangeMax do
    if Sections[Section] = Value then begin
      Result := True;
      Exit;
    end;

  Result := False;
end;


procedure IterateForms(sm: TsSkinManager; FormCallBack: TacFormCallBack; Data: integer = 0);
var
  i: integer;
  sp: TAccessSkinProvider;
begin
  i := 0;
  while i <= Length(HookedComponents) - 1 do begin
    if HookedComponents[i] is TCustomForm then
      with TForm(HookedComponents[i]) do
        if (WindowState <> wsMinimized) and (FormStyle <> fsMDIChild) and (Parent = nil) and HandleAllocated and Visible then begin
          sp := TAccessSkinProvider(SendAMessage(TForm(HookedComponents[i]), AC_GETPROVIDER));
          if (sp <> nil) and (sp.SkinData.SkinManager = sm) then
            FormCallBack(sp, Data);
        end;

    inc(i);
  end;
end;


procedure CopyExFormsCB(sp: TAccessSkinProvider; Data: integer);
begin
  with sp do begin
    if BorderForm <> nil then
      with BorderForm do
        if AForm <> nil then begin
          sp.FormState := sp.FormState or FS_CHANGING;
          if CoverBmp <> nil then
            FreeAndNil(CoverBmp);

          CoverBmp := GetFormImage(sp);
        end;

    sp.FInAnimation := True;
  end;
end;


procedure CopyExForms(SkinManager: TComponent);
begin
  with TsSkinManager(SkinManager) do
    if not IsIconic(Application.{$IFDEF FPC}MainFormHandle{$ELSE}Handle{$ENDIF}) and
        ([csDesigning, csLoading, csReading] * ComponentState = []) then begin

      if IsDefault and (AnimEffects.SkinChanging.Active) then
        InAnimationProcess := True;

      IterateForms(TsSkinManager(SkinManager), CopyExFormsCB);
    end;
end;


procedure LockFormsCB(sp: TAccessSkinProvider; Data: integer);
var
  Alpha: integer;
begin
  with sp do begin
    FInAnimation := True;
    FormState := FormState or FS_LOCKED;
    if BorderForm <> nil then
      with BorderForm do
        if AForm <> nil then begin
          if CoverBmp <> nil then begin
{$IFDEF DELPHI7UP}
            if Form.AlphaBlend then
              Alpha := Form.AlphaBlendValue
            else
{$ENDIF}
              Alpha := MaxByte;

            SetFormBlendValue(AForm.Handle, CoverBmp, Alpha);
          end;
          SetWindowRgn(AForm.Handle, MakeRgn, False);
        end;

    Form.Perform(WM_SETREDRAW, 0, 0);
  end;
end;


procedure LockForms(SkinManager: TComponent);
begin
  with TsSkinManager(SkinManager) do
    if not IsIconic(Application.{$IFDEF FPC}MainFormHandle{$ELSE}Handle{$ENDIF}) then begin
      if IsDefault and (AnimEffects.SkinChanging.Active) then
        InAnimationProcess := True;

      IterateForms(TsSkinManager(SkinManager), LockFormsCB);
    end;
end;


var
  iLatestTitleHeight: integer = 0;


procedure AllowRedrawCB(sp: TAccessSkinProvider; Data: integer);
begin
  if sp.FormState and FS_LOCKED <> 0 then
    sp.Form.Perform(WM_SETREDRAW, 1, 0);
end;


procedure DoRepaintCB(sp: TAccessSkinProvider; Data: integer);
var
  ActWnd: hwnd;
  AlphaValue: byte;
begin
  with sp, SkinData.SkinManager, AnimEffects.SkinChanging do
    if Form.WindowState <> wsMinimized then
      if FormState and FS_LOCKED <> 0 then begin
        if Data = 1 then begin
          if Active then begin
{$IFDEF DELPHI7UP}
            if Form.AlphaBlend then
              AlphaValue := Form.AlphaBlendValue
            else
{$ENDIF}
              AlphaValue := MaxByte;

            if DrawNonClientArea then
              case Mode of
                atAero: AnimShowControl(Form, Time, AlphaValue, atcAero)
                else    AnimShowControl(Form, Time, AlphaValue, atcFade)
              end
            else
              AnimShowControl(sp.Form, 0);
          end;
          FormState := FormState and not FS_CHANGING;
          if (BorderForm <> nil) and (Form.WindowState = wsMaximized) then // Title height may be changed
            if iLatestTitleHeight <> ActualTitleHeight then begin // If height of title is really changed
              iLatestTitleHeight := ActualTitleHeight;
              ActWnd := GetActiveWindow;
              SetWindowLong(Form.Handle, GWL_STYLE, GetWindowLong(Form.Handle, GWL_STYLE) and not WS_VISIBLE);
              ShowWindow(Form.Handle, SW_SHOWMAXIMIZED);
              SetWindowLong(Form.Handle, GWL_STYLE, GetWindowLong(Form.Handle, GWL_STYLE) or WS_VISIBLE);
              if ActWnd <> 0 then
                SetActiveWindow(ActWnd);
            end;

          FInAnimation := False;
          if DrawNonClientArea then begin
            if {(Win32MajorVersion < 6) or }not AeroIsEnabled then
              SetWindowRgn(Form.Handle, 0, False); // Fixing of Aero bug

            sSkinProvider.FillArOR(sp); // Update rgn data for skin
            sSkinProvider.UpdateRgn(sp, True, True); // Update of native borders
            RedrawWindow(sp.Form.Handle, nil, 0, RDWA_ALLNOW); // Redraw main form under layered form
            if BorderForm <> nil then begin
              SetWindowRgn(BorderForm.AForm.Handle, BorderForm.MakeRgn, False); // Avoiding a flickering
              BorderForm.UpdateExBordersPos;
            end;
          end
          else
            RedrawWindow(Form.Handle, nil, 0, RDWA_ALLNOW);
        end
        else begin
          FormState := FormState and not FS_CHANGING;
          SendMessage(Form.Handle, WM_SETREDRAW, 1, 0);
          if Data = 1 then
            RedrawWindow(Form.Handle, nil, 0, RDWA_ALLNOW);
        end;
        FormState := FormState and not FS_LOCKED;
      end;
end;


procedure UnlockForms(SkinManager: TComponent; Repaint: boolean = True);
begin
  if not IsIconic(Application.{$IFDEF FPC}MainFormHandle{$ELSE}Handle{$ENDIF}) then begin
    if TsSkinManager(SkinManager).IsDefault then
      InAnimationProcess := False;

    IterateForms(TsSkinManager(SkinManager), AllowRedrawCB);
    IterateForms(TsSkinManager(SkinManager), DoRepaintCB, integer(Repaint));
  end;
end;


procedure AppBroadCastS(var Message);
var
  i: integer;
begin
  i := Application.ComponentCount - 1;
  while i >= 0 do begin // Order has been changed (Z-order is valuable now in skins changing or activating)
    if i >= Application.ComponentCount then
      Exit;
    // Sending a message to all forms (non-MDIChild first)
    if Application.Components[i] is TForm then
      with TForm(Application.Components[i]), TMessage(Message) do
        if FormStyle <> fsMDIChild then
          if ([csDestroying, csLoading] * ComponentState = []) and not WndIsSkinned(Handle) then begin
            // Form must be handled first
            SendMessage(Handle, Msg, WParam, LParam);
            AlphaBroadCast(TWinControl(Application.Components[i]), Message);
            // Message sending to client if form is a MDIForm
            if FormStyle = fsMDIForm then
              SendMessage(ClientHandle, Msg, WParam, LParam);
          end;

    dec(i);
  end;
  SendToHooked(Message);
end;


procedure SendToHooked(var Message);
var
  i: integer;
begin
  i := 0;
  while i < Length(HookedComponents) do begin
    if HookedComponents[i] is TForm then
      with TMessage(Message), TForm(HookedComponents[i]) do
        if not (csDestroying in ComponentState) then begin
          SendMessage(Handle, Msg, WParam, LParam);
          AlphaBroadCast(TForm(HookedComponents[i]), Message);
          if FormStyle = fsMDIForm then
            SendMessage(ClientHandle, Msg, WParam, LParam);
        end;

    inc(i);
  end;
  if acSupportedList <> nil then
    for i := 0 to acSupportedList.Count - 1 do
      if acSupportedList[i] <> nil then
        with TMessage(Message), TacProvider(acSupportedList[i]) do
          if (ListSW <> nil) and IsWindowVisible(ListSW.CtrlHandle) then
            SendMessage(ListSW.CtrlHandle, Msg, WParam, LParam);
end;


procedure IntSkinForm(Form: TCustomForm);
begin
  SetLength(HookedComponents, Length(HookedComponents) + 1);
  HookedComponents[Length(HookedComponents) - 1] := Form;
end;


procedure IntUnSkinForm(Form: TCustomForm);
var
  i, l: integer;
begin
  l := Length(HookedComponents) - 1;
  for i := 0 to l do
    if HookedComponents[i] = Form then begin
      HookedComponents[i] := HookedComponents[l];
      HookedComponents[l] := nil;
    end;

  if l >= 0 then
    if HookedComponents[l] = nil then
      SetLength(HookedComponents, l)
end;


destructor TsSkinData.Destroy;
begin
  if Assigned(SkinFile) then
    FreeAndNil(SkinFile);

  inherited;
end;


initialization
  AppIcon      := GetIconForFile(Application.ExeName, SHGFI_SMALLICON);
  AppIconLarge := GetIconForFile(Application.ExeName, SHGFI_LARGEICON);


finalization
  if Assigned(AppIcon) then begin
    AppIcon.ReleaseHandle;
    FreeAndNil(AppIcon);
  end;
  if Assigned(AppIconLarge) then begin
    AppIconLarge.ReleaseHandle;
    FreeAndNil(AppIconLarge);
  end;
  SetLength(HookedComponents, 0);

end.





