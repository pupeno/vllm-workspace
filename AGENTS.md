# Agents

## Workspace layout

The project root at `/workspaces/vllm/` is a plain directory containing two sibling Git repositories:

- `/workspaces/vllm/vllm/` is the vLLM repository. Run source Git commands, inspect diffs, and make source changes there.
- `/workspaces/vllm/workspace/` owns the devcontainer configuration, documentation, and local experiments. Experiments live directly in this repository and do not belong to the vLLM repository unless a task explicitly moves the work there.

`setup.sh` links configuration from the workspace repository into the project root. The script defines which links are managed.

Keep the two repositories as siblings; do not turn the source checkout into a submodule or nest it inside the workspace repository.
