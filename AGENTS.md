# Agents

## Workspace layout

The project root at `/workspaces/vllm/` is a plain directory containing two sibling Git repositories:

- `/workspaces/vllm/vllm/` is the vLLM repository. Run source Git commands, inspect diffs, and make source changes there.
- `/workspaces/vllm/workspace/` owns the devcontainer configuration, documentation, and local experiments. Experiments live directly in this repository and do not belong to the vLLM repository unless a task explicitly moves the work there.

`setup.sh` links configuration from the workspace repository into the project root. The script defines which links are managed.

Keep the two repositories as siblings; do not turn the source checkout into a submodule or nest it inside the workspace repository.

## Presenting commands to the user

When providing commands for the user to run, separate them into two clearly labeled sections with separate code blocks:

1. **Setup (once per shell):** Commands that establish the working directory and environment, such as `cd`, virtual environment creation or activation (`uv venv`, `source`), and persistent environment exports. Identify setup needed only once per environment as such.
2. **Run (each time):** Commands that perform the actual work, including command-specific environment variable assignments.

Use this heuristic: if the user performs the task twice in the same shell, setup runs once and the work commands run twice. Keep setup out of the repeatable command block. If the user is already in the correct directory or environment, omit those setup commands and briefly state the assumed context. Omit the setup section when no setup is needed.

## Running utilities

If you attempt to run a command or program that is not present, find a workaround like you normally do to achieve your immediate goal, but after you have achieved the goal, give a report about the missing commands.

The goal of this is that they'll be installed and then added to the devcontainer setup, so the next time you need it it won't be missing.