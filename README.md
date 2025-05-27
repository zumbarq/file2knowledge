# File2KnowledgeAI
![Delphi Next Gen Ready](https://img.shields.io/badge/Delphi--Next--Gen-ready-brightgreen)
![GitHub](https://img.shields.io/badge/IDE%20Version-Delphi%2012-yellow)
![GitHub](https://img.shields.io/badge/Updated%20on%20may%2027,%202025-blue)

Mini-lab Delphi/VCL open source to experiment with the `v1/responses endpoint` of the OpenAI API in a modern environment. 
Clone & run: the app acts as a tutor for exploring my AI wrappers through the `file_search`, `embeddings`, and `chat` features.

## Introduction

File2knowledge was designed to provide a concrete implementation of the OpenAI API’s `v1/responses endpoint` (necessary for the agentic approach).
Its main goal: to demonstrate how to leverage advanced file search (file_search) features and the use of vector stores to enhance the semantic processing of documents.
This approach enables more contextual, relevant, and intelligent responses when querying technical documentation, source code, or any other textual files.

![Preview](https://github.com/MaxiDonkey/file2knowledge/blob/main/Images/F2KAni.gif?raw=true "Preview")


## Quick Start

```bash
cd path\to\your\OpenAIfolder
git clone https://github.com/Maxi/File2KnowledgeAI.git
```
open File2KnowledgeAI.dproj     # Delphi 12 Athens
Prerequisites: OpenAI API key

## Dependencies
- [DelphiGenAI (OpenAI wrapper)](https://github.com/MaxiDonkey/DelphiGenAI) version 1.0.5
- Delphi 12 Athens (or later)
- WebView2 Runtime (EdgeView2 for VCL)
- OpenAI API key (OPENAI_API_KEY)
- Windows 11 MineShaft (custom VCL theme)

![Preview](https://github.com/MaxiDonkey/SynkFlowAI/blob/main/Images/themis.png?raw=true "Preview")

## Something to know

>[!NOTE]
> Don't forget to specify the search path for the GenAI wrapper.

![Preview](https://github.com/MaxiDonkey/file2knowledge/blob/main/Images/Genai_path.png?raw=true "Preview")

>[!WARNING]
>To access reasoning visualization with O models, you must enable this feature in the Verification section of your [OpenAI account](https://platform.openai.com/settings/organization/general). The activation process takes only a few minutes.

To access the uploaded files and active vector stores, go to the [dashboard](https://platform.openai.com/logs) then navigating to the 'Storage' section.

## Features

- Upload .txt / .md → embeddings auto, Vector search handled by OpenAI

- Persistent multi-turn chat (session history preserved)

- JS-style Promises (TPromise<T>) and generalized IoC

- UI VCL & WebView2

## License

This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) License.

## Going further

To view the technical specifications [Refer to deep-dive.md](https://github.com/MaxiDonkey/file2knowledge/blob/main/deep-dive.md)
