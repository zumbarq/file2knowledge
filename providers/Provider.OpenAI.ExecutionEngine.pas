unit Provider.OpenAI.ExecutionEngine;

(*
  Unit: Provider.OpenAI.ExecutionEngine

  Purpose:
    This unit implements the main execution engine for prompt submission and response handling in an OpenAI/GenAI Delphi integration.
    It manages the asynchronous lifecycle of prompt executions, including streaming, event-driven response processing,
    session storage, error management, and UI/interactor feedback.

  Architecture and approach:
    - TPromptExecutionEngine is the key orchestrator for executing user prompts:
        - Handles prompt formatting, parameter building, and contextual instructions (tools, web/file search, reasoning, etc).
        - Coordinates asynchronous streaming of results via the GenAI client, managing cancellation, error chains, file/web search and UI callbacks.
        - Delegates all event processing during response streaming to an event engine manager (IEventEngineManager).
        - Integrates with persistent session objects for chat continuity, storage, and history tracking.
    - Modularity and extensibility:
        - Designed for dependency injection; all external collaborations are interface-driven (GenAI, system prompt builder, etc).
        - Implements async promise patterns for non-blocking UI and workflow chaining.
        - All event/stream-specific logic is delegated to pluggable managers (cf. Provider.OpenAI.StreamEvents).
    - Robust lifecycle management:
        - Explicit control over chat turn creation, prompt history, intermediate/finalization states, cancellation, and error handling.
        - All UI and session feedback is routed explicitly for user experience and recoverability.

  Developer highlights:
    - To use, instantiate TPromptExecutionEngine via IoC or directly, providing required dependencies.
    - Execute() launches a full-featured prompt including streaming, event routing, session and history management.
    - Extendable by customizing IEventEngineManager or session/prompt builders for test or advanced scenarios.
    - Clear segregation of responsibilities for async chain, streaming, session save, and result collection.

  Dependencies:
    - GenAI and GenAI.Types for OpenAI contracts and API streaming.
    - Chat/session managers, prompt builders, output displayers, and cancellation management.
    - Event engine manager (cf. Provider.OpenAI.StreamEvents) for event-based streaming handling.

  This unit is designed for robustness, modularity, and scalability in prompt execution and streaming scenarios,
  enabling maintainable and extensible Delphi OpenAI/GenAI integrations aligned with best architecture practices (SOLID, async, DI).

*)

interface

uses
  System.SysUtils, System.classes, System.Generics.Collections, System.DateUtils, System.Threading,
  GenAI, GenAI.Types,
  Manager.Async.Promise, Manager.Intf, Manager.IoC, ChatSession.Controller, Manager.Utf8Mapping,
  Helper.UserSettings, Manager.Types, Provider.InstructionManager, Provider.OpenAI.StreamEvents;

