# sthbryan/homebrew-tap

[![brew test-bot](https://github.com/sthbryan/homebrew-tap/actions/workflows/tests.yml/badge.svg)](https://github.com/sthbryan/homebrew-tap/actions/workflows/tests.yml)

Homebrew tap with cask and formula definitions for [Apex](https://github.com/sthbryan/Apex), [Asterism](https://github.com/sthbryan/Asterism), [Curie](https://github.com/sthbryan/curie), [Fizza](https://github.com/sthbryan/fizza), [Foundry Tunnel Manager](https://github.com/sthbryan/ftm), and [Pulso](https://github.com/Zovaris/Pulso).

## Packages

| Package | Type | Platforms | Install |
|---------|------|-----------|---------|
| [apex](https://github.com/sthbryan/Apex) | Cask (desktop app) | macOS (arm64) | `brew install --cask sthbryan/tap/apex` |
| [asterism](https://github.com/sthbryan/Asterism) | Cask (desktop app) | macOS (arm64) | `brew install --cask sthbryan/tap/asterism` |
| [curie](https://github.com/sthbryan/curie) | Cask (desktop app) | macOS (arm64) | `brew install --cask sthbryan/tap/curie` |
| [fizza](https://github.com/sthbryan/fizza) | Formula (CLI) | macOS, Linux (arm64 + amd64) | `brew install sthbryan/tap/fizza` |
| [ftm](https://github.com/sthbryan/ftm) — desktop | Cask (desktop app) | macOS (arm64) | `brew install --cask sthbryan/tap/ftm` |
| [ftm](https://github.com/sthbryan/ftm) — CLI | Formula (CLI + web) | macOS, Linux (arm64 + amd64) | `brew install sthbryan/tap/ftm-cli` |
| [pulso](https://github.com/Zovaris/Pulso) | Cask (desktop app) | macOS (arm64) | `brew install --cask sthbryan/tap/pulso` |

## Usage

Install the tap once, then install any package:

```bash
brew tap sthbryan/tap

brew install --cask sthbryan/tap/apex    # Apex desktop app
brew install --cask sthbryan/tap/asterism # Asterism desktop app
brew install --cask sthbryan/tap/curie   # Curie desktop app
brew install --cask sthbryan/tap/ftm     # Foundry Tunnel Manager desktop app
brew install sthbryan/tap/fizza          # Fizza CLI
brew install sthbryan/tap/ftm-cli        # ftm CLI (installed as `ftm`)
brew install --cask sthbryan/tap/pulso   # Pulso desktop app
```

Upgrade a package after a new release:

```bash
brew update && brew upgrade fizza
brew update && brew upgrade --cask apex
brew update && brew upgrade --cask asterism
brew update && brew upgrade --cask curie
brew update && brew upgrade --cask pulso
```

Uninstall a cask (removes app data):

```bash
brew uninstall --cask --zap curie
```

## Development

This repo only holds package definitions; binaries are published to the GitHub Releases page of each project. See [MAINTAINING.md](MAINTAINING.md) for the release and update workflow.

## Sources

- [Apex](https://github.com/sthbryan/Apex)
- [Asterism](https://github.com/sthbryan/Asterism)
- [Curie](https://github.com/sthbryan/curie)
- [Fizza](https://github.com/sthbryan/fizza)
- [Foundry Tunnel Manager](https://github.com/sthbryan/ftm)
- [Pulso](https://github.com/Zovaris/Pulso)
