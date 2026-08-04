cask "ftm" do
  version "0.11.0"
  sha256 "48305000149ca6de6a541756421d30b91ca99d9b7eef8036fe3bf352e89152d5"

  url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-desktop-macos.app.zip"
  name "Foundry Tunnel Manager"
  desc "Share your Foundry VTT world without port forwarding (desktop shell)"
  homepage "https://github.com/sthbryan/ftm"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The release.yml pipeline only builds the macOS .app for arm64 today
  # (WebKit native + universal binary are heavier and untested).
  depends_on arch: :arm64
  depends_on macos: :catalina

  # The zip ships the .app under the asset-friendly slug ftm-desktop-macos.app,
  # but the visible bundle name (CFBundleDisplayName inside) is "Foundry Tunnel
  # Manager". Rename on install so /Applications shows the friendly name
  # instead of the slug.
  app "ftm-desktop-macos.app", target: "Foundry Tunnel Manager.app"

  # Unsigned GitHub-release builds trip Gatekeeper ("damaged and can't be
  # opened"). Ad-hoc sign and strip xattrs so first launch works after
  # `brew install --cask`, matching what we do for curie.
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