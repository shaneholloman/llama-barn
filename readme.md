# LlamaBarn

LlamaBarn is a tiny menu bar app that lets you install and run local LLMs with just a few clicks. It automatically configures each model to run optimally on your Mac, and exposes a standard API that any app can connect to.

**Install** with `brew install --cask llamabarn` or download from [Releases ↗](https://github.com/ggml-org/LlamaBarn/releases)

<br>

![LlamaBarn](https://github.com/user-attachments/assets/9ff133d8-6a65-43d5-9672-5eb58da0dd0e)

<br>

## How it works

LlamaBarn runs as a tiny menu bar app on your Mac.

- **Install a model from the built-in catalog** -- only models that can run on your Mac are shown
- **Select an installed model to run it** -- configures and starts a server at `http://localhost:2276`
- **Use the running model via the API or web UI** -- both at `http://localhost:2276`

Under the hood LlamaBarn uses `llama.cpp` and runs models with no external dependencies.

## Use cases

Connect to any app that supports custom APIs:

- **chat UIs** like `Chatbox` or `Open WebUI`
- **CLI assistants** like `OpenCode` or `Codex`
- **editors** like `VS Code` or `Zed`
- **editor extensions** like `Cline` or `Continue`
- **custom scripts** using `curl` or libs like `ai sdk`

Or use the built-in web UI at `http://localhost:2276` to chat with the running model directly.

## Endpoints

LlamaBarn builds on the `llama.cpp` server and supports the same API endpoints:

```sh
# say "Hello" to the running model
curl http://localhost:2276/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"messages": [{"role": "user", "content": "Hello"}]}'
```

See complete reference in `llama-server` [docs ↗](https://github.com/ggml-org/llama.cpp/tree/master/tools/server#api-endpoints)
