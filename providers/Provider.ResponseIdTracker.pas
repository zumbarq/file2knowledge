unit Provider.ResponseIdTracker;

(*
  Unit: Provider.ResponseIdTracker

  Purpose:
    Supplies infrastructure for tracking OpenAI response IDs within the File2knowledgeAI architecture.
    This unit implements lifecycle management of unique response identifiers returned from the v1/responses
    endpoint, supporting robust multi-turn conversation chaining and cleanup processes.

  Architecture and Design:
    - Exposes the TOpenAIChatTracking class, which collects, updates, and manages response IDs
      for each conversation session.
    - Enables rollback and reset functionality by offering the ability to clear, cancel, or selectively
      remove tracked response IDs.
    - Delegates deletion logic via a callback procedure for improved control and integration into the
      broader File2knowledgeAI pipeline.

  Usage:
    - Instantiate TOpenAIChatTracking with a deletion callback to enable cleanup operations.
    - Add newly created response IDs as OpenAI replies are received.
    - Query or manipulate the list of IDs for advanced conversation state management or cancellation logic.

  Context:
    This unit is intended for use in scenarios that require traceable, persistent conversation states,
    such as asynchronous prompt-response workflows or advanced chat session logic built around the
    v1/responses API.

  Conventions follow File2knowledgeAI project and OpenAI chaining best practices.
*)

interface

uses
  System.SysUtils, System.Generics.Collections, Manager.Intf;

type
  /// <summary>
  /// Implements OpenAI response ID tracking for conversation chaining using the v1/responses endpoint.
  /// </summary>
  /// <remarks>
  /// <para>
  /// The <c>TOpenAIChatTracking</c> class provides robust management of unique response identifiers (IDs)
  /// returned from the OpenAI v1/responses endpoint. Its primary purpose is to facilitate
  /// conversation state chaining and continuity across multi-turn dialogs by persisting, retrieving, and organizing
  /// IDs associated with each API response.
  /// </para>
  /// <para>
  /// This class acts as a central registry for ID lifecycle management in your application. It allows you to add
  /// new unique IDs after each OpenAI response, delete tracked IDs with cleanup callbacks, clear or cancel all
  /// tracked IDs for reset or rollback operations, and quickly retrieve the most recent response ID.
  /// </para>
  /// <para>
  /// By maintaining an accurate and up-to-date record of response IDs, <c>TOpenAIChatTracking</c> makes it easier to
  /// chain follow-up requests and sustain conversational context per File2knowledgeAI best practices
  /// when using OpenAI’s generative APIs.
  /// </para>
  /// </remarks>
  TOpenAIChatTracking = class(TInterfacedObject, IOpenAIChatTracking)
  private
    FIds: TList<string>;
    FLastId: string;
    FDeleteProc: TProc<string>;
    function GetLastId: string;
  public
    /// <summary>
    /// Initializes a new instance of the <c>TOpenAIChatTracking</c> class.
    /// </summary>
    /// <param name="DeleteProc">
    /// The procedure to be called when a tracked ID is deleted.
    /// </param>
    constructor Create(const DeleteProc: TProc<string>);
    destructor Destroy; override;

    /// <summary>
    /// Adds a new ID to the tracking list if it is not empty or already present.
    /// Updates the last tracked ID.
    /// </summary>
    /// <param name="Value">
    /// The unique identifier to add.
    /// </param>
    procedure Add(const Value: string);

    /// <summary>
    /// Deletes the specified ID from tracking by invoking the assigned delete procedure.
    /// </summary>
    /// <param name="Value">
    /// The unique identifier to delete.
    /// </param>
    procedure Delete(const Value: string);

    /// <summary>
    /// Removes all IDs from the tracking list and clears the last tracked ID.
    /// Invokes the assigned delete procedure for each removed ID.
    /// </summary>
    procedure Clear;

    /// <summary>
    /// Cancels the most recent tracking operation and reverts the last tracked ID to the previous one.
    /// If there was only one or no ID tracked, the last ID will be set to an empty string.
    /// </summary>
    procedure Cancel;

    /// <summary>
    /// Gets the last tracked unique identifier.
    /// </summary>
    property LastId: string read GetLastId;
  end;

implementation

{ TOpenAIChatTracking }

procedure TOpenAIChatTracking.Add(const Value: string);
begin
  if not Value.Trim.IsEmpty and (FIds.LastIndexOf(Value) = -1) then
    begin
      FIds.add(Value);
      FLastId := Value;
    end;
end;

procedure TOpenAIChatTracking.Cancel;
begin
  if FIds.Count > 1 then
    FLastId := FIds[FIds.Count - 2]
  else
    FLastId := EmptyStr;
end;

procedure TOpenAIChatTracking.Clear;
begin
  for var Item in FIds do
    Delete(Item);
  FLastId := EmptyStr;
end;

constructor TOpenAIChatTracking.Create(const DeleteProc: TProc<string>);
begin
  inherited Create;
  FIds := TList<string>.Create;
  FDeleteProc := DeleteProc;
end;

procedure TOpenAIChatTracking.Delete(const Value: string);
begin
  if Assigned(FDeleteProc) then
    begin
      FDeleteProc(Value);
    end;
end;

destructor TOpenAIChatTracking.Destroy;
begin
  FIds.Free;
  inherited;
end;

function TOpenAIChatTracking.GetLastId: string;
begin
  Result := FLastId;
end;

end.
