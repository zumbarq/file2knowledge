unit Helper.PanelRoundedCorners.VCL;

interface

uses
  Winapi.Windows, Vcl.Controls, Vcl.ExtCtrls, System.SysUtils;

type
  TPanelHelper = class helper for TPanel
  public
    procedure PanelResizeHandler(Sender: TObject);
    procedure SetRoundedCorners(const AX, AY: Integer);
  end;

implementation

{ TPanelHelper }

procedure TPanelHelper.PanelResizeHandler(Sender: TObject);
var
  Panel: TPanel;
  CX, CY: Word;
  Area: HRGN;
begin
  Panel := Sender as TPanel;

  {--- Retrieves the rays stored in Tag (low-word = CX, hi-word = CY) }
  CX := LoWord(Panel.Tag);
  CY := HiWord(Panel.Tag);

  {--- Creates the rounded region at the current size }
  Area := CreateRoundRectRgn(0, 0, Panel.Width + 1, Panel.Height + 1, CX, CY);

  {--- Applies the region to the handle (the control takes ownership of Rgn) }
  SetWindowRgn(Panel.Handle, Area, True);
end;

procedure TPanelHelper.SetRoundedCorners(const AX, AY: Integer);
begin
  {--- Stores CX/CY in Tag so that it can be read later }
  Tag := MakeLong(AX, AY);

  {--- Connect the resize handler }
  OnResize := PanelResizeHandler;

  {--- Force an immediate first application }
  PanelResizeHandler(Self);
end;

end.
