# DevContainer Features by baxyz

This repository contains a collection of DevContainer Features developed and maintained by baxyz.

## Features

### shell-history-per-project

Persist shell history per project by mounting shell directory and creating symbolic links internally. Supports zsh, bash and fish shells.

**Key benefits:**
- Per-project history isolation
- Persistent across container rebuilds
- Multiple shell support (zsh, bash, fish)
- Team collaboration friendly
- Clean separation between personal and project commands

[📖 Documentation](./src/shell-history-per-project/README.md)

## Usage

Features from this repository are available via GitHub Container Registry. Reference them in your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/baxyz/devcontainer-features/shell-history-per-project:1": {}
    }
}
```

## Available Features

| Feature | Description | Documentation |
|---------|-------------|---------------|
| [shell-history-per-project](./src/shell-history-per-project) | Per-project shell history persistence | [README](./src/shell-history-per-project/README.md) |

## Development

This repository follows the [DevContainer Features specification](https://containers.dev/implementors/features/) and is compatible with the [DevContainer Features distribution](https://containers.dev/implementors/features-distribution/).

### Repository Structure

```
.
├── src/
│   └── shell-history-per-project/
│       ├── devcontainer-feature.json
│       ├── install.sh
│       └── README.md
├── test/
│   └── shell-history-per-project/
│       └── test.sh
└── README.md
```

### Testing

Features can be tested locally using the [DevContainer CLI](https://github.com/devcontainers/cli):

```bash
devcontainer features test --features shell-history-per-project
```

### Publishing

Features are automatically published to GitHub Container Registry via GitHub Actions when tagged releases are created.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your feature following the established patterns
4. Test your feature locally
5. Submit a pull request

## License

This project is licensed under the GNU Affero General Public License v3.0. See [LICENSE](LICENSE) for details.

## Acknowledgments

Inspired by the [DevContainers Features](https://github.com/devcontainers/features) repository and [stuart leeks' dev-container-features](https://github.com/stuartleeks/dev-container-features) for the shell-history concept, with the key difference being project-scoped rather than global user history persistence.
