unit Provider.InstructionManager;

interface

uses
  System.SysUtils, System.Classes, Manager.Intf, Manager.Types;

const
  FILE_PATH_SYSTEM_PROMPT_DEFAULT = '..\..\prompts\system_prompt_context.txt';
  FILE_PATH_SYSTEM_PROMPT_OPENAI = '..\..\prompts\system_prompt_context_openAI.txt';
  FILE_PATH_SYSTEM_PROMPT_BASIC = '..\..\prompts\system_prompt_context_basict.txt';

type
  TSystemPromptBuilder = class(TInterfacedObject, ISystemPromptBuilder)
  private
    function LoadContent(const FileName: string): string;
  public
    function BuildSystemPrompt: string;
  end;

implementation

{ TSystemPromptBuilder }

function TSystemPromptBuilder.BuildSystemPrompt: string;
begin
  if (sf_fileSearchDisabled in ServiceFeatureSelector.FeatureModes) or
     (sf_reasoning in ServiceFeatureSelector.FeatureModes) then
    begin
      Exit(Format(LoadContent(FILE_PATH_SYSTEM_PROMPT_BASIC), [Settings.ProficiencyToString, Settings.UserScreenName]))
    end;

  var Wrapper := FileStoreManager.Description;
  var GitHub := FileStoreManager.GitHub;

  if FileStoreManager.Description = 'Delphi Wrapper for OpenAI' then
    Result := Format(LoadContent(FILE_PATH_SYSTEM_PROMPT_OPENAI), [Settings.ProficiencyToString, Wrapper, GitHub, Settings.UserScreenName])
  else
    Result := Format(LoadContent(FILE_PATH_SYSTEM_PROMPT_DEFAULT), [Settings.ProficiencyToString, Wrapper, GitHub, Settings.UserScreenName]);
end;

function TSystemPromptBuilder.LoadContent(const FileName: string): string;
begin
  var Stream := TFileStream.Create(Filename, fmOpenRead or fmShareDenyNone);
  try
    var Reader := TStreamReader.Create(Stream, TEncoding.UTF8);
    try
      Result := Reader.ReadToEnd;
    finally
      Reader.Free;
    end;
  finally
    Stream.Free;
  end;
end;

end.