type
  /// <summary>
  ///   Main execution engine for OpenAI/GenAI prompt submission and streaming response
  ///   management within a Delphi application. Handles the full lifecycle of a prompt request,
  ///   including asynchronous API calls, streaming response processing, session tracking,
  ///   storage, and user interface integration.
  /// </summary>
  /// <remarks>
  ///   <para>
  ///   This class serves as the core orchestrator for all prompt execution workflows:
  ///   - Constructs prompt parameters (tools, reasoning, context, etc.) according to application settings.
  ///   - Manages integration with the GenAI client for both synchronous and asynchronous operations.
  ///   - Delegates streaming event processing to an event engine manager (<c>IEventEngineManager</c>),
  ///     which routes each event to registered event handlers.
  ///   - Tracks and persists session state, including chat history and streaming buffers.
  ///   - Coordinates error and cancellation handling for robust, user-friendly UX.
  ///   </para>
  ///   <para>
  ///   Designed for extensibility and modularity via dependency injection; can be replaced or extended
  ///   for custom scenarios, alternative engines, or unit testing.
  ///   </para>
  ///   Example usage:
  ///   <code>
  ///   var
  ///     Engine: IPromptExecutionEngine;
  ///   begin
  ///     Engine := TPromptExecutionEngine.Create(GenAIClient, SystemPromptBuilder);
  ///     Engine.Execute('Tell me a joke').&Then(
  ///       procedure(Response: string)
  ///       begin
  ///         ShowMessage(Response);
  ///       end
  ///     );
  ///   end;
  ///   </code>
  /// </remarks>
  TPromptExecutionEngine = class(TInterfacedObject, IPromptExecutionEngine)
  private
    /// <summary>
    /// The GenAI client instance used for all API communications.
    /// </summary>
    FClient: IGenAI;

    /// <summary>
    /// The builder instance for creating system/contextual prompts to send with user prompts.
    /// </summary>
    FSystemPromptBuilder: ISystemPromptBuilder;

    /// <summary>
    /// The event engine manager responsible for routing and processing streaming events during AI response flows.
    /// </summary>
    FEventEngineManager: IEventEngineManager;

    /// <summary>
    /// Builds the reasoning parameters structure used for advanced reasoning models.
    /// </summary>
    /// <returns>
    /// A fully populated <c>TReasoningParams</c> instance.
    /// </returns>
    function CreateReasoningEffortParams: TReasoningParams;

    /// <summary>
    /// Constructs the parameters for web search tool integration, selecting the preview/search tool type.
    /// </summary>
    /// <returns>
    /// An initialized <c>THostedToolParams</c> object ready for use in request configuration.
    /// </returns>
    function BuildWebSearchToolChoiceParams: THostedToolParams;

    /// <summary>
    /// Creates and configures file search tool parameters, supplying vector store identifiers if available.
    /// </summary>
    /// <returns>
    /// A <c>TResponseToolParams</c> object containing file search configuration.
    /// </returns>
    function CreateWebSearchToolParamsWithContext: TResponseToolParams;

    /// <summary>
    /// Creates and configures web search tool parameters, optionally including user geolocation context.
    /// </summary>
    /// <returns>
    /// A <c>TResponseToolParams</c> object for web search tool configuration.
    /// </returns>
    function CreateFileSearchToolParamsWithStore: TResponseToolParams;

    /// <summary>
    ///   Finalizes the current chat turn, updating stored search and reasoning results and saving session state.
    /// </summary>
    procedure FinalizeCurrentTurn;

    /// <summary>
    ///   Adds a new chat turn to the persistent session, stamping it with the current timestamp.
    /// </summary>
    /// <returns>
    ///   The new <c>TChatTurn</c> object representing the prompt/response exchange.
    /// </returns>
    function AddChatTurnWithTimestamp: TChatTurn;

    /// <summary>
    /// Event handler invoked at the start of a chat turn,
    /// used to reset UI state and displayers before streaming begins.
    /// </summary>
    /// <param name="Sender">
    /// The caller context for the start event (typically async engine or UI).
    /// </param>
    procedure OnTurnStart(Sender: TObject);

    /// <summary>
    /// Event handler invoked after a successful completion of a chat turn,
    /// finalizing UI and session state and saving results to storage.
    /// </summary>
    /// <param name="Sender">
    /// The sender of the completion notification (engine, promise, etc.).
    /// </param>
    procedure OnTurnSuccess(Sender: TObject);

    /// <summary>
    /// Event handler triggered when an error occurs during prompt execution or streaming.
    /// Finalizes state and displays an error message.
    /// </summary>
    /// <param name="Sender">
    /// The sender context of the error event.
    /// </param>
    /// <param name="Error">
    /// Description of the error encountered.
    /// </param>
    procedure OnTurnError(Sender: TObject; Error: string);

    /// <summary>
    /// Event handler triggered when the current chat turn is cancelled by the user or system.
    /// Cleans up UI state, flags cancellation, and persists session data.
    /// </summary>
    /// <param name="Sender">
    /// The context object triggering cancellation.
    /// </param>
    procedure OnTurnCancelled(Sender: TObject);
  public
    /// <summary>
    /// Submits a prompt for execution via the OpenAI/GenAI engine, handling streaming
    /// of results, session management, and output tracking.
    /// </summary>
    /// <param name="Prompt">
    /// The user's prompt or question to be sent to the AI for completion or answer.
    /// </param>
    /// <returns>
    /// A <c>TPromise&lt;string&gt;</c> that resolves asynchronously with the AI's response text,
    /// or is rejected if an error or cancellation occurs.
    /// </returns>
    function Execute(const Prompt: string): TPromise<string>;

    constructor Create(const GenAIClient: IGenAI; const AystemPromptBuilder: ISystemPromptBuilder);
  end;

implementation

{ TPromptExecutionEngine }

function TPromptExecutionEngine.AddChatTurnWithTimestamp: TChatTurn;
begin
  Result := PersistentChat.AddPrompt;

  if Length(PersistentChat.CurrentChat.Data) = 1 then
    begin
      PersistentChat.CurrentChat.CreatedAt := DateTimeToUnix(Now, False);
      PersistentChat.CurrentChat.Title := 'New chat ...';
    end;

  PersistentChat.CurrentChat.ModifiedAt := DateTimeToUnix(Now, False);
