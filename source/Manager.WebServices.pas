unit Manager.WebServices;

interface

uses
  Winapi.Windows, Winapi.ShellAPI, System.SysUtils;

type
  TWebUrlManager = record
  public
    class procedure Open(const Url: string); static;
  end;

implementation

{ TWebUrlManager }

class procedure TWebUrlManager.Open(const Url: string);
begin
  if not Url.Trim.IsEmpty then
    ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

end.
