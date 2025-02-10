#!/usr/bin/env bash

set -euo pipefail

LOGFILE="/tmp/install-and-update-nvim.log"

# Needed dependencies: awk, curl, jq, git, build-essential, ninja-build, gettext, cmake

# Cache sudo credentials
sudo -v

die() {
    echo "Error: $*" >&2
    exit 1
}

comp_pack_install() {
    # Compile Neovim
    echo "Compiling..."
    if ! make CMAKE_BUILD_TYPE=RelWithDebInfo >> "$LOGFILE" 2>&1; then
        die "Compilation failed."
    fi
    echo "Finished compiling!"

    # Build the .deb package
    pushd build >> "$LOGFILE" 2>&1
    echo "Building package..."
    if ! cpack -G DEB >> "$LOGFILE" 2>&1; then
        die "Building package failed."
    fi
    echo "Finished building!"

    # Install with dpkg
    echo "Installing package..."
    if ! sudo dpkg -i nvim-linux-x86_64.deb >> "$LOGFILE" 2>&1; then
        die "Installation failed."
    fi
    echo "Successfully installed 'nvim'!"
    popd >> "$LOGFILE" 2>&1
}

# Ensure NVIM_SRC is set
if [ -z "$NVIM_SRC" ]; then
    die "please set \$NVIM_SRC."
fi

# Ensure script dependencies are installed
if ! command -v curl > /dev/null 2>&1 || ! command -v jq > /dev/null 2>&1 || ! command -v gawk > /dev/null 2>&1 || ! command -v git > /dev/null 2>&1; then
    echo "Installing dependencies..."
    sudo apt-get update > /dev/null 2>&1 || die "updating apt failed."
    sudo apt-get install -y gawk curl git jq > /dev/null 2>&1 || die "installing Neovim dependencies failed."
    echo "Finished installing dependencies!"
fi

# Get latest upstream version
if ! upstream_version=$(curl -fsS "https://api.github.com/repos/neovim/neovim/releases/latest" | jq -r ".tag_name"); then
    die "failed to retrieve the latest Neovim release information from GitHub."
fi

# Check if nvim is installed
if ! command -v nvim >> "$LOGFILE" 2>&1; then
    # Install Neovim dependencies
    echo "Installing dependencies..."
    sudo apt-get update > /dev/null 2>&1 || die "updating apt failed."
    sudo apt-get install -y build-essential ninja-build gettext cmake > /dev/null 2>&1 || die "installing Neovim dependencies failed."
    echo "Finished installing dependencies!"

    if [ ! -d "$NVIM_SRC/.." ]; then
        mkdir -p "$NVIM_SRC/.."
    fi

    echo "Cloning Neovim..."
    if ! git clone https://github.com/neovim/neovim "$NVIM_SRC" >> "$LOGFILE" 2>&1; then
        die "git clone failed."
    fi
    echo "Finished cloning!"

    pushd "$NVIM_SRC" >> "$LOGFILE" 2>&1
    if ! git checkout "$upstream_version" >> "$LOGFILE" 2>&1; then
      die "git checkout failed. Could not switch to version '$upstream_version'."
    fi

    comp_pack_install
    popd >> "$LOGFILE" 2>&1

    exit 0
fi

local_version=$(nvim --version | head -n 1 | awk '{print $2}')

echo "Local Neovim version:    $local_version"
echo "Upstream Neovim version: $upstream_version"

if [ "$local_version" = "$upstream_version" ]; then
  echo "Neovim is up-to-date."
  exit 0
fi

pushd "$NVIM_SRC" >> "$LOGFILE" 2>&1

# Pull the updated files
if ! git pull -t -f >> "$LOGFILE" 2>&1; then
  die "git pull failed."
fi
if ! git checkout "$upstream_version" >> "$LOGFILE" 2>&1; then
  die "git checkout failed. Could not switch to version '$upstream_version'."
fi

comp_pack_install
popd >> "$LOGFILE" 2>&1

exit 0
