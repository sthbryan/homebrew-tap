# sthbryan/homebrew-tap

Homebrew tap for [Curie](https://github.com/sthbryan/curie) and related tools.

## Install Curie

```bash
brew install --cask sthbryan/tap/curie
```

Or tap first, then install:

```bash
brew tap sthbryan/tap
brew install --cask curie
```

Requirements:

- macOS Apple Silicon (`arm64`)
- macOS Big Sur or newer

## Upgrade

```bash
brew update
brew upgrade --cask curie
```

## Uninstall

```bash
brew uninstall --cask curie
# remove leftover prefs/caches:
brew uninstall --cask --zap curie
```

## How this tap is maintained

Each Curie release on GitHub publishes a DMG. This repo holds a **cask** (`Casks/curie.rb`) that points at that DMG with a fixed `version` and `sha256`.

When Curie ships a new version:

1. Upload `Curie_<version>_aarch64.dmg` to the GitHub Release.
2. Compute the checksum: `shasum -a 256 Curie_<version>_aarch64.dmg`
3. Update `version` and `sha256` in `Casks/curie.rb`
4. Commit and push this tap

Until those fields change, `brew upgrade --cask curie` will not install the new build.

## Source

- App: https://github.com/sthbryan/curie
- Releases: https://github.com/sthbryan/curie/releases
