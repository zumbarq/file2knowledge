unit Helper.ScrollBoxMouseWheel.VCL;

interface

uses
  Winapi.Messages, Winapi.Windows, System.Classes, Vcl.Controls, Vcl.Forms;

type
  TScrollBoxMouseWheelHook = class
  private
    FControl: TScrollBox;
    FOldWindowProc: TWndMethod;
    procedure NewWindowProc(var Msg: TMessage);
  public
    constructor Create(AScrollBox: TScrollBox);
  end;

  TScrollBoxHelper = class helper for TScrollBox
  public
    procedure EnableMouseWheelScroll;
  end;

var
  ScrollBoxHooks: TList;

implementation

{ TScrollBoxMouseWheelHook }

constructor TScrollBoxMouseWheelHook.Create(AScrollBox: TScrollBox);
begin
  inherited Create;
  FControl := AScrollBox;
  FOldWindowProc := AScrollBox.WindowProc;
  AScrollBox.WindowProc := NewWindowProc;
end;

procedure TScrollBoxMouseWheelHook.NewWindowProc(var Msg: TMessage);
var
  Delta: Smallint;
begin
  if Msg.Msg = WM_MOUSEWHEEL then
  begin
    Delta := SmallInt(HIWORD(Msg.WParam));
    FControl.VertScrollBar.Position :=
      FControl.VertScrollBar.Position - Delta div WHEEL_DELTA * FControl.VertScrollBar.Increment * 5;
    Msg.Result := 1;
  end
  else
    FOldWindowProc(Msg);
end;

{ TScrollBoxHelper }

procedure TScrollBoxHelper.EnableMouseWheelScroll;
begin
  if ScrollBoxHooks = nil then
    ScrollBoxHooks := TList.Create;

  ScrollBoxHooks.Add(TScrollBoxMouseWheelHook.Create(Self));
end;

procedure HookDestroy;
var
  Hook: TObject;
begin
  if Assigned(ScrollBoxHooks) then
    begin
      for Hook in ScrollBoxHooks do
        Hook.Free;
      ScrollBoxHooks.Free;
    end;
end;

initialization

finalization
  HookDestroy;
end.
