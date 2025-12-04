# LlamaBarn

LlamaBarn is a tiny menu bar app that lets you install and run local LLMs with just a few clicks. It automatically configures each model to run optimally on your Mac, and exposes a standard API that any app can connect to.

**Install** with `brew install --cask llamabarn` or download from [Releases ↗](https://github.com/ggml-org/LlamaBarn/releases)

<br>

![LlamaBarn](https://github.com/user-attachments/assets/9ff133d8-6a65-43d5-9672-5eb58da0dd0e)

<br>

## How it works

LlamaBarn runs as a tiny menu bar app on your Mac.

- `Install a model from the built-in catalog` -- only models that can run on your Mac are shown
- `Select an installed model to run it` -- configures and starts a server at `http://localhost:2276`
- `Use the running model via the API or web UI` -- both at `http://localhost:2276`

LlamaBarn builds on `llama.cpp` and the `llama-server` that comes with it. `llama-server` runs the API and web UI, while LlamaBarn handles model installation, configuration, and process management.

## Use cases

You can use LlamaBarn in any app that supports custom LLM APIs:

- chat interfaces
- scripts
- coding assistants
- automation workflows

Or use the built-in web UI at `http://localhost:2276` to chat with the running model directly.

## Endpoints

LlamaBarn builds on `llama-server` and supports the same API endpoints:

```sh
# say "Hi" to the running model
curl http://localhost:2276/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"messages": [{"role": "user", "content": "Hi"}]}'
```

See complete reference in `llama-server` [docs ↗](https://github.com/ggml-org/llama.cpp/tree/master/tools/server#api-endpoints)

## Questions

- **Why don't I see certain models in the catalog?** — LlamaBarn excludes models that require more memory than your Mac can provide. You see only the models that you can run.
- **Can I load models that aren't in the catalog?** — Loading arbitrary models isn't currently supported, but if there's a specific model you'd like to see added, feel free to open a feature request.
