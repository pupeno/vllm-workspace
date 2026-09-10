#!/usr/bin/env bash

set -euo pipefail

workspace_dir="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
project_dir="$(dirname "$workspace_dir")"
workspace_name="$(basename "$workspace_dir")"
source_dir="$project_dir/vllm"
fork_url="https://github.com/pupeno/vllm.git"
upstream_url="https://github.com/vllm-project/vllm.git"
links=(.devcontainer AGENTS.md)

if git -C "$project_dir" rev-parse --show-toplevel >/dev/null 2>&1; then
    echo "ERROR: $project_dir must not be inside a Git repository." >&2
    exit 1
fi

if [ "$(git -C "$workspace_dir" rev-parse --show-toplevel 2>/dev/null)" != "$workspace_dir" ]; then
    echo "ERROR: $workspace_dir must be the workspace repository root." >&2
    exit 1
fi

echo "==> Linking project configuration into $project_dir"
for name in "${links[@]}"; do
    link="$project_dir/$name"
    target="$workspace_name/$name"
    if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
        continue
    fi
    if [ -e "$link" ] || [ -L "$link" ]; then
        echo "ERROR: $link already exists and is not the expected symlink." >&2
        exit 1
    fi

    ln -s "$target" "$link"
    echo "    $name -> $target"
done

if [ ! -e "$source_dir" ]; then
    if git ls-remote "$fork_url" HEAD >/dev/null 2>&1; then
        echo "==> Cloning vLLM fork"
        git clone "$fork_url" "$source_dir"
    else
        echo "==> Fork not found; cloning vLLM upstream"
        git clone "$upstream_url" "$source_dir"
    fi
elif [ "$(git -C "$source_dir" rev-parse --show-toplevel 2>/dev/null)" != "$source_dir" ]; then
    echo "ERROR: $source_dir exists but is not a Git repository root." >&2
    exit 1
else
    echo "==> vLLM is already cloned"
fi

if [ "$(git -C "$source_dir" remote get-url origin 2>/dev/null || true)" = "$upstream_url" ]; then
    git -C "$source_dir" remote rename origin upstream
fi

if git -C "$source_dir" remote get-url upstream >/dev/null 2>&1; then
    git -C "$source_dir" remote set-url upstream "$upstream_url"
else
    git -C "$source_dir" remote add upstream "$upstream_url"
fi

if git -C "$source_dir" remote get-url origin >/dev/null 2>&1; then
    git -C "$source_dir" remote set-url origin "$fork_url"
else
    git -C "$source_dir" remote add origin "$fork_url"
fi

echo "==> Project ready at $project_dir"
