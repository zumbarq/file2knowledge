unit Helper.WebView2.VCL;

interface

uses
  Winapi.Windows,
  WebView2;

const
  IID_ICoreWebView2Controller2: TGUID =
    '{C979903E-D4CA-4228-92EB-47EE3FA96EAB}';

type
  (*--- Corresponds exactly to the C++ struct {UINT8 A,R,G,B} *)
  COREWEBVIEW2_COLOR = packed record
    A: BYTE;
    R: BYTE;
    G: BYTE;
    B: BYTE;
  end;
  TCOREWEBVIEW2_COLOR = COREWEBVIEW2_COLOR;

  ICoreWebView2Controller2 = interface(ICoreWebView2Controller)
    ['{C979903E-D4CA-4228-92EB-47EE3FA96EAB}']
    function get_DefaultBackgroundColor(
      out backgroundColor: COREWEBVIEW2_COLOR
    ): HRESULT; stdcall;
    function put_DefaultBackgroundColor(
      backgroundColor: COREWEBVIEW2_COLOR
    ): HRESULT; stdcall;
  end;

implementation

end.
