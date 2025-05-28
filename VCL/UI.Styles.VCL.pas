unit UI.Styles.VCL;

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Mask, Vcl.Graphics, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Forms, Vcl.Buttons, Helper.PanelRoundedCorners.VCL;

type
  TAppStyle = class
  public
    {--- Refer to UI.UserSettings.VCL }
    class procedure ApplyUserSettingsLabelStyle(Value: TLabel; Proc: TProc = nil);
    class procedure ApplyUserSettingsComboBoxStyle(Value: TComboBox; Proc: TProc = nil);
    class procedure ApplyUserSettingsComboBoxStyleStar(Value: TComboBox; Proc: TProc = nil);
    class procedure ApplyUserSettingsMaskEditStyle(Value: TMaskEdit; Proc: TProc; Password: Boolean = False);
    class procedure ApplyUserSettingsDashboardLabel(Value: TLabel; Proc: TProc = nil);

    {--- Refer to UI.PageSelector.VCL }
    class procedure ApplyPageSelectorLabelStyle(Value: TLabel; Proc: TProc = nil);
    class procedure ApplyPageSelectorComboBoxStyleBig(Value: TComboBox; Proc: TProc = nil);

    {--- UI.AnimatedVectorLeftPanel.VCL }
    class procedure ApplyAnimatedVectorLeftPanelButtonStyle(Value: TButton; Proc: TProc = nil);

    {--- UI.Container.VCL }
    class procedure ApplyContainerCorePanelStyle(Value: TPanel; Proc: TProc = nil);
    class procedure ApplyContainerBackgroundPanelStyle(Value: TPanel; Proc: TProc = nil);
    class procedure ApplyContainerImageStyle(Value: TImage; Proc: TProc = nil);
    class procedure ApplyContainerLabelStyle(Value: TLabel; Proc: TProc = nil);
    class procedure ApplyContainerPanelStyle(Value: TPanel; Proc: TProc = nil);

    class function ApplyContainerMouseEnterColor: TColor;
    class function ApplyContainerMouseLeaveColor: TColor;
    class function ApplyContainerFontSelectedColor: TColor;
    class function ApplyContainerFontUnSelectedColor: TColor;

    {--- UI.PromptEditor.VCL }
    class procedure ApplyPromptEditorRichEditStyle(Value: TRichEdit; Proc: TProc = nil);
    class procedure ApplyPromptEditorButtonStyle(Value: TSpeedButton; Proc: TProc = nil);

    {--- CancellationButton.VCL }
    class procedure ApplyCancellationButtonStyle(Value: TSpeedButton; Proc: TProc = nil);

    {--- UI.ServiceFeatureSelector.VCL }
    class procedure ApplyWebSearchButtonStyle(Value: TSpeedButton; Proc: TProc = nil);
    class procedure ApplyDisableFileSearchButtonStyle(Value: TSpeedButton; Proc: TProc = nil);
    class procedure ApplyReasoningButtonStyle(Value: TSpeedButton; Proc: TProc = nil);
    class procedure ApplyCaptionLabelStyle(Value: TLabel; Proc: TProc = nil);


    {--- UI.PromptSelector.VCL }
    class procedure ApplyPromptSelectorPanelStyle(Value: TPanel; Proc: TProc = nil);
    class procedure ApplyPromptSelectorMemoStyle(Value: TMemo; Proc: TProc = nil);
    class procedure ApplyPromptSelectorLabelStyle(Value: TLabel; Proc: TProc = nil);
    class procedure ApplyPromptSelectorUpButtonStyle(Value: TSpeedButton; Proc: TProc = nil);
    class procedure ApplyPromptSelectorDownButtonStyle(Value: TSpeedButton; Proc: TProc = nil);

    {--- UI.VectorResourceEditor.VCL }
    class procedure ApplyVectorResourceEditorListviewStyle(Value: TListView; Proc: TProc = nil);
    class procedure ApplyVectorResourceEditorScrollBoxStyle(Value: TScrollBox; Proc: TProc = nil);
    class procedure ApplyVectorResourceEditorImageStyle(Value: TImage; Proc: TProc = nil);
    class procedure ApplyVectorResourceEditorMaskEditTitleStyle(Value: TMaskEdit; Proc: TProc = nil);
    class procedure ApplyVectorResourceEditorMaskEditDarkStyle(Value: TMaskEdit; Proc: TProc = nil);
    class procedure ApplyVectorResourceEditorTrashButtonStyle(Value: TSpeedButton; Proc: TProc = nil);
    class procedure ApplyVectorResourceEditorThumbtackButtonStyle(Value: TSpeedButton; Proc: TProc = nil);
    class procedure ApplyVectorResourceEditorConfirmationPanelStyle(Value: TPanel; Proc: TProc = nil);
    class procedure ApplyVectorResourceEditorConfirmationButtonStyle(Value: TSpeedButton; Proc: TProc = nil);
    class procedure ApplyVectorResourceEditorLabelStyle(Value: TLabel; Proc: TProc = nil);
    class procedure ApplyVectorResourceEditorWarningPanelStyle(Value: TPanel; Proc: TProc = nil);

    {--- UI.ChatSession.VCL }
    class procedure ApplyChatSessionListviewStyle(Value: TListView; Proc: TProc = nil);
    class procedure ApplyChatSessionExecuteButtonStyle(Value: TSpeedButton; Proc: TProc = nil);
    class procedure ApplyChatSessionConfirmationPanelStyle(Value: TPanel; Proc: TProc = nil);
  end;

