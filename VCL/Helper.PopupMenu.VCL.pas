unit Helper.PopupMenu.VCL;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Dialogs, Vcl.Menus, Vcl.Forms;

type
  TPopupMenuHelper = record
  private
    FPopupMenu: TPopupMenu;
  public
    constructor Create(const Value: TPopupMenu);
    function AddItem(const ACaption, AShortCut: string; AOnClick: TNotifyEvent): TPopupMenuHelper;
    property PopupMenu: TPopupMenu read FPopupMenu;
  end;

implementation

{ TPopupMenuHelper }

function TPopupMenuHelper.AddItem(const ACaption, AShortCut: string;
  AOnClick: TNotifyEvent): TPopupMenuHelper;
begin
  var Item := TMenuItem.Create(FPopupMenu);
  Item.Caption := ACaption;
  Item.ShortCut := TextToShortCut(AShortCut);
  Item.OnClick := AOnClick;
  FPopupMenu.Items.Add(Item);
  Result := Self;
end;

constructor TPopupMenuHelper.Create(const Value: TPopupMenu);
begin
  if not Assigned(Value) then
    Self.FPopupMenu := TPopupMenu.Create(Application)
  else
    Self.FPopupMenu := Value;
end;

end.
