# Biome

Installs [Biome](https://biomejs.dev/), a fast formatter, linter, and more for web projects. One toolchain for your web project.

## Features

- 🚀 Fast formatter and linter for JavaScript, TypeScript, JSX, JSON, CSS, and more
- 📦 Lightweight single binary installation
- 🎯 Multi-architecture support (x86_64, aarch64)
- ⚙️ Configurable version installation
- 🔄 Automatic latest version detection

## Example Usage

```jsonc
{
    "features": {
        "ghcr.io/helpers4/devcontainer-features/biome:0": {}
    }
}
```

### With specific version

```jsonc
{
    "features": {
        "ghcr.io/helpers4/devcontainer-features/biome:0": {
            "version": "2.3.0"
        }
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|------------|-------------|------|---------------|
| `version` | Version of Biome to install. Use 'latest' for the most recent version, or specify a version like '2.3.0'. | string | latest |

## Supported Platforms

- Linux x86_64
- Linux ARM64 (aarch64)

## What is Biome?

Biome is a fast formatter, linter, and more for JavaScript, TypeScript, JSX, JSON, CSS, and GraphQL. It's designed to be a drop-in replacement for tools like Prettier and ESLint, with a focus on speed and developer experience.

### Key Features

- **Format**: Format your code with a high-performance formatter
- **Lint**: Catch errors and enforce best practices
- **Import Sorting**: Organize your imports automatically
- **One Tool**: Replace multiple tools with a single binary

## Usage

After installation, you can use Biome from the command line:

```bash
# Initialize Biome in your project
biome init

# Check formatting and linting
biome check .

# Format files
biome format --write .

# Lint files
biome lint .

# Run checks in CI mode
biome ci .
```

## Configuration

Biome uses a `biome.json` file for configuration. You can create one with:

```bash
biome init
```

Example configuration:

```json
{
  "$schema": "https://biomejs.dev/schemas/1.9.4/schema.json",
  "organizeImports": {
    "enabled": true
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true
    }
  },
  "formatter": {
    "enabled": true,
    "indentStyle": "space"
  }
}
```

## Documentation

For more information, visit:
- [Biome Official Documentation](https://biomejs.dev/)
- [Getting Started Guide](https://biomejs.dev/guides/getting-started/)
- [Biome GitHub Repository](https://github.com/biomejs/biome)

## License

This DevContainer Feature is licensed under AGPL-3.0.

Biome itself is licensed under MIT or Apache-2.0.
