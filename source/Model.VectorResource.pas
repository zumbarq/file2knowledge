unit Model.VectorResource;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections, System.NetEncoding,
  REST.Json.Types,
  GenAI, GenAI.Types, JSON.Resource;

type
  TVectorResourceItem = class
  strict private
    FImage: string;
    FDescription: string;
    FName: string;
    FInstructions: string;
    FFiles: TArray<string>;
    FGithub: string;
    FGetit: string;
    FFileUploadId: TArray<string>;
    FVectorStoreId: string;
  public
    class function Delete(var Arr: TArray<string>; index: NativeInt): Boolean;
    function GetImageStream: TStream;
    function GetFileContent(const Index: Integer): string;
    procedure DeleteFile(index: NativeInt);
    procedure DeleteFileUploadId(index: NativeInt);
    procedure DeleteFilePair(index: NativeInt);
    property Image: string read FImage write FImage;
    property Description: string read FDescription write FDescription;
    property Name: string read FName write FName;
    property Instructions: string read FInstructions write FInstructions;
    property Files: TArray<string> read FFiles write FFiles;
    property Github: string read FGithub write FGithub;
    property Getit: string read FGetit write FGetit;
    property FileUploadId: TArray<string> read FFileUploadId write FFileUploadId;
    property VectorStoreId: string read FVectorStoreId write FVectorStoreId;
  end;

  TVectorResourceList = class(TJSONResource)
  strict private
    FItemIndex: Integer;
    FData: TArray<TVectorResourceItem>;
    class var FInstance: TVectorResourceList;
  public
    procedure Clear;
    property ItemIndex: Integer read FItemIndex write FItemIndex;
    property Data: TArray<TVectorResourceItem> read FData write FData;
    class function Instance: TVectorResourceList; static;
    class function Reload(const FileName: string = ''): TVectorResourceList; static;
    destructor Destroy; override;
  end;

  TVectorResourceListProp = record
    class function ItemIndex: string; static; inline;
    class function Name: string; static; inline;
    class function Data: string; static; inline;
   end;

implementation

uses
  GenAI.Httpx, GenAI.NetEncoding.Base64, System.Net.HttpClient, System.IOUtils;

{ TVectorResourceItem }

class function TVectorResourceItem.Delete(var Arr: TArray<string>;
  index: NativeInt): Boolean;
begin
  if (Cardinal(Index) < Cardinal(Length(Arr))) then
    begin
      System.Delete(Arr, Index, 1);
      Exit(True);
    end;
  Result := False;
end;

procedure TVectorResourceItem.DeleteFile(index: NativeInt);
begin
  Delete(FFiles, index);
end;

procedure TVectorResourceItem.DeleteFilePair(index: NativeInt);
begin
  DeleteFileUploadId(index);
  DeleteFile(index);
end;

procedure TVectorResourceItem.DeleteFileUploadId(index: NativeInt);
begin
  Delete(FFileUploadId, index);
end;

function TVectorResourceItem.GetFileContent(const Index: Integer): string;
var
  Base64Text: string;
begin
  if (Index < 0) or (Index >= Length(FFiles)) then
    raise Exception.CreateFmt('Files(%s): Index out of bounds', [Index]);

  var FileName := Files[Index];

  if FileName.Trim.IsEmpty or not FileExists(FileName) then
    Exit('');

  {--- Retrieve raw text as Base64 }
  if FileName.Trim.ToLower.StartsWith('http') then
    Base64Text := Thttpx.LoadDataToBase64(Files[Index])
  else
    Base64Text := GenAI.NetEncoding.Base64.EncodeBase64(FileName);

  {--- Decode and convert to UTF-8 }
  Result := TEncoding.UTF8.GetString( TNetEncoding.Base64String.DecodeStringToBytes(Base64Text) );
end;

function TVectorResourceItem.GetImageStream: TStream;
var
  Base64Text: string;
begin
  if FImage.Trim.IsEmpty or not FileExists(FImage) then
    Exit(nil);

  {--- Consistently get a Base-64 string, without direct I/O }
  if FImage.StartsWith('http', True) then
    Base64Text := THttpx.LoadDataToBase64(FImage)
  else
  if TFile.Exists(FImage) then
    Base64Text := GenAI.NetEncoding.Base64.EncodeBase64(FImage)
  else
    Base64Text := FImage;

  {--- Convert Base-64 -> memory stream (business layer) }
  Result := TMemoryStream.Create;
  try
    DecodeBase64ToStream(Base64Text, Result);
    Result.Position := 0;
  except
    Result.Free;
    raise;
  end;
end;

{ TVectorResourceList }

procedure TVectorResourceList.Clear;
begin
  for var Item in Data do
    Item.Free;
  FItemIndex := -1;
  FData := [];
end;

destructor TVectorResourceList.Destroy;
begin
  Clear;
  inherited;
end;

class function TVectorResourceList.Instance: TVectorResourceList;
begin
  if not Assigned(FInstance) then
    FInstance := TVectorResourceList.Load as TVectorResourceList;
  Result := FInstance;
end;

class function TVectorResourceList.Reload(
  const FileName: string): TVectorResourceList;
begin
  FInstance.Free;
  FInstance := TVectorResourceList.Load(FileName) as TVectorResourceList;
  Result := FInstance;
end;

{ TVectorResourceListProp }

class function TVectorResourceListProp.Data: string;
begin
  Result := 'data';
end;

class function TVectorResourceListProp.ItemIndex: string;
begin
  Result := 'itemIndex';
end;

class function TVectorResourceListProp.Name: string;
begin
  Result := 'name';
end;

end.
