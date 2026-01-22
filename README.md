# DevContainer Features by baxyz

⚠️ **Breaking Changes**: This repository is in maintenance mode. Active development has moved to [helpers4/devcontainer](https://github.com/helpers4/devcontainer).

## Migration Status

### ✅ Migrated to helpers4

The following features have been migrated to the [helpers4/devcontainer](https://github.com/helpers4/devcontainer) repository and are now maintained there as v1:

- **shell-history-per-project** → [helpers4/devcontainer](https://github.com/helpers4/devcontainer) (v1)
- **git-absorb** → [helpers4/devcontainer](https://github.com/helpers4/devcontainer) (v1)

**For new projects**, use the helpers4 versions:
```json
{
    "features": {
        "ghcr.io/helpers4/devcontainer/shell-history-per-project:1": {},
        "ghcr.io/helpers4/devcontainer/git-absorb:1": {}
    }
}
```

### ⚠️ Deprecated: biome

The **biome** feature is **deprecated and no longer maintained**. While the v0 container image remains available on GHCR for backward compatibility (`ghcr.io/baxyz/devcontainer-features/biome:0`), we recommend:
- Migrating to a dedicated biome installation method (e.g., `npm install -D @biomejs/biome`)
- Using the official [Biome documentation](https://biomejs.dev/) for integration guidance
- Or choosing an alternative if you prefer a container-based setup

**Legacy compatibility note**: Existing devcontainer.json configurations using `ghcr.io/baxyz/devcontainer-features/biome:0` will continue to work, but no further updates will be provided.

## Usage

For new projects, refer to the [helpers4/devcontainer](https://github.com/helpers4/devcontainer) repository.

### Legacy Support

Features from this repository (v0 versions) remain available via GitHub Container Registry for backward compatibility:

```json
{
    "features": {
        "ghcr.io/baxyz/devcontainer-features/shell-history-per-project:0": {},
        "ghcr.io/baxyz/devcontainer-features/git-absorb:0": {},
        "ghcr.io/baxyz/devcontainer-features/biome:0": {}
    }
}
```

⚠️ **Note**: These v0 versions are in maintenance mode only. New features and updates are in [helpers4/devcontainer](https://github.com/helpers4/devcontainer).

## Available Features

| Feature | Status | Location |
|---------|--------|----------|
| shell-history-per-project | ✅ Migrated (v1) | [helpers4/devcontainer](https://github.com/helpers4/devcontainer) |
| git-absorb | ✅ Migrated (v1) | [helpers4/devcontainer](https://github.com/helpers4/devcontainer) |
| biome | ⚠️ Deprecated | See migration guide above |

## Development

This repository is in **maintenance mode**. Active development of DevContainer features continues at [helpers4/devcontainer](https://github.com/helpers4/devcontainer).

### Repository Structure

```
.
├── src/
│   └── biome/                          (deprecated, maintained for legacy support)
│       ├── devcontainer-feature.json
│       ├── install.sh
│       └── README.md
├── test/
│   └── biome/                          (deprecated, maintained for legacy support)
│       └── test.sh
└── README.md
```

For newly maintained features, see [helpers4/devcontainer](https://github.com/helpers4/devcontainer).

### Testing

Features in this repository (biome only, deprecated) can be tested locally using the [DevContainer CLI](https://github.com/devcontainers/cli):

```bash
devcontainer features test --features biome
```

For newly maintained features, see testing instructions at [helpers4/devcontainer](https://github.com/helpers4/devcontainer).

### Publishing

Legacy images for biome are available on GitHub Container Registry. No new releases will be published for this repository. Active feature development is published from [helpers4/devcontainer](https://github.com/helpers4/devcontainer).

## Contributing

This repository is in maintenance mode. For new feature development or contributions:

1. Visit [helpers4/devcontainer](https://github.com/helpers4/devcontainer)
2. Follow the contribution guidelines there
3. Submit pull requests to the helpers4 repository

For critical security updates or compatibility issues with the legacy biome feature, feel free to open an issue here.

## License

This project is licensed under the GNU Affero General Public License v3.0. See [LICENSE](LICENSE) for details.

## Acknowledgments

Inspired by the [DevContainers Features](https://github.com/devcontainers/features) repository and [stuart leeks' dev-container-features](https://github.com/stuartleeks/dev-container-features) for the shell-history concept, with the key difference being project-scoped rather than global user history persistence.
