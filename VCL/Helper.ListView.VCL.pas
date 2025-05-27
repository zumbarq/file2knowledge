unit Helper.ListView.VCL;

interface

uses
  Winapi.Windows,
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Dialogs, Vcl.Menus, Vcl.Forms, Manager.Intf;

type
  TListViewHelper = record
  private
    FListView: TListView;
  public
    constructor Create(const Value: TLIstView);
    function Add(const ACaption: string): TListViewHelper;
    function AddColumn(Size: Integer; Caption: string): TListViewHelper;
    function DeleteSelected: TListViewHelper;
    function Initialize: TListViewHelper;
    function ContentRefresh: TListViewHelper;
    function CaptionExists(const S: string): Boolean;
    class function Refresh(const Value: TLIstView): TListViewHelper; static;
  end;

implementation

{ TListViewHelper }

function TListViewHelper.Add(const ACaption: string): TListViewHelper;
begin
  FListView.Items.BeginUpdate;
  try
    var NewItem := FListView.Items.Add;
    NewItem.Caption := ACaption;
    Result := Self;
  finally
    FListView.Items.EndUpdate;
  end;
end;

function TListViewHelper.AddColumn(Size: Integer;
  Caption: string): TListViewHelper;
begin
  var Column := FListView.Columns.Add;
  Column.Width := Size;
  Column.Caption := Caption;
  Result := Self;
end;

function TListViewHelper.Initialize: TListViewHelper;
begin
  FListView.Items.BeginUpdate;
  try
    FListView.Columns.ClearAndResetID;
    FListView.Items.Clear;
    FListView.Columns.Clear;
    AddColumn(550, 'Filename');
    AddColumn(250, 'Upload Id');
    Result := Self;
  finally
    FListView.Items.EndUpdate;
  end;
end;

class function TListViewHelper.Refresh(const Value: TLIstView): TListViewHelper;
begin
  Result := TListViewHelper.Create(Value)
    .Initialize
    .ContentRefresh;
end;

function TListViewHelper.CaptionExists(const S: string): Boolean;
begin
  for var Item in FListView.Items do
    if string.Equals(Item.Caption.Trim.ToLower, S.Trim.ToLower) then
      begin
        FListView.Selected := Item;
        Exit(True);
      end;
  Result := False;
end;

function TListViewHelper.ContentRefresh: TListViewHelper;
begin
  FListView.Items.BeginUpdate;
  try
    FListView.Items.Clear;
    var index := 0;
    for var Item in FileStoreManager.Files do
      begin
        var NewItem := FListView.Items.Add;
        NewItem.Caption := Item;
        if index < Length(FileStoreManager.FileUploadIds) then
          NewItem.SubItems.Add(FileStoreManager.FileUploadIds[index]);
        Inc(index);
      end;
    Result := Self;
  finally
    FListView.Items.EndUpdate;
  end;
end;

constructor TListViewHelper.Create(const Value: TLIstView);
begin
  Self.FListView := Value;
end;

function TListViewHelper.DeleteSelected: TListViewHelper;
begin
  if Assigned(FListView.Selected) then
    FListView.DeleteSelected;
end;

end.
