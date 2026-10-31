# First-run runtime channels. setup resolves these once and writes exact patches
# to config/runtime-lock.sh; commit that generated lock for future Macs.
NODE_VERSION=24
PNPM_VERSION=10
PYTHON_VERSIONS="3.10 3.12 3.13 3.14"
GLOBAL_PYTHON_VERSION=3.13
# graphify (PyPI package graphifyy) is installed as a uv tool at this exact version.
GRAPHIFY_VERSION=0.9.44
# pre-commit is a uv tool too, so Homebrew never installs a Python for it.
PRE_COMMIT_VERSION=4.7.0
# Claude Code uses Anthropic's native installer, then updates itself on this
# channel (stable or latest).
CLAUDE_CODE_CHANNEL=latest
# Pin Oh My Zsh to a reviewed commit instead of executing the moving installer.
OH_MY_ZSH_REF=70ad5e3df8f7bed68aa6672029496926e632aedd