implementation

class procedure TAppStyle.ApplyUserSettingsComboBoxStyleStar(Value: TComboBox; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Style := csOwnerDrawFixed;
  Value.ItemHeight := 24;
  Value.Font.Name := 'Segoe MDL2 Assets';
  Value.Font.Color := clYellow;
  Value.Font.Size := 11;
  Value.TabStop := False;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyUserSettingsDashboardLabel(Value: TLabel;
  Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Cursor := crHandPoint;
  Value.Font.Color := clGray;
  Value.Font.Style := [fsUnderline];
  Value.StyleElements := [seClient, seBorder];

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyUserSettingsLabelStyle(Value: TLabel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Font.Color := clGrayText;
  Value.Font.Size := 10;
  Value.StyleElements := [seClient, seBorder];

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyAnimatedVectorLeftPanelButtonStyle(
  Value: TButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Font.Name := 'Segoe MDL2 Assets';
  Value.Font.Size := 14;
  Value.ShowHint := True;
  Value.TabStop := False;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyCancellationButtonStyle(Value: TSpeedButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Font.Name := 'Segoe MDL2 Assets';
  Value.Font.Size := 14;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyCaptionLabelStyle(Value: TLabel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Caption := 'File Search Only';
  Value.AlignWithMargins := True;
  Value.AutoSize := True;
  Value.Font.Size := 14;
  Value.Font.Name := 'Segoe UI';
  Value.Font.Style := [fsBold];
  Value.Layout := tlCenter;
  Value.Margins.Left := 18;
  Value.ShowHint := True;
  Value.Hint := 'Show settings F8';
  Value.StyleElements := [seFont,seClient,seBorder];

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyChatSessionConfirmationPanelStyle(
  Value: TPanel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.BevelOuter := bvNone;
  Value.BorderStyle := bsNone;
  Value.Color := $001F1F1F;
  Value.StyleElements := [seFont,seBorder];
  Value.ParentBackground := False;
  Value.ParentColor := False;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyChatSessionExecuteButtonStyle(
  Value: TSpeedButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.StyleElements := [seFont,seBorder];
  Value.Height := 22;
  Value.Width := 97;
  Value.Transparent := True;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyChatSessionListviewStyle(Value: TListView;
  Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.BevelInner := bvNone;
  Value.BevelOuter := bvNone;
  Value.BorderStyle := bsNone;
  Value.ParentColor := False;
  Value.RowSelect := True;

  Value.TabStop := False;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyContainerBackgroundPanelStyle(Value: TPanel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.BevelOuter := bvNone;
  Value.BorderWidth := 0;
  Value.Color := $001A1A1A;
  Value.StyleElements := [seFont, seBorder];
  Value.ParentColor := False;
  Value.ParentBackground := False;
  Value.SetRoundedCorners(6, 6);

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyContainerCorePanelStyle(Value: TPanel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Color := $001A1A1A;
  Value.StyleElements := [seFont, seBorder];
  Value.BevelOuter := bvNone;
  Value.ParentColor := False;
  Value.ParentBackground := False;
  Value.FullRepaint := False;
  Value.BorderWidth := 0;
  Value.SetRoundedCorners(16, 16);

  if Assigned(Proc) then
    Proc();
end;

class function TAppStyle.ApplyContainerFontSelectedColor: TColor;
begin
  Result := clBlack;
end;

class function TAppStyle.ApplyContainerFontUnSelectedColor: TColor;
begin
  Result := clWhite;
end;

class procedure TAppStyle.ApplyContainerImageStyle(Value: TImage; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Align := alClient;
  Value.Proportional := True;
  Value.ShowHint := True;
  Value.Transparent := True;
  Value.Center := True;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyContainerLabelStyle(Value: TLabel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.StyleElements := [seClient, seBorder];
  Value.Font.Color := clWhite;
  Value.Transparent := True;
  Value.ParentColor := False;

  if Assigned(Proc) then
    Proc();
end;

class function TAppStyle.ApplyContainerMouseEnterColor: TColor;
begin
  Result := $00F4C16C;
end;

class function TAppStyle.ApplyContainerMouseLeaveColor: TColor;
begin
  Result := $001A1A1A;
end;

class procedure TAppStyle.ApplyContainerPanelStyle(Value: TPanel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Color := TAppStyle.ApplyContainerMouseEnterColor;
  Value.StyleElements := [seBorder];
  Value.BevelOuter := bvNone;
  Value.ParentColor := False;
  Value.ParentBackground := False;
  Value.FullRepaint := False;
  Value.BorderWidth := 0;
  Value.Font.Color := clBlack;
  Value.Font.Size := 14;
  Value.Font.Style := [fsBold];
  Value.Font.Name := 'Segoe MDL2 Assets';
  Value.Caption := '';
  Value.Visible := False;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyDisableFileSearchButtonStyle(
  Value: TSpeedButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.AllowAllUp := True;
  Value.Caption := '';
  Value.GroupIndex := 3;
  Value.Hint := 'Disable File_search tool';
  Value.ShowHint := True;
  Value.Height := 33;
  Value.StyleElements := [seClient,seBorder];
  Value.Width := 33;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyPageSelectorComboBoxStyleBig(
  Value: TComboBox; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Top := -1;
  Value.Font.Name := 'Segoe MDL2 Assets';
  Value.Font.Size := 25;
  Value.Style := csOwnerDrawFixed;
  Value.ItemHeight := 46;
  Value.StyleElements := [seFont, seClient, seBorder];
  Value.TabStop := False;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyPageSelectorLabelStyle(Value: TLabel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Font.Color := clWhite;
  Value.Font.Size := 12;
  Value.Font.Style := [fsBold];
  Value.StyleElements := [seClient, seBorder];
  Value.Alignment := taRightJustify;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyPromptEditorButtonStyle(Value: TSpeedButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Caption := '';
  Value.Font.Name := 'Segoe MDL2 Assets';
  Value.Font.Size := 14;

   if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyPromptEditorRichEditStyle(Value: TRichEdit; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.HideScrollBars := True;
  Value.HideSelection := False;
  Value.AlignWithMargins := True;
  Value.Margins.Left := 8;
  Value.Anchors := [akLeft,akTop,akRight,akBottom];
  Value.BorderStyle := bsNone;
  Value.ScrollBars := ssVertical;
  Value.SpellChecking := True;
  Value.WantReturns := False;
  Value.WordWrap := True;
  Value.TabStop := True;
  Value.WantTabs := True;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyPromptSelectorDownButtonStyle(
  Value: TSpeedButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.AllowAllUp := True;
  Value.Font.Color := clWhite;
  Value.Caption := '';
  Value.Height := 33;
  Value.StyleElements := [seClient,seBorder];
  Value.Width := 33;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyPromptSelectorLabelStyle(Value: TLabel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Align := alLeft;
  Value.AlignWithMargins := True;
  Value.Font.Style := [fsBold];
  Value.Layout := tlCenter;
  Value.AutoSize := True;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyPromptSelectorMemoStyle(Value: TMemo; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.ReadOnly := True;
  Value.Font.Size := 10;
  Value.Font.Color := clSilver;
  Value.ScrollBars := ssVertical;
  Value.EditMargins.Left := 8;
  Value.EditMargins.Right := 8;
  Value.StyleElements := [seClient,seBorder];
  Value.Align := alClient;
  Value.BorderStyle := bsNone;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyPromptSelectorPanelStyle(Value: TPanel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Visible := False;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyPromptSelectorUpButtonStyle(
  Value: TSpeedButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.AllowAllUp := True;
  Value.Font.Color := clWhite;
  Value.Caption := '';
  Value.Height := 33;
  Value.StyleElements := [seClient,seBorder];
  Value.Width := 33;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyReasoningButtonStyle(Value: TSpeedButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.AllowAllUp := True;
  Value.Caption := '';
  Value.GroupIndex := 3;
  Value.Hint := 'Enable Reasoning'#10'File_search disable';
  Value.ShowHint := True;
  Value.Height := 33;
  Value.StyleElements := [seClient,seBorder];
  Value.Width := 33;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyUserSettingsComboBoxStyle(Value: TComboBox; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Style := csOwnerDrawFixed;
  Value.ItemHeight := 22;
  Value.Font.Name := 'Segoe UI';
  Value.Font.Size := 11;
  Value.StyleElements := [seFont, seClient, seBorder];
  Value.TabStop := False;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyUserSettingsMaskEditStyle(Value: TMaskEdit; Proc: TProc; Password: Boolean);
begin
  if not Assigned(Value) then
    Exit;

  Value.Font.Size := 11;
  Value.Font.Name := 'Segoe UI';
  if Password then
    Value.PasswordChar := '*';

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyVectorResourceEditorConfirmationButtonStyle(
  Value: TSpeedButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Height := 22;
  Value.StyleElements := [seFont,seBorder];
  Value.Transparent := True;
  Value.Width := 97;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyVectorResourceEditorConfirmationPanelStyle(
  Value: TPanel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.BevelOuter := bvNone;
  Value.BorderStyle := bsNone;
  Value.Color := $001F1F1F;
  Value.StyleElements := [seFont,seBorder];
  Value.ParentBackground := False;
  Value.ParentColor := False;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyVectorResourceEditorImageStyle(Value: TImage;
  Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Width := 75;
  Value.Height := 75;
  Value.Center := True;
  Value.Proportional := True;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyVectorResourceEditorLabelStyle(Value: TLabel;
  Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Cursor := crHandPoint;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyVectorResourceEditorListviewStyle(
  Value: TListView; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.ViewStyle := vsReport;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyVectorResourceEditorMaskEditDarkStyle(
  Value: TMaskEdit; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.BorderStyle := bsNone;
  Value.StyleElements := [seClient,seBorder];
  Value.Font.Color := clGray;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyVectorResourceEditorMaskEditTitleStyle(
  Value: TMaskEdit; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.BorderStyle := bsNone;
  Value.StyleElements := [seClient,seBorder];
  Value.Font.Color := clWhite;
  Value.Font.Size := 14;
  Value.Font.Style := [fsBold];

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyVectorResourceEditorScrollBoxStyle(
  Value: TScrollBox; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.BevelInner := bvNone;
  Value.BevelOuter := bvNone;
  Value.BorderStyle := bsNone;
  Value.Color := $001F1F1F;
  Value.ParentBackground := False;
  Value.ParentColor := False;
  Value.StyleElements := [seFont,seBorder];
  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyVectorResourceEditorThumbtackButtonStyle(
  Value: TSpeedButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Caption := '';
  Value.Font.Name := 'Segoe MDL2 Assets';
  Value.Font.Size := 14;
  Value.Font.Color := clWhite;
  Value.StyleElements := [seFont,seBorder];
  Value.Height := 26;
  Value.Width := 31;
  Value.Hint := 'Remove the links to the files.';
  Value.ShowHint := True;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyVectorResourceEditorTrashButtonStyle(
  Value: TSpeedButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.Caption := '';
  Value.Font.Name := 'Segoe MDL2 Assets';
  Value.Font.Size := 14;
  Value.Font.Color := clWhite;
  Value.StyleElements := [seFont,seBorder];
  Value.Height := 26;
  Value.Width := 31;
  Value.Hint := 'Remove the links to the files and delete the vector store.';
  Value.ShowHint := True;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyVectorResourceEditorWarningPanelStyle(
  Value: TPanel; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.BevelOuter := bvNone;
  Value.BorderStyle := bsNone;
  Value.Color := $00263EE1;
  Value.Font.Size := 12;
  Value.Font.Style := [fsBold];
  Value.ParentBackground := False;
  Value.ParentColor := False;
  Value.StyleElements := [seFont,seBorder];
  Value.Visible := False;

  if Assigned(Proc) then
    Proc();
end;

class procedure TAppStyle.ApplyWebSearchButtonStyle(Value: TSpeedButton; Proc: TProc);
begin
  if not Assigned(Value) then
    Exit;

  Value.AllowAllUp := True;
  Value.Caption := '';
  Value.GroupIndex := 2;
  Value.Hint := 'Enable Web Search';
  Value.ShowHint := True;
  Value.Height := 33;
  Value.StyleElements := [seClient,seBorder];
  Value.Width := 33;

  if Assigned(Proc) then
    Proc();
end;

end.
