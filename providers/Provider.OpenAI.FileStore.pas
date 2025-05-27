unit Provider.OpenAI.FileStore;

interface

uses
  System.SysUtils, GenAI, GenAI.Types, Manager.Intf, Manager.Async.Promise;

type
  TFileStoreManager = class(TInterfacedObject, IFileStoreManager)
  private
    FClient: IGenAI;
  public
    function CheckFileUploaded(const FileName, Id: string): TPromise<string>;
    function UploadFileAsync(const FileName: string): TPromise<string>;
    function EnsureFileId(const FileName: string; const Id: string): TPromise<string>;
    constructor Create(const GenAIClient: IGenAI);
  end;

implementation

{ TFileStoreManager }

function TFileStoreManager.CheckFileUploaded(const FileName,
  Id: string): TPromise<string>;
begin
  Result := TPromise<string>.Create(
    procedure(Resolve: TProc<string>; Reject: TProc<Exception>)
    begin
      FClient.Files.AsynList(
        function : TAsynFiles
        begin
          Result.OnSuccess :=
            procedure (Sender: TObject; Value: TFiles)
            begin
              var Matched := False;

              for var Item in Value.Data do
                if (Item.Purpose = TFilesPurpose.user_data) and
                   (Item.Filename = ExtractFileName(FileName)) and
                   (Item.Id = Id) then
                  begin
                    Matched := True;
                    Break;
                  end;

              if Matched then
                Resolve(Id)
              else
                Resolve(EmptyStr);
            end;

          Result.OnError :=
            procedure (Sender: TObject; Error: string)
            begin
              Reject(Exception.Create(Error));
            end;
        end);
    end);
end;

constructor TFileStoreManager.Create(const GenAIClient: IGenAI);
begin
  inherited Create;
  FClient := GenAIClient;
end;

function TFileStoreManager.EnsureFileId(const FileName,
  Id: string): TPromise<string>;
begin
  {--- Ensure the presence of the specified file on the FTP server. }
  Result := CheckFileUploaded(FileName, Id)
    .&Then(
      function(Value: string): TPromise<string>
      begin
        if Value.IsEmpty then
          {--- The file does not exist. Upload the file and obtain its ID. }
          Result := UploadFileAsync(FileName)
        else
          {--- The file exists, so do nothing }
          Result := TPromise<string>.Resolved(Value);
      end);
end;

function TFileStoreManager.UploadFileAsync(
  const FileName: string): TPromise<string>;
begin
  Result := TPromise<string>.Create(
    procedure(Resolve: TProc<string>; Reject: TProc<Exception>)
    begin
      FClient.Files.AsynUpload(
        procedure (Params: TFileUploadParams)
        begin
          Params.&File(FileName);
          Params.Purpose('user_data');
        end,

        function : TAsynFile
        begin
          Result.OnSuccess :=
            procedure (Sender: TObject; Value: TFile)
            begin
              Resolve(Value.Id);
            end;

          Result.OnError :=
            procedure (Sender: TObject; Error: string)
            begin
              Reject(Exception.Create(Error));
            end;
        end);
    end);
end;

end.
