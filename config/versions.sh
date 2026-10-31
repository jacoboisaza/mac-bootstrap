# First-run runtime channels. setup resolves these once and writes exact patches
# to config/runtime-lock.sh; commit that generated lock for future Macs.
NODE_VERSION=22
PNPM_VERSION=10
PYTHON_VERSIONS="3.12 3.13"
GLOBAL_PYTHON_VERSION=3.13
# Gemini CLI is installed through Volta so Homebrew does not own a second Node.js.
# Review migration to antigravity-cli before Gemini CLI's planned deprecation.
GEMINI_CLI_VERSION=0.46.0
# Pin Oh My Zsh to a reviewed commit instead of executing the moving installer.
OH_MY_ZSH_REF=70ad5e3df8f7bed68aa6672029496926e632aedd