end;

function TPromptExecutionEngine.BuildWebSearchToolChoiceParams: THostedToolParams;
begin
  Result := THostedToolParams.Create
    .&Type('web_search_preview')
end;

constructor TPromptExecutionEngine.Create(const GenAIClient: IGenAI;
  const AystemPromptBuilder: ISystemPromptBuilder);
begin
  inherited Create;
  FClient := GenAIClient;
  FSystemPromptBuilder := AystemPromptBuilder;
  FEventEngineManager := TEventEngineManager.Create;
end;

function TPromptExecutionEngine.CreateFileSearchToolParamsWithStore: TResponseToolParams;
begin
  Result := TResponseFileSearchParams.New;

  if Length(FileStoreManager.VectorStore) > 0 then
    (Result as TResponseFileSearchParams).VectorStoreIds([FileStoreManager.VectorStore]);
end;

function TPromptExecutionEngine.CreateReasoningEffortParams: TReasoningParams;
begin
  {--- Create reasoning effort }
  Result := TReasoningParams.Create.Effort(Settings.ReasoningEffort);

  if Settings.UseSummary then
    Result.Summary(Settings.ReasoningSummary);
end;

function TPromptExecutionEngine.CreateWebSearchToolParamsWithContext: TResponseToolParams;
begin
  Result := TResponseWebSearchParams.New
    .SearchContextSize(Settings.WebContextSize);

  if not Settings.Country.Trim.IsEmpty or not Settings.City.Trim.IsEmpty then
    (Result as TResponseWebSearchParams).UserLocation(
      TResponseUserLocationParams.New
        .Country(Settings.Country)
        .City(Settings.City)
    );
end;

function TPromptExecutionEngine.Execute(const Prompt: string): TPromise<string>;
var
  StreamBuffer: string;
begin
  FClient.API.HttpClient.ResponseTimeout := TTimeOut.TextToCardinal(Settings.TimeOut);

  var CurrentTurn := AddChatTurnWithTimestamp;
  CurrentTurn.Storage := True;
  CurrentTurn.Prompt := Prompt;

  var ChunkDisplayedCount := 0;

  Result := TPromise<string>.Create(
    procedure(Resolve: TProc<string>; Reject: TProc<Exception>)
    begin
      FClient.Responses.AsynCreateStream(
        procedure (Params: TResponsesParams)
        begin
          {--- Set the AI model based on the enabled mode }
          if sf_reasoning in ServiceFeatureSelector.FeatureModes then
            begin
              Params.Model(Settings.ReasoningModel);
              Params.Reasoning(CreateReasoningEffortParams);
            end
          else
            begin
              Params.Model(Settings.SearchModel);
            end;

          {--- Configure the main user prompt input }
          Params.Input(CurrentTurn.Prompt);

          {--- Apply contextual system instructions }
          Params.Instructions(FSystemPromptBuilder.BuildSystemPrompt);

          {--- Explicitly specify tool choices based on active mode }
          if sf_webSearch in ServiceFeatureSelector.FeatureModes then
            begin
              Params.ToolChoice(BuildWebSearchToolChoiceParams);
            end;

          {--- Define the set of available tools according to current feature modes }
          if not (sf_reasoning in ServiceFeatureSelector.FeatureModes) then
            begin
              if sf_fileSearchDisabled in ServiceFeatureSelector.FeatureModes then
                begin
                  if sf_webSearch in ServiceFeatureSelector.FeatureModes then
                    begin
                      Params.Tools([CreateWebSearchToolParamsWithContext]);
                    end;
                end
              else
                begin
                  if sf_webSearch in ServiceFeatureSelector.FeatureModes then
                    begin
                      if Length(FileStoreManager.VectorStore) > 0 then
                        begin
                          Params.Tools([
                            CreateFileSearchToolParamsWithStore,
                            CreateWebSearchToolParamsWithContext
                          ]);
                        end
                      else
                        begin
                          Params.Tools([
                            CreateWebSearchToolParamsWithContext
                          ]);
                        end;
                    end
                  else
                    begin
                      if Length(FileStoreManager.VectorStore) > 0 then
                        begin
                          Params.Tools([CreateFileSearchToolParamsWithStore]);
                        end;
                    end;
                end
            end
          else
            begin
              {--- No web search tool available for reasoning model }
            end;

          {--- Enable file_search results inclusion }
          Params.Include([TOutputIncluding.file_search_result]);

          {--- Enable streaming mode for the response }
          Params.Stream(True);

          {--- Enable or disable conversation storage based on configuration }
          Params.Store(CurrentTurn.Storage);

          {--- Link the request to a previous response ID for contextual thread management }
          if CurrentTurn.Storage and not ResponseTracking.LastId.IsEmpty then
            begin
              Params.PreviousResponseId(ResponseTracking.LastId);
            end;

          {--- Serialize the final request to the prompt data collector }
          CurrentTurn.JsonPrompt := Params.ToJsonString();

          {--- Persistently save the current prompt to file }
          PersistentChat.SaveToFile;
        end,

        function : TAsynResponseStream
        begin
          Result.Sender := CurrentTurn;

          Result.OnStart := OnTurnStart;

          Result.OnProgress :=
            procedure (Sender: TObject; Chunk: TResponseStream)
            begin
              try
                if not FEventEngineManager.AggregateStreamEvents(Chunk, StreamBuffer, ChunkDisplayedCount) then
                  begin
                    {--- Event error }
                    ResponseTracking.Cancel;
                    Reject(Exception.Create('(' + Chunk.Code + ')' + Chunk.Message));
                  end;
              except
                {--- Silent Exception - To avoid RSS-391 error for unpatched 12.1.
                     And also if a processing in AggregateStreamEvents generated an error }
              end;
            end;

          Result.OnSuccess :=
            procedure (Sender: TObject)
            begin
              OnTurnSuccess(Sender);
              Resolve(CurrentTurn.Response);
            end;

          Result.OnError :=
            procedure (Sender: TObject; Error: string)
            begin
              CurrentTurn.Response := StreamBuffer;
              OnTurnError(Sender, Error);
              Reject(Exception.Create(Error));
            end;

          Result.OnDoCancel :=
            function : Boolean
            begin
              Result := Cancellation.IsCancelled;
              if Result then
                begin
                  EdgeDisplayer.HideReasoning;
                  EdgeDisplayer.Display('Operation canceled');
                end;
            end;

          Result.OnCancellation :=
            procedure (Sender: TObject)
            begin
              CurrentTurn.Response := StreamBuffer + #10#10 + 'Aborted';
              OnTurnCancelled(Sender);
              Reject(Exception.Create('Aborted'));
            end;
        end);
    end);
