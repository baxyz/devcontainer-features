#!/usr/bin/env bash

# kubectl & Telepresence DevContainer Feature
# Copyright (c) 2025 baxyz
# Licensed under AGPL-3.0 - see LICENSE file for details
#
# Installs kubectl and Telepresence without unnecessary dependencies (no Helm, no Minikube)
# Based on official kubectl-helm-minikube feature but simplified

set -e

# Feature options
KUBECTL_VERSION="${KUBECTL:-"latest"}"
TELEPRESENCE_VERSION="${TELEPRESENCE:-"latest"}"
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

USERHOME="/home/$USERNAME"
if [ "$USERNAME" = "root" ]; then
    USERHOME="/root"
fi

# Clean up function
cleanup() {
    rm -rf /var/lib/apt/lists/*
}

trap cleanup EXIT

# Ensure apt is in non-interactive mode
export DEBIAN_FRONTEND=noninteractive

echo "🔧 Installing kubectl & Telepresence feature..."
echo "Username: $USERNAME"
echo "User home: $USERHOME"
echo "kubectl version: $KUBECTL_VERSION"
echo "Telepresence version: $TELEPRESENCE_VERSION"

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
check_packages curl ca-certificates coreutils gnupg2 bash-completion iptables

if ! type git > /dev/null 2>&1; then
    check_packages git
fi

# Detect architecture
architecture="$(uname -m)"
case $architecture in
    x86_64) architecture="amd64";;
    aarch64 | armv8*) architecture="arm64";;
    aarch32 | armv7* | armvhf*) architecture="arm";;
    i?86) architecture="386";;
    *) echo "(!) Architecture $architecture unsupported"; exit 1 ;;
esac

# Install kubectl
if [ "${KUBECTL_VERSION}" != "none" ]; then
    echo "🎯 Installing kubectl..."

    if [ "${KUBECTL_VERSION}" = "latest" ] || [ "${KUBECTL_VERSION}" = "lts" ] || [ "${KUBECTL_VERSION}" = "current" ] || [ "${KUBECTL_VERSION}" = "stable" ]; then
        KUBECTL_VERSION="$(curl -sSL https://dl.k8s.io/release/stable.txt)"
    fi

    if [ "${KUBECTL_VERSION::1}" != 'v' ]; then
        KUBECTL_VERSION="v${KUBECTL_VERSION}"
    fi

    echo "  📦 Downloading kubectl ${KUBECTL_VERSION}..."
    curl -sSL -o /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${architecture}/kubectl"
    chmod 0755 /usr/local/bin/kubectl

    # Verify installation
    if ! type kubectl > /dev/null 2>&1; then
        echo '(!) kubectl installation failed!'
        exit 1
    fi

    # kubectl bash completion
    kubectl completion bash > /etc/bash_completion.d/kubectl

    # kubectl zsh completion
    if [ -e "${USERHOME}/.oh-my-zsh" ]; then
        mkdir -p "${USERHOME}/.oh-my-zsh/completions"
        kubectl completion zsh > "${USERHOME}/.oh-my-zsh/completions/_kubectl"
        chown -R "${USERNAME}" "${USERHOME}/.oh-my-zsh"
    fi

    echo "  ✅ kubectl ${KUBECTL_VERSION} installed successfully"
fi

# Install Telepresence
if [ "${TELEPRESENCE_VERSION}" != "none" ]; then
    echo "🚀 Installing Telepresence..."

    if [ "${TELEPRESENCE_VERSION}" = "latest" ]; then
        echo "  📦 Downloading latest Telepresence..."
        if ! curl -fL https://github.com/telepresenceio/telepresence/releases/latest/download/telepresence-linux-${architecture} -o /usr/local/bin/telepresence; then
            echo "  🔄 GitHub download failed, trying fallback..."
            if ! curl -fL --insecure https://app.getambassador.io/download/tel2/linux/${architecture}/latest/telepresence -o /usr/local/bin/telepresence; then
                echo "(!) All Telepresence download methods failed"
                exit 1
            fi
        fi
    else
        echo "  📦 Downloading Telepresence ${TELEPRESENCE_VERSION}..."
        if ! curl -fL "https://github.com/telepresenceio/telepresence/releases/download/${TELEPRESENCE_VERSION}/telepresence-linux-${architecture}" -o /usr/local/bin/telepresence; then
            echo "(!) Failed to download Telepresence ${TELEPRESENCE_VERSION}"
            exit 1
        fi
    fi

    chmod +x /usr/local/bin/telepresence

    # Verify installation
    if ! /usr/local/bin/telepresence version > /dev/null 2>&1; then
        echo "(!) Telepresence installation verification failed"
        exit 1
    fi

    # Add useful aliases for the user
    add_telepresence_aliases() {
        local shell_rc="$1"
        cat >> "$shell_rc" << 'EOF'

# Telepresence aliases
alias tp='telepresence'
alias tpconn='telepresence connect'
alias tpdisc='telepresence quit'
alias tpstat='telepresence status'
alias tpinter='telepresence intercept'
alias tpcheck='/usr/local/bin/telepresence-validate'
EOF
    }

    if [ -f "${USERHOME}/.bashrc" ]; then
        add_telepresence_aliases "${USERHOME}/.bashrc"
    fi

    if [ -f "${USERHOME}/.zshrc" ]; then
        add_telepresence_aliases "${USERHOME}/.zshrc"
    fi

    TELEPRESENCE_INSTALLED_VERSION="$(/usr/local/bin/telepresence version | grep 'Client' | awk '{print $3}' || echo 'unknown')"
    echo "  ✅ Telepresence ${TELEPRESENCE_INSTALLED_VERSION} installed successfully"

    # Install validation script
    cat > /usr/local/bin/telepresence-validate << 'EOF'
#!/bin/bash

echo "🔍 Telepresence Validation"
echo "=========================="

failed=0

# Test Telepresence installation
if command -v telepresence >/dev/null 2>&1; then
    echo "✅ Telepresence installed"
else
    echo "❌ Telepresence not installed"
    ((failed++))
fi

# Test cluster connectivity (using raw API call - most reliable)
if timeout 3 kubectl get --raw=/version --request-timeout=2s >/dev/null 2>&1; then
    echo "✅ Kubernetes cluster accessible"
else
    echo "❌ Cluster unreachable (VPN required?)"
    ((failed++))
fi

echo
echo "📋 Available aliases:"
echo "  tp           - telepresence"
echo "  tpconn       - telepresence connect"
echo "  tpdisc       - telepresence quit"
echo "  tpstat       - telepresence status"
echo "  tpinter      - telepresence intercept"
echo "  tpcheck      - this validation script"

if [ $failed -gt 0 ]; then
    echo
    echo "⚠️  Some validation checks failed"
fi
EOF
    chmod +x /usr/local/bin/telepresence-validate
fi

echo
echo "🎉 kubectl & Telepresence installation complete!"
echo
echo "📋 Installed tools:"
[ "${KUBECTL_VERSION}" != "none" ] && echo "  • kubectl: ${KUBECTL_VERSION}"
[ "${TELEPRESENCE_VERSION}" != "none" ] && echo "  • Telepresence: ${TELEPRESENCE_INSTALLED_VERSION:-$TELEPRESENCE_VERSION}"
echo
echo "🚀 Ready to use:"
[ "${KUBECTL_VERSION}" != "none" ] && echo "  kubectl version --client"
[ "${TELEPRESENCE_VERSION}" != "none" ] && echo "  telepresence status"
[ "${TELEPRESENCE_VERSION}" != "none" ] && echo "  tpcheck  # validation script"
echo
