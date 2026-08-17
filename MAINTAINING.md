# Maintaining this tap

This repo only holds package definitions. Binaries are published to the GitHub Releases page of each project; this tap is updated by bumping the `version` and `sha256` fields.

## Releasing and updating packages

### Apex (cask)

Each release publishes a DMG. Update `Casks/apex.rb`:

1. Upload `Apex_<version>_aarch64.dmg` to the GitHub Release.
2. `shasum -a 256 Apex_<version>_aarch64.dmg`
3. Bump `version` and `sha256` in `Casks/apex.rb`.
4. Commit and push this tap.

### Curie (cask)

Each release publishes a DMG. Update `Casks/curie.rb`:

1. Upload `Curie_<version>_aarch64.dmg` to the GitHub Release.
2. `shasum -a 256 Curie_<version>_aarch64.dmg`
3. Bump `version` and `sha256` in `Casks/curie.rb`.
4. Commit and push this tap.

### Fizza (formula)

Each release publishes platform tarballs. Update `Formula/fizza.rb`:

1. Publish `fizza_<version>_{darwin,linux}_{arm64,amd64}.tar.gz`.
2. Copy hashes from `fizza_<version>_checksums.txt` (or `shasum -a 256`).
3. Bump `version` and every platform `sha256` in `Formula/fizza.rb`.
4. Commit and push this tap.

### ftm (formula)

Each release publishes raw platform binaries (no tarball wrapper). Update `Formula/ftm-cli.rb`:

1. Publish `ftm-{linux-x64,linux-arm64,macos-x64,macos-arm64,windows-x64.exe}`.
2. `shasum -a 256` each one.
3. Bump `version` and every platform `sha256` in `Formula/ftm-cli.rb`.
4. Commit and push this tap.

The `bin.install "..." => "ftm"` rename keeps the installed binary name stable regardless of platform.

### ftm (cask)

The macOS desktop pipeline zips the Wails `.app` as `ftm-desktop-macos.app.zip`. Update `Casks/ftm.rb`:

1. Publish `ftm-desktop-macos.app.zip` (the `package-macos-app.sh` script in the ftm repo does this automatically during release).
2. `shasum -a 256 ftm-desktop-macos.app.zip`
3. Bump `version` and `sha256` in `Casks/ftm.rb`.
4. Commit and push this tap.

Until those fields change, `brew upgrade` will not install the new build.

## Gatekeeper on macOS

None of the packages are notarized. The tap ad-hoc codesigns and strips quarantine xattrs on install. If macOS still blocks them:

```bash
# Apex
codesign --force --deep --sign - /Applications/Apex.app
xattr -cr /Applications/Apex.app

# Curie
codesign --force --deep --sign - /Applications/Curie.app
xattr -cr /Applications/Curie.app

# Fizza (Homebrew)
codesign --force --sign - "$(brew --prefix)/opt/fizza/bin/fizza"
xattr -cr "$(brew --prefix)/opt/fizza/bin/fizza"

# ftm desktop (Homebrew cask)
codesign --force --deep --sign - /Applications/Foundry\ Tunnel\ Manager.app
xattr -cr /Applications/Foundry\ Tunnel\ Manager.app

# ftm CLI (Homebrew)
codesign --force --sign - "$(brew --prefix)/opt/ftm-cli/bin/ftm"
xattr -cr "$(brew --prefix)/opt/ftm-cli/bin/ftm"

# or reinstall any of the casks without quarantine
HOMEBREW_CASK_OPTS="--no-quarantine" brew reinstall --cask sthbryan/tap/<name>
```
