# sthbryan/homebrew-tap

Homebrew tap for [Curie](https://github.com/sthbryan/curie), [Fizza](https://github.com/sthbryan/fizza), and related tools.

## Packages

| Package | Type | Install |
|---------|------|---------|
| **curie** | cask (macOS app) | `brew install --cask sthbryan/tap/curie` |
| **fizza** | formula (CLI) | `brew install sthbryan/tap/fizza` |

### Curie (desktop app)

```bash
brew install --cask sthbryan/tap/curie
```

- macOS Apple Silicon (`arm64`)
- macOS Big Sur or newer

```bash
brew update && brew upgrade --cask curie
brew uninstall --cask --zap curie
```

### Fizza (CLI + local web + MCP)

```bash
brew install sthbryan/tap/fizza
```

- macOS and Linux (`arm64` + `amd64`)

```bash
brew update && brew upgrade fizza
fizza --version
fizza serve
```

## How this tap is maintained

This repo only holds package definitions. Binaries live on GitHub Releases of each project.

### Curie (cask)

Each Curie release publishes a DMG. Update `Casks/curie.rb`:

1. Upload `Curie_<version>_aarch64.dmg` to the GitHub Release.
2. `shasum -a 256 Curie_<version>_aarch64.dmg`
3. Bump `version` and `sha256` in `Casks/curie.rb`
4. Commit and push this tap

### Fizza (formula)

Each Fizza release publishes platform tarballs. Update `Formula/fizza.rb`:

1. Publish `fizza_<version>_{darwin,linux}_{arm64,amd64}.tar.gz`
2. Copy hashes from `fizza_<version>_checksums.txt` (or `shasum -a 256`)
3. Bump `version` and every platform `sha256` in `Formula/fizza.rb`
4. Commit and push this tap

Until those fields change, `brew upgrade` will not install the new build.

## Source

- Curie: https://github.com/sthbryan/curie
- Fizza: https://github.com/sthbryan/fizza
