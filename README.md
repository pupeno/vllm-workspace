# Pablo's vLLM Contributing Workspace

This repository is Pablo's development workspace for contributing to
[vLLM](https://github.com/vllm-project/vllm).

It keeps the devcontainer configuration, experiments, and documentation
together.

## Setup

Complete NVIDIA's
[host driver and container-toolkit setup](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
to expose the GPU.

Clone the workspace and run its setup script:

```bash
mkdir vllm
git clone https://github.com/pupeno/vllm-workspace.git vllm/workspace
vllm/workspace/setup.sh
```

Open the outer `vllm/` directory in an editor with devcontainer support, then
reopen it in its devcontainer. The post-create setup uses Python 3.12 and
vLLM's precompiled artifacts for an editable development install.

## Common Commands

Pull vLLM from upstream:

```bash
cd /workspaces/vllm/vllm
git pull upstream main
```

Serve a model:

```bash
cd /workspaces/vllm/vllm
vllm serve <model-name>
```

Run a specific test:

```bash
cd /workspaces/vllm/vllm
.venv/bin/python -m pytest tests/path/to/test_file.py -v
```

Run all lint hooks:

```bash
cd /workspaces/vllm/vllm
pre-commit run --all-files
```

For C++ or CUDA changes, follow vLLM's
[incremental compilation workflow](https://docs.vllm.ai/en/latest/contributing/incremental_build/).
