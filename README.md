# sthbryan/homebrew-tap

[![CI](https://github.com/sthbryan/homebrew-tap/actions/workflows/tests.yml/badge.svg)](https://github.com/sthbryan/homebrew-tap/actions/workflows/tests.yml)
[![last commit](https://img.shields.io/github/last-commit/sthbryan/homebrew-tap)](https://github.com/sthbryan/homebrew-tap/commits/main)
[![packages](https://img.shields.io/badge/packages-8-blue)](#packages)
[![platforms](https://img.shields.io/badge/platforms-macOS%20arm64%20%7C%20Linux%20arm64%2Famd64-lightgrey)](#packages)
[![Homebrew tap](https://img.shields.io/badge/Homebrew-tap-FBB040)](https://brew.sh)

A Homebrew tap of cask and formula definitions for the desktop apps and CLIs I
ship. This repository contains **only package definitions**. Every binary is
published to the GitHub Releases page of its own project, and a release here
means bumping `version` and `sha256`.

## Quick start

```bash
brew tap sthbryan/tap
```

Then install any package from the table below, for example:

```bash
brew install --cask sthbryan/tap/curie   # a desktop app
brew install sthbryan/tap/fizza          # a CLI
```

## Packages

| Package | Type | Platforms | Version | Install |
| --- | --- | --- | --- | --- |
| [`apex`](https://github.com/sthbryan/Apex) | Cask (desktop app) | macOS arm64 | 0.9.1 | `brew install --cask sthbryan/tap/apex` |
| [`asterism`](https://github.com/sthbryan/Asterism) | Cask (desktop app) | macOS arm64 | 0.2.0 | `brew install --cask sthbryan/tap/asterism` |
| [`curie`](https://github.com/sthbryan/curie) | Cask (desktop app) | macOS arm64 | 0.8.0 | `brew install --cask sthbryan/tap/curie` |
| [`ftm`](https://github.com/sthbryan/ftm) | Cask (desktop app) | macOS arm64 | 0.16.0 | `brew install --cask sthbryan/tap/ftm` |
| [`gigi`](https://github.com/Zovaris/GiGi) | Cask (desktop app + CLI) | macOS arm64 | 1.0.0 | `brew install --cask sthbryan/tap/gigi` |
| [`pulso`](https://github.com/Zovaris/Pulso) | Cask (desktop app) | macOS arm64 | 0.3.0 | `brew install --cask sthbryan/tap/pulso` |
| [`fizza`](https://github.com/sthbryan/fizza) | Formula (CLI) | macOS, Linux (arm64 + amd64) | 1.0.0 | `brew install sthbryan/tap/fizza` |
| [`ftm-cli`](https://github.com/sthbryan/ftm) | Formula (CLI + local web) | macOS, Linux (arm64 + amd64) | 0.16.0 | `brew install sthbryan/tap/ftm-cli` |

Two details worth knowing:

- `ftm-cli` installs a binary named `ftm`, so the CLI and the desktop cask never
  collide on your `PATH`.
- `apex` updates itself from GitHub Releases. `brew upgrade` only touches it with
  `brew upgrade --greedy --cask apex`.

## Upgrading

```bash
brew update && brew upgrade fizza
brew update && brew upgrade --cask curie
```

## Uninstalling

```bash
brew uninstall sthbryan/tap/fizza
brew uninstall --cask sthbryan/tap/curie
```

Casks ship a `zap trash` list, so `--zap` also removes the app's preferences,
caches and support files:

```bash
brew uninstall --cask --zap curie
```

## Gatekeeper and notarization

None of the apps are notarized. Every cask ad-hoc codesigns the bundle and
strips the quarantine attribute during install, and the CLI formulae do the same
for their binaries. If macOS still refuses to open something, re-sign it by hand:

```bash
# desktop app
codesign --force --deep --sign - /Applications/Curie.app
xattr -cr /Applications/Curie.app

# CLI installed by a formula
codesign --force --sign - "$(brew --prefix)/opt/fizza/bin/fizza"
xattr -cr "$(brew --prefix)/opt/fizza/bin/fizza"

# or reinstall a cask without quarantine
HOMEBREW_CASK_OPTS="--no-quarantine" brew reinstall --cask sthbryan/tap/curie
```

## Repository layout

```
Casks/      one .rb per desktop app (DMG or ZIP release)
Formula/    one .rb per CLI (prebuilt release binaries)
bin/        maintainer scripts, e.g. the bundle-id migration helper
.github/    CI: brew test-bot (style, audit, readall)
```

## CI

Every push that touches `Casks/`, `Formula/`, `bin/` or the workflows runs
[`brew test-bot`](https://github.com/sthbryan/homebrew-tap/actions/workflows/tests.yml)
(`brew style`, `brew readall --os=all --arch=all` and `brew audit` over the
whole tap) on Linux and macOS. Pushes that only change documentation do not
start a run.

## Maintaining

See [MAINTAINING.md](MAINTAINING.md) for the per-package release and bump
workflow, the Gatekeeper workarounds, and how `bin/migrate-bundle.sh` moves an
app's state when its bundle id changes.

## Sources

| Project | Latest upstream release |
| --- | --- |
| [Apex](https://github.com/sthbryan/Apex) | ![Apex](https://img.shields.io/github/v/release/sthbryan/Apex?label=%20&color=blue) |
| [Asterism](https://github.com/sthbryan/Asterism) | ![Asterism](https://img.shields.io/github/v/release/sthbryan/Asterism?label=%20&color=blue) |
| [curie](https://github.com/sthbryan/curie) | ![curie](https://img.shields.io/github/v/release/sthbryan/curie?label=%20&color=blue) |
| [fizza](https://github.com/sthbryan/fizza) | ![fizza](https://img.shields.io/github/v/release/sthbryan/fizza?label=%20&color=blue) |
| [Foundry Tunnel Manager](https://github.com/sthbryan/ftm) | ![ftm](https://img.shields.io/github/v/release/sthbryan/ftm?label=%20&color=blue) |
| [GiGi](https://github.com/Zovaris/GiGi) | ![GiGi](https://img.shields.io/github/v/release/Zovaris/GiGi?label=%20&color=blue) |
| [Pulso](https://github.com/Zovaris/Pulso) | ![Pulso](https://img.shields.io/github/v/release/Zovaris/Pulso?label=%20&color=blue) |