end;

procedure TPromptExecutionEngine.FinalizeCurrentTurn;
begin
  var CurrentTurn := PersistentChat.CurrentPrompt;

  if FileSearchDisplayer.Text.IsEmpty then
    FileSearchDisplayer.Display('no item found');
  CurrentTurn.FileSearch := FileSearchDisplayer.Text;

  if WebSearchDisplayer.Text.IsEmpty then
    WebSearchDisplayer.Display('no item found');
  CurrentTurn.WebSearch := WebSearchDisplayer.Text;

  if ReasoningDisplayer.Text.IsEmpty then
    ReasoningDisplayer.Display('no item found');
  CurrentTurn.Reasoning := ReasoningDisplayer.Text;

  PersistentChat.SaveToFile;
end;

procedure TPromptExecutionEngine.OnTurnCancelled(Sender: TObject);
begin
  FinalizeCurrentTurn;
  ResponseTracking.Cancel;
  Cancellation.Cancel;
  PersistentChat.SaveToFile;
  ChatSessionHistoryView.Refresh(nil);
end;

procedure TPromptExecutionEngine.OnTurnError(Sender: TObject; Error: string);
begin
  FinalizeCurrentTurn;
  EdgeDisplayer.HideReasoning;
  EdgeDisplayer.Display(TUtf8Mapping.CleanTextAsUTF8(Error));
  Cancellation.Cancel;
  PersistentChat.SaveToFile;
  ChatSessionHistoryView.Refresh(nil);
end;

procedure TPromptExecutionEngine.OnTurnStart(Sender: TObject);
begin
  Cancellation.Reset;
  EdgeDisplayer.Prompt(ServicePrompt.Text);
  ServicePrompt.Clear;
  FileSearchDisplayer.Clear;
  WebSearchDisplayer.Clear;
  ReasoningDisplayer.Clear;
  EdgeDisplayer.ShowReasoning;
end;

procedure TPromptExecutionEngine.OnTurnSuccess(Sender: TObject);
begin
  FinalizeCurrentTurn;
  EdgeDisplayer.DisplayStream(sLineBreak + sLineBreak);
  Cancellation.Cancel;
  PersistentChat.SaveToFile;
  ChatSessionHistoryView.Refresh(nil);
  PromptSelector.Update;
end;


end.
