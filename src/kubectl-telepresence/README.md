# kubectl & Telepresence

This DevContainer feature installs kubectl and Telepresence without unnecessary dependencies like Helm or Minikube. It's optimized for development workflows with Kubernetes clusters.

## Features

- **Lightweight installation**: Only kubectl and Telepresence, no bloat
- **Multi-architecture support**: Works on amd64, arm64, and arm
- **Shell completions**: Bash and Zsh completions for kubectl
- **Useful aliases**: Pre-configured aliases for common Telepresence commands
- **Validation script**: Built-in validation to check connectivity
- **VS Code integration**: Includes recommended Kubernetes extensions

## Usage

Add this feature to your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/baxyz/devcontainer-features/kubectl-telepresence:0": {}
    }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `kubectl` | string | `latest` | kubectl version to install |
| `telepresence` | string | `latest` | Telepresence version to install |

## Examples

### Basic usage

```json
{
    "features": {
        "ghcr.io/baxyz/devcontainer-features/kubectl-telepresence:0": {}
    }
}
```

### Specific versions

```json
{
    "features": {
        "ghcr.io/baxyz/devcontainer-features/kubectl-telepresence:0": {
            "kubectl": "v1.28.0",
            "telepresence": "v2.15.1"
        }
    }
}
```

### kubectl only

```json
{
    "features": {
        "ghcr.io/baxyz/devcontainer-features/kubectl-telepresence:0": {
            "telepresence": "none"
        }
    }
}
```

### Telepresence only

```json
{
    "features": {
        "ghcr.io/baxyz/devcontainer-features/kubectl-telepresence:0": {
            "kubectl": "none"
        }
    }
}
```

## What's installed

### kubectl
- Latest stable version (or specified version)
- Bash and Zsh completions
- Available globally as `kubectl`

### Telepresence
- Latest version (or specified version)
- Validation script at `/usr/local/bin/telepresence-validate`
- Useful aliases:
  - `tp` → `telepresence`
  - `tpconn` → `telepresence connect`
  - `tpdisc` → `telepresence quit`
  - `tpstat` → `telepresence status`
  - `tpinter` → `telepresence intercept`
  - `tpcheck` → validation script

### VS Code Extensions
- `ms-kubernetes-tools.vscode-kubernetes-tools` - Kubernetes support
- `ms-azuretools.vscode-docker` - Docker support

## Quick start

After installation:

1. **Check installations**:
   ```bash
   kubectl version --client
   telepresence version
   tpcheck  # Run validation
   ```

2. **Connect to cluster**:
   ```bash
   kubectl config view  # Check current context
   tpconn              # Connect Telepresence
   ```

3. **Create intercept**:
   ```bash
   tpinter my-service --port 3000:3000
   ```

## Troubleshooting

- Run `tpcheck` to validate the installation
- Ensure your kubeconfig is properly set up
- For cluster access issues, check VPN connectivity
- Telepresence requires proper network permissions

## Architecture support

- ✅ Linux x86_64 (amd64)
- ✅ Linux ARM64 (aarch64)
- ✅ Linux ARM (armv7)
- ✅ Linux 386 (i386)

## Requirements

- Linux-based container
- Root access during installation
- Internet connectivity for downloads

## Contributing

This feature is part of the `baxyz/devcontainer-features` repository. Contributions and issues are welcome!
