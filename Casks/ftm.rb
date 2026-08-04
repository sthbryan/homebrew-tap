cask "ftm" do
  version "0.12.0"
  sha256 "cc68ad696aaf67dc7d8070598b564ca1707b4c62d55af772d9598accb15283c8"

  url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-desktop-macos.app.zip"
  name "Foundry Tunnel Manager"
  desc "Share your Foundry VTT world without port forwarding (desktop shell)"
  homepage "https://github.com/sthbryan/ftm"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The release pipeline only builds the macOS .app for arm64 (WebKit native
  # and universal binaries are heavier and untested).
  depends_on arch: :arm64
  depends_on macos: :catalina

  # The outer zip keeps the asset-friendly slug for URL stability, but since
  # v0.12.0 the bundle inside it is already named "Foundry Tunnel Manager.app".
  app "Foundry Tunnel Manager.app"

  postflight do
    app_path = "#{appdir}/Foundry Tunnel Manager.app"
    system_command "/usr/bin/codesign",
                   args: ["--force", "--deep", "--sign", "-", app_path]
    system_command "/usr/bin/xattr",
                   args: ["-cr", app_path]
  end

  zap trash: [
    "~/Library/Application Support/sthbryan.ftm",
    "~/Library/Caches/sthbryan.ftm",
    "~/Library/Preferences/sthbryan.ftm.plist",
    "~/Library/WebKit/sthbryan.ftm",
  ]

  caveats <<~EOS
    ftm is not notarized yet. If macOS says the app is damaged, run:

      codesign --force --deep --sign - "#{appdir}/Foundry Tunnel Manager.app"
      xattr -cr "#{appdir}/Foundry Tunnel Manager.app"

    Or reinstall without Homebrew quarantine:

      HOMEBREW_CASK_OPTS="--no-quarantine" brew reinstall --cask sthbryan/tap/ftm
  EOS
end
