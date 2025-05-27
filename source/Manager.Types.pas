unit Manager.Types;

interface

uses
  System.SysUtils, System.StrUtils;

type
  TFeatureType = (sf_webSearch, sf_fileSearchDisabled, sf_reasoning);
  TFeatureModes = set of TFeatureType;

  TPageSelector = (psHistoric, psFileSearch, psWebSearch, psReasoning, psVectorFile, psSettings);

  TPageSelectorHelper = record Helper for TPageSelector
  private
    const
      Names: array[TPageSelector] of string = (
        'Chat History',
        'File Search',
        'Web Search',
        'Reasoning',
        'Vector File',
        'Settings'
      );

      Icons: array[TPageSelector] of string = (
        '', '', '', '', '', ''
      );

      DefaultPage = psHistoric;
  public
    constructor Create(const Value: string);
    function ToString: string;
    function ToIcon: string;
    function IndexOf: Integer;
    class function FromIndex(Index: Integer): TPageSelector; static;
    class function FromText(Value: string): TPageSelector; static;
    class function FromIcon(Value: string): TPageSelector; static;
    class function IconToPage(const Value: string): TPageSelector; static;
    class function Default: TPageSelector; static;
    class function Count: Integer; static;
    class function AllIcons: string; static;
  end;

const
  ResponsesPages = [psFileSearch, psWebSearch, psReasoning];

implementation


{ TPageSelectorHelper }

class function TPageSelectorHelper.AllIcons: string;
begin
  Result := String.Join(#10, Icons);
end;

class function TPageSelectorHelper.Count: Integer;
begin
  Result := Length(Names);
end;

constructor TPageSelectorHelper.Create(const Value: string);
begin
  var index := IndexStr(Value.ToLower, string.Join(#10, Names).ToLower.Split([#10]));
  if index = -1 then
    raise Exception.CreateFmt('Page Selector: "%s" page not found', [Value]);

  Self := TPageSelector(index);
end;

class function TPageSelectorHelper.Default: TPageSelector;
begin
  Result := DefaultPage;
end;

class function TPageSelectorHelper.FromIcon(Value: string): TPageSelector;
begin
  var Index := IndexStr(Value, Icons);
  if Index = -1 then
    raise Exception.CreateFmt('Page "%s" not found', [Value]);
  Result := FromIndex(Index);
end;

class function TPageSelectorHelper.FromIndex(Index: Integer): TPageSelector;
begin
  if (Index >= 0) and (Index < Count) then
    Result := TPageSelector(Index)
  else
    Result := Default;
end;

class function TPageSelectorHelper.FromText(Value: string): TPageSelector;
begin
  var Index := IndexStr(Value, Names);
  if Index = -1 then
    raise Exception.CreateFmt('Page "%s" not found', [Value]);
  Result := FromIndex(Index);
end;

class function TPageSelectorHelper.IconToPage(
  const Value: string): TPageSelector;
begin
  for var index := Ord(Low(TPageSelector)) to Ord(High(TPageSelector)) do
    if Icons[TPageSelector(index)] = Value then
      Exit(TPageSelector(index));
  raise EArgumentException.CreateFmt('Unknown icon "%s"', [Value]);
end;

function TPageSelectorHelper.IndexOf: Integer;
begin
  Result := Integer(Self);
end;

function TPageSelectorHelper.ToIcon: string;
begin
  Result := Icons[Self];
end;

function TPageSelectorHelper.ToString: string;
begin
  Result := Names[Self];
end;

end.
