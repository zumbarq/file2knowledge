# File2knowledgeAI

### Table of Contents

  - [Introduction](#introduction)
  - [A Laboratory Space for Innovation, Experimentation, and Demonstration](#a-laboratory-space-for-innovation-experimentation-and-demonstration)
  - [Key Features](#key-features)
    - [File Search and Vectorization](#file-search-and-vectorization)
  - [Technical Features](#technical-features)
    - [Advanced Use of OpenAI `v1/responses` Endpoint](#advanced-use-of-openai-v1responses-endpoint)
    - [Modular, Decoupled, and Testable Architecture](#modular-decoupled-and-testable-architecture)
    - [Transactional and Synchronized File Management](#transactional-and-synchronized-file-management)
    - [Comprehensive Event-Driven GenAI Response Engine](#comprehensive-event-driven-genai-response-engine)
    - [Chat Sessions and Conversational Chaining](#chat-sessions-and-conversational-chaining)
    - [UI/Business Logic Synchronization](#uibusiness-logic-synchronization)
    - [Extensibility and Rapid Onboarding](#extensibility-and-rapid-onboarding)
  - [VCL UI & WebView2](#vcl-ui--webview2)
  - [Delphi Promises (JavaScript Style)](#delphi-promises-javascript-style)
  - [Fluent JSON & RTTI](#fluent-json--rtti)
  - [Application Architecture](#application-architecture)
    - [Generalized Dependency Injection](#generalized-dependency-injection)
    - [Main Facade: `TOpenAIProvider`](#main-facade-topenaiprovider)
    - [UI/Business Logic Decoupling & Enhanced Testability](#uibusiness-logic-decoupling--enhanced-testability)
    - [Centralized and Transactional Resource Management](#centralized-and-transactional-resource-management)
    - [Modularity, Extensibility, and Robustness](#modularity-extensibility-and-robustness)
    - [Native Promises and Asynchrony](#native-promises-and-asynchrony)
    - [Orchestrated Application Startup](#orchestrated-application-startup)
    - [Structured History and Persistence Management](#structured-history-and-persistence-management)
    - ["Everything Injectable, Everything Mockable" Pattern](#everything-injectable-everything-mockable-pattern)

___

## Introduction

**File2knowledgeAI** was designed to provide a concrete implementation of OpenAI’s `v1/responses` endpoint. Its primary goal is to demonstrate how to leverage advanced file search capabilities (`file_search`) and vector store integration to enhance semantic document exploration. This approach enables more contextual, relevant, and intelligent responses when querying technical documentation, source code, or any other textual file.

Aimed at Delphi developers, this application showcases how to effectively integrate and orchestrate OpenAI/GenAI capabilities in real-world projects. The project is primarily educational: it’s intended to share best practices and promote experimentation with the `v1/responses` API, modern vectorization, indexing, and conversational chaining. It’s not a competitor to commercial tools, but a platform to encourage learning, exploration, and the joy of coding.

## A Laboratory Space for Innovation, Experimentation, and Demonstration

**File2knowledgeAI** was conceived as a real experimental lab for developers who want to quickly explore or validate the latest advancements of the OpenAI API. Its architecture, modularity, and refined VCL provide:

- **A ready-to-use foundation for testing OpenAI features**  
  No need to reinvent the wheel or stitch together technical building blocks: File2knowledgeAI offers a stable, decoupled, and fully mockable environment focused on GenAI integration in Delphi.  
  All OpenAI entry points (file_search, vectorization, chaining, conversation, event streaming, etc.) are exposed and extensible. Any new endpoint, API, or method can be integrated and tested quickly.

- **Focus on innovation, not plumbing**  
  Developers can focus purely on exploring OpenAI features (advanced prompting, response handling, vector store, conversational chaining, etc.) without worrying about infrastructure, UI/business synchronization, or low-level integration.

- **Inspiration and comparison with modern stacks**  
  The project demonstrates that with Delphi—VCL, native asynchrony, and IoC—you can build architectures as robust as those in modern JS/TS stacks, while benefiting from a strongly-typed and extremely fast environment.

- **No direct competition with commercial solutions**  
  File2knowledgeAI is not a competitor to “pro” market tools: it’s a playground, a demonstrative tool, and an open-source reference to learn, experiment, understand, and deeply validate OpenAI API usage within the Delphi/VCL framework.

Feel free to explore the code and contribute your own extensions.

## Key Features

### File Search and Vectorization
- Import of `.txt` and `.md` files to test vectorization and AI querying via OpenAI.
- Automatic embedding generation (stored on OpenAI) upon import; each query undergoes the same treatment, enabling retrieval of the most relevant passages from the indexed file base.
- Results returned with similarity scores, facilitating access to key information.
- Integration of 9 textual files including source code + documentation for Delphi API wrappers: each element is vectorized, providing contextual tutoring support.
- Currently single-platform, focused on the Delphi ecosystem.

## Technical Features

#### **Advanced Use of OpenAI `v1/responses` Endpoint**
   - Vector indexing for enriched, contextual search.
   - Prompt/response chaining via refined use of OpenAI session response IDs.

#### **Modular, Decoupled, and Testable Architecture**
   - Systematic use of IoC (Inversion of Control).
   - Strict separation between UI (VCL), business logic, and domain logic (file management, prompts, vector store…).
   - Adherence to best practices: async promises, DI (dependency injection), simplified refactoring.

#### **Transactional and Synchronized File Management**
   - Typed dictionaries for file/FileUploadId handling, atomic operations (add, delete, rollback), client/server sync.
   - Centralized controller `TFileUploadIdController` managing all file states and syncing with OpenAI’s Vector Store.

#### **Comprehensive Event-Driven GenAI Response Engine**
   - Event engine covering every event type from the `v1/responses` endpoint (classes `TEventEngineManager`, `IStreamEventHandler`).

#### **Chat Sessions and Conversational Chaining**
   - Persistent sessions, multi-turn chaining, dynamic history, automatic state JSON.
   - Centralized traceability of OpenAI IDs for intelligent response chaining.

#### **UI/Business Logic Synchronization**
   - Centralized mode logic (file search, web search, reasoning) via a unified endpoint.
   - Helpers for introspection, batch editing, and sync.

#### **Extensibility and Rapid Onboarding**
   - Abundant documentation, modular code: fast ramp-up, easy extensions, clean demo model.

## VCL UI & WebView2

- Dedicated control `TEdgeDisplayerVCL`: WebView2 encapsulated under VCL.
- Styled markdown rendering, advanced prompt and reasoning UI.
- Dynamic HTML/JS templates hot-editable (no recompilation needed).
- Async HTML/JS injection and synchronization, full decoupling via `Manager.Intf` and IoC for easy maintenance.

## Delphi Promises (JavaScript Style)

- Class `TPromise`: handles Pending, Fulfilled, Rejected states.
- Supports chaining (`&Then`, `&Catch`), auto-cleanup, thread-safe, built for heavy IO and OpenAI async requests.
- Structured error management: no more callback hell.
- Used pervasively throughout the project: async by default.

## Fluent JSON & RTTI

- Class `TJSONChain` with Delphi RTTI: fluent, chainable manipulation of JSON objects (add, edit, traverse).
- Auto serialization/deserialization via public properties.
- Support for complex structures through fluent methods, dynamic path-based assignment, natural handling of arrays and nested properties.

## Application Architecture

**File2knowledgeAI** is built on a service-oriented, ultra-modular architecture powered by Inversion of Control (IoC). This ensures strict decoupling between components, enabling:

#### Generalized Dependency Injection

- All major services (prompt execution, file management, vector stores, UI, session handling, etc.) are defined as interfaces. Their resolution, initialization, and lifecycle (singleton or transient) are orchestrated via a custom IoC container (`Manager.IoC`).
- This simplifies mocking or replacing any system component for testing or functional extensions without heavy refactoring.

#### Main Facade: `TOpenAIProvider`

- This central component orchestrates all OpenAI/GenAI integration, delegating via IoC interfaces to specialized modules: async prompt handling, session chaining, streaming, vector stores, etc.
- Switching execution engines (prompt engine, storage, etc.) is as simple as reconfiguring IoC.

#### UI/Business Logic Decoupling & Enhanced Testability

- UI interactions (VCL/WebView2) rely on interfaces (e.g., `IDisplayer`, `IServicePrompt`, `IChatSessionHistoryView`), all interchangeable, for unified handling of views, prompts, and history.
- Allows complete simulation/mocking of the UI and business backend for unit or integration testing.

#### Centralized and Transactional Resource Management

- File management (associations, indexing, snapshots/drafts, rollback/validation) relies on injected managers.  
  Example: `TFileUploadIdController` ensures consistency between client, server, and UI, with atomic operations on attached resources.

#### Modularity, Extensibility, and Robustness

- All critical logic (prompt execution, async sync, annotation, session navigation, etc.) is exposed via interfaces and designed to be plug & play via the DI container.
- Fine-grained services and their decoupling make it easy to integrate new strategies, mock components for testing, or bring in future OpenAI improvements.

#### Native Promises and Asynchrony

- The promise engine (`Manager.Async.Promise`) allows reactive, non-blocking processing of all OpenAI, UI, or IO chains (chained execution, structured error handling, thread safety) — while remaining mockable via promise interfaces for test workflows.

#### Orchestrated Application Startup

- The startup core (async launch, resource checks, UI state handling, user alerts) is also injected: the `TStartupService` works from an `IStartupContext`, assembling all critical ecosystem dependencies during app launch.

#### Structured History and Persistence Management

- Chat sessions (persistence, chaining, editing, history navigation) rely on specialized classes and interfaces (`IPersistentChat`, `IChatSessionHistoryView`), all interchangeable and extensible.

#### "Everything Injectable, Everything Mockable" Pattern

- Thanks to IoC, the app is never hardwired to any technical implementation: any component can be overridden, prototyped, or simulated (e.g., to fake an OpenAI backend, simulate storage, reroute UI, etc.).

This radical decoupling ensures flexibility, robustness to change, fast learning curves, and a strong testing culture. Any OpenAI platform evolution, workflow overhaul, or module addition (UI or services) becomes trivially integrable within the File2knowledgeAI ecosystem.