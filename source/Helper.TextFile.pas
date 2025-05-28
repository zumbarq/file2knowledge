unit Helper.TextFile;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils;

type
  TFileIOHelper = record
    class function LoadFromFile(const FileName: string): string; static;
    class procedure SaveToFile(const Filename, Content: string); static;
  end;


implementation

{ TFileIOHelper }

class function TFileIOHelper.LoadFromFile(const FileName: string): string;
begin
  if TFile.Exists(FileName) then
    Result := TFile.ReadAllText(FileName, TEncoding.UTF8)
  else
    raise Exception.CreateFmt('The template file was not found : %s', [FileName]);
end;

class procedure TFileIOHelper.SaveToFile(const Filename, Content: string);
begin
  var FullPath := TPath.GetDirectoryName(FileName);
  if not FullPath.isEmpty and not TDirectory.Exists(FullPath) then
    TDirectory.CreateDirectory(FullPath);

  TFile.WriteAllText(FileName, Content, TEncoding.UTF8);
end;

end.
