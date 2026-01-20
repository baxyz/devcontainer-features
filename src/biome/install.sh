#!/usr/bin/env bash

# Biome DevContainer Feature
# Copyright (c) 2025 helpers4
# Licensed under AGPL-3.0 - see LICENSE file for details
#
# Installs Biome: Fast formatter, linter, and more for web projects

set -e

# Feature options
BIOME_VERSION="${VERSION:-"latest"}"
USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

# Clean up function
cleanup() {
    rm -rf /var/lib/apt/lists/*
    rm -f /tmp/biome
}

trap cleanup EXIT

# Ensure apt is in non-interactive mode
export DEBIAN_FRONTEND=noninteractive

echo "🔧 Installing Biome feature..."
echo "Username: $USERNAME"
echo "Biome version: $BIOME_VERSION"

# Update apt if needed
apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

# Check and install packages
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

# Install dependencies
echo "🔧 Installing dependencies..."
check_packages curl ca-certificates

# Detect architecture
architecture="$(uname -m)"
case $architecture in
    x86_64) architecture="linux-x64";;
    aarch64 | armv8*) architecture="linux-arm64";;
    arm64) architecture="linux-arm64";;
    *) echo "(!) Architecture $architecture unsupported"; exit 1 ;;
esac

# Install Biome
echo "🎯 Installing Biome..."

if [ "${BIOME_VERSION}" = "latest" ]; then
    echo "  📦 Fetching latest version..."
    BIOME_VERSION=$(curl -s "https://api.github.com/repos/biomejs/biome/releases/latest" | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
    if [ -z "${BIOME_VERSION}" ]; then
        echo "(!) Failed to fetch latest version"
        exit 1
    fi
fi

# Extract version number (remove @biomejs/biome@ prefix if present)
if [[ "${BIOME_VERSION}" == @biomejs/biome@* ]]; then
    VERSION_NUMBER="${BIOME_VERSION#@biomejs/biome@}"
else
    VERSION_NUMBER="${BIOME_VERSION}"
    BIOME_VERSION="@biomejs/biome@${BIOME_VERSION}"
fi

echo "  📦 Downloading Biome ${BIOME_VERSION}..."

# Download from GitHub releases
DOWNLOAD_URL="https://github.com/biomejs/biome/releases/download/${BIOME_VERSION}/biome-${architecture}"

if ! curl -fL "${DOWNLOAD_URL}" -o /tmp/biome; then
    echo "(!) Failed to download Biome from ${DOWNLOAD_URL}"
    echo "(!) Available releases: https://github.com/biomejs/biome/releases"
    exit 1
fi

# Install to /usr/local/bin
echo "  📦 Installing Biome..."
chmod +x /tmp/biome
mv /tmp/biome /usr/local/bin/biome

# Verify installation
if ! /usr/local/bin/biome --version > /dev/null 2>&1; then
    echo "(!) Biome installation verification failed"
    exit 1
fi

# Get installed version for confirmation
INSTALLED_VERSION="$(/usr/local/bin/biome --version 2>&1 | grep -o '[0-9.]*' | head -1 || echo 'unknown')"
echo "  ✅ Biome ${INSTALLED_VERSION} installed successfully"

echo
echo "🎉 Biome installation complete!"
echo
echo "📋 Usage:"
echo "  biome check .                # Check formatting and linting"
echo "  biome format --write .       # Format files"
echo "  biome lint .                 # Lint files"
echo "  biome init                   # Initialize biome.json"
echo
echo "🚀 Ready to use:"
echo "  biome --help"
echo
