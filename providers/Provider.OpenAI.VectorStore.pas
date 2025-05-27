unit Provider.OpenAI.VectorStore;

interface

uses
  System.SysUtils, GenAI, GenAI.Types, Manager.Intf, Manager.Async.Promise;

type
  TVectorStoreManager = class(TInterfacedObject, IVectorStoreManager)
  private
    FClient: IGenAI;
  public
    {--- Vector store }
    function RetrieveVectorStoreId(const Value: string): TPromise<string>;
    function CreateVectorStore: TPromise<string>;
    function EnsureVectorStoreId(const VectorStoreId: string): TPromise<string>;
    {--- Vector store file }
    function RetrieveVectorStoreFileId(const VectorStoreId: string; const FileId: string): TPromise<string>;
    function CreateVectorStoreFile(const VectorStoreId: string; const FileId: string): TPromise<string>;
    function EnsureVectorStoreFileId(const VectorStoreId, FileId: string): TPromise<string>;
    function DeleteVectorStoreFile(const VectorStoreId, FileId: string): TPromise<string>;
    function DeleteVectorStore(const VectorStoreId: string): TPromise<string>;
    constructor Create(const GenAIClient: IGenAI);
  end;

implementation

{ TVectorStoreManager }

constructor TVectorStoreManager.Create(const GenAIClient: IGenAI);
begin
  inherited Create;
  FClient := GenAIClient;
end;

function TVectorStoreManager.CreateVectorStore: TPromise<string>;
begin
  Result := TPromise<string>.Create(
    procedure(Resolve: TProc<string>; Reject: TProc<Exception>)
    begin
      FClient.VectorStore.AsynCreate(
        procedure (Params: TVectorStoreCreateParams)
        begin
          Params.Name('Helper for wrapper Assistant');
        end,
        function : TAsynVectorStore
        begin
          Result.OnSuccess :=
            procedure (Sender: TObject; Value: TVectorStore)
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

function TVectorStoreManager.CreateVectorStoreFile(const VectorStoreId,
  FileId: string): TPromise<string>;
begin
  Result := TPromise<string>.Create(
    procedure(Resolve: TProc<string>; Reject: TProc<Exception>)
    begin
      FClient.VectorStoreFiles.AsynCreate(VectorStoreId,
        procedure (Params: TVectorStoreFilesCreateParams)
        begin
          Params.FileId(FileId);
        end,
        function : TAsynVectorStoreFile
        begin
          Result.OnSuccess :=
            procedure (Sender: TObject; VectorStoreFile: TVectorStoreFile)
            begin
              Resolve('created');
            end;

          Result.OnError :=
            procedure (Sender: TObject; Error: string)
            begin
              Reject(Exception.Create(Error));
            end;
        end);
    end);
end;

function TVectorStoreManager.DeleteVectorStore(
  const VectorStoreId: string): TPromise<string>;
begin
  Result := TPromise<string>.Create(
    procedure(Resolve: TProc<string>; Reject: TProc<Exception>)
    begin
      FClient.VectorStore.AsynDelete(
        VectorStoreId,
        function : TAsynDeletion
        begin
          Result.Sender := nil;
          Result.OnStart := nil;
          Result.OnSuccess :=
            procedure (Sender: TObject; Value: TDeletion)
            begin
              Resolve('deleted');
            end;
          Result.OnError :=
            procedure (Sender: TObject; Error: string)
            begin
              Reject(Exception.Create(Error));
            end;
        end);
    end);
end;

function TVectorStoreManager.DeleteVectorStoreFile(const VectorStoreId,
  FileId: string): TPromise<string>;
begin
  Result := TPromise<string>.Create(
    procedure(Resolve: TProc<string>; Reject: TProc<Exception>)
    begin
      FClient.VectorStoreFiles.AsynDelete(
        VectorStoreId,
        FileId,
        function : TAsynDeletion
        begin
          Result.Sender := nil;
          Result.OnStart := nil;
          Result.OnSuccess :=
            procedure (Sender: TObject; Value: TDeletion)
            begin
              Resolve('deleted');
            end;
          Result.OnError :=
            procedure (Sender: TObject; Error: string)
            begin
              Reject(Exception.Create(Error));
            end;
        end);
    end);
end;

function TVectorStoreManager.EnsureVectorStoreFileId(const VectorStoreId,
  FileId: string): TPromise<string>;
begin
  {--- Ensure the presence of the vectorStoreId and the FileId in the vector store file. }
  Result := RetrieveVectorStoreFileId(VectorStoreId, FileId)
    .&Then(
      function (Value: string): TPromise<string>
      begin
        if Value.Trim.IsEmpty then
          Result := CreateVectorStoreFile(VectorStoreId, FileId)
        else
          {--- The Id exists, so do nothing }
          Result := TPromise<string>.Resolved('exists');
      end)
end;

function TVectorStoreManager.EnsureVectorStoreId(
  const VectorStoreId: string): TPromise<string>;
begin
  if VectorStoreId.Trim.IsEmpty then
    Result := CreateVectorStore
  else
    {--- Ensure the presence of the Id in the vector store. }
    Result := RetrieveVectorStoreId(VectorStoreId)
      .&Then(
        function (Value: string): TPromise<string>
        begin
          {--- The Id does not exist. Create the Id and obtain its ID. }
          if Value.Trim.IsEmpty then
            Result := CreateVectorStore
          else
            {--- The Id exists, so do nothing }
            Result := TPromise<string>.Resolved(Value);
        end);
end;

function TVectorStoreManager.RetrieveVectorStoreFileId(const VectorStoreId,
  FileId: string): TPromise<string>;
begin
  Result := TPromise<string>.Create(
    procedure(Resolve: TProc<string>; Reject: TProc<Exception>)
    begin
      FClient.VectorStoreFiles.AsynRetrieve(
        VectorStoreId,
        FileId,
        function : TAsynVectorStoreFile
        begin
          Result.OnSuccess :=
            procedure (Sender: TObject; VectorStoreFile: TVectorStoreFile)
            begin
              Resolve(VectorStoreFile.Id);
            end;

          Result.OnError :=
            procedure (Sender: TObject; Error: string)
            begin
              if Error.Trim.ToLower.StartsWith('error 404:') then
                Resolve(EmptyStr)
              else
                Reject(Exception.Create(Error));
            end;
        end);
    end);
end;

function TVectorStoreManager.RetrieveVectorStoreId(
  const Value: string): TPromise<string>;
  (*
    Empty string handling (value = '') is retained, even though the EnsureVectorStoreId
    method excludes them to improve processing efficiency.
*)
begin
  var EmptyValue := False;
  Result := TPromise<string>.Create(
    procedure(Resolve: TProc<string>; Reject: TProc<Exception>)
    begin
      FClient.VectorStore.AsynRetrieve(Value,
        function : TAsynVectorStore
        begin
          Result.OnStart :=
            procedure (Sender: TObject)
            begin
              EmptyValue := Value.Trim.IsEmpty;
            end;

          Result.OnSuccess :=
            procedure (Sender: TObject; Vector: TVectorStore)
            begin
              if not EmptyValue then
                Resolve(Vector.Id);
            end;

          Result.OnError :=
            procedure (Sender: TObject; Error: string)
            begin
              if EmptyValue then
                begin
                  Resolve(EmptyStr);
                  Exit;
                end;
              if Error.Trim.ToLower.StartsWith('error 404:') then
                Resolve(EmptyStr)
              else
                Reject(Exception.Create(Error));
            end;
        end);
    end);
end;

end.
