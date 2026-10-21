#!/usr/bin/env bash
set -euo pipefail

readonly REPOSITORY_URL="https://raw.githubusercontent.com/shahinabdi/git-config/main"
readonly SOURCE_FILE="${BASH_SOURCE[0]:-}"
if [[ -f "$SOURCE_FILE" ]]; then
    readonly LOCAL_CONFIGS_DIR="$(cd -- "$(dirname -- "$SOURCE_FILE")" && pwd)/configs"
else
    readonly LOCAL_CONFIGS_DIR=""
fi
readonly TEMP_DIR="$(mktemp -d)"
trap 'rm -rf -- "$TEMP_DIR"' EXIT

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

fail() {
    printf "${RED}Error: %s${NC}\n" "$1" >&2
    exit 1
}

prompt() {
    local prompt_text="$1"
    if { exec 3<>/dev/tty; } 2>/dev/null; then
        IFS= read -r -p "$prompt_text" REPLY <&3
        exec 3>&-
    elif [[ -z "$SOURCE_FILE" ]]; then
        fail "No terminal available for input. Download the script and run it directly."
    else
        IFS= read -r -p "$prompt_text" REPLY
    fi
}

if ! command -v git >/dev/null 2>&1; then
    fail "Git is not installed or is not available in PATH."
fi

if [[ -d "$LOCAL_CONFIGS_DIR" ]]; then
    CONFIGS_DIR="$LOCAL_CONFIGS_DIR"
else
    CONFIGS_DIR="$TEMP_DIR/configs"
    mkdir -p "$CONFIGS_DIR"
    if command -v curl >/dev/null 2>&1; then
        download() { curl --fail --silent --show-error --location "$1" --output "$2"; }
    elif command -v wget >/dev/null 2>&1; then
        download() { wget --quiet "$1" --output-document="$2"; }
    else
        fail "Install curl or wget to download the configuration files."
    fi
    for file in .gitconfig .gitconfig-lite .gitignore_global .gitmessage; do
        download "$REPOSITORY_URL/configs/$file" "$CONFIGS_DIR/$file" ||
            fail "Could not download configs/$file."
    done
fi

for file in .gitconfig .gitconfig-lite .gitignore_global .gitmessage; do
    [[ -f "$CONFIGS_DIR/$file" ]] || fail "Required file is missing: $CONFIGS_DIR/$file"
done

printf "${BLUE}Git Configuration Setup${NC}\n\n"
prompt "Enter your full name: "
git_name="$REPLY"
prompt "Enter your email: "
git_email="$REPLY"
[[ -n "$git_name" ]] || fail "Name cannot be empty."
[[ -n "$git_email" ]] || fail "Email cannot be empty."

printf "\nSelect Git configuration type:\n"
printf "1. Full (advanced features)\n"
printf "2. Lite (essential features)\n"
prompt "Enter your choice (1 or 2): "
choice="$REPLY"

case "$choice" in
    1) source_config="$CONFIGS_DIR/.gitconfig"; config_type="full" ;;
    2) source_config="$CONFIGS_DIR/.gitconfig-lite"; config_type="lite" ;;
    *) fail "Choose 1 for Full or 2 for Lite." ;;
esac

install_dir="${HOME:?HOME is not set}"
configured_file="$TEMP_DIR/.gitconfig"
cp "$source_config" "$configured_file"
git config --file "$configured_file" user.name "$git_name"
git config --file "$configured_file" user.email "$git_email"

cp "$configured_file" "$install_dir/.gitconfig"
cp "$CONFIGS_DIR/.gitignore_global" "$install_dir/.gitignore_global"
cp "$CONFIGS_DIR/.gitmessage" "$install_dir/.gitmessage"
chmod 644 "$install_dir/.gitconfig" "$install_dir/.gitignore_global" "$install_dir/.gitmessage"

printf "\n${GREEN}Git %s configuration installed successfully.${NC}\n" "$config_type"
printf "Installed: %s/.gitconfig, %s/.gitignore_global, %s/.gitmessage\n" \
    "$install_dir" "$install_dir" "$install_dir"
printf "Configured identity: %s <%s>\n" "$git_name" "$git_email"