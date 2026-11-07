#!/usr/bin/env bash

# Fail fast, fail early, fail loud.
set -euo pipefail

workspace_dir="$PWD"

echo "==> Upgrading packages"
sudo apt-get update
sudo apt-get upgrade --yes

echo "==> Installing development tools"
sudo apt-get install --yes build-essential ccache cmake ninja-build python3-dev ripgrep

echo "==> Installing Starship"
sudo apt-get install starship --yes
grep -qxF 'eval "$(starship init bash)"' "$HOME/.bashrc" || echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
grep -qxF 'eval "$(starship init zsh)"' "$HOME/.zshrc" || echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
mkdir -p "$HOME/.config"
if [ ! -f "$HOME/.config/starship.toml" ]; then
    cp "$workspace_dir/.devcontainer/starship.toml" "$HOME/.config/starship.toml"
fi

echo "==> Installing Codex and Claude Code"
npm config set allow-scripts=@anthropic-ai/claude-code --location=user
npm install -g @openai/codex @anthropic-ai/claude-code

echo "==> Installing uv"
command -v uv >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

echo "==> Installing Python 3.12"
uv python install 3.12

echo "==> Setting up vLLM's Python venv"
cd "$workspace_dir/vllm"
uv venv --allow-existing --python 3.12 --seed --managed-python
source .venv/bin/activate
VLLM_USE_PRECOMPILED=1 uv pip install -e . --torch-backend=auto

echo "==> Installing vLLM's lint and CUDA test dependencies"
uv pip install -r requirements/lint.txt -r requirements/test/cuda.in --torch-backend=auto
pre-commit install

echo "==> Configuring the development environment"
for shell_rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    grep -qxF 'export CUDA_HOME=/usr/local/cuda' "$shell_rc" || echo 'export CUDA_HOME=/usr/local/cuda' >> "$shell_rc"
    grep -qxF 'export PATH="$CUDA_HOME/bin:$PATH"' "$shell_rc" || echo 'export PATH="$CUDA_HOME/bin:$PATH"' >> "$shell_rc"
    grep -qxF 'export CUDA_DEVICE_ORDER=PCI_BUS_ID' "$shell_rc" || echo 'export CUDA_DEVICE_ORDER=PCI_BUS_ID' >> "$shell_rc"
    grep -qxF 'export MAX_JOBS=8' "$shell_rc" || echo 'export MAX_JOBS=8' >> "$shell_rc"
    grep -qxF "source $workspace_dir/vllm/.venv/bin/activate" "$shell_rc" || echo "source $workspace_dir/vllm/.venv/bin/activate" >> "$shell_rc"
done
