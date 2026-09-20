cask "ftm" do
  version "0.16.0"
  sha256 "e11756af3ae576b9157f25f7250cd0bc6e27995e53bad6f9aece1a9a7c4ef105"

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
  depends_on :macos

  # The outer zip keeps the asset-friendly slug for URL stability, but since
  # v0.12.0 the bundle inside it is already named "Foundry Tunnel Manager.app".
  app "Foundry Tunnel Manager.app"

  postflight_steps do
    run "/usr/bin/codesign", args: ["--force", "--deep", "--sign", "-", "{{appdir}}/Foundry Tunnel Manager.app"]
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/Foundry Tunnel Manager.app"]

    # v0.15.x shipped as sthbryan.ftm: carry its state over so an upgrade keeps
    # connections. A destination that already exists is left untouched.
    if_path_exists "~/Library/Application Support/sthbryan.ftm" do
      unless_path_exists "~/Library/Application Support/com.justcallmebryan.ftm" do
        move "~/Library/Application Support/sthbryan.ftm",
             "~/Library/Application Support/com.justcallmebryan.ftm"
      end
    end
    if_path_exists "~/Library/Caches/sthbryan.ftm" do
      unless_path_exists "~/Library/Caches/com.justcallmebryan.ftm" do
        move "~/Library/Caches/sthbryan.ftm", "~/Library/Caches/com.justcallmebryan.ftm"
      end
    end
    if_path_exists "~/Library/Preferences/sthbryan.ftm.plist" do
      unless_path_exists "~/Library/Preferences/com.justcallmebryan.ftm.plist" do
        move "~/Library/Preferences/sthbryan.ftm.plist",
             "~/Library/Preferences/com.justcallmebryan.ftm.plist"
      end
    end
    if_path_exists "~/Library/WebKit/sthbryan.ftm" do
      unless_path_exists "~/Library/WebKit/com.justcallmebryan.ftm" do
        move "~/Library/WebKit/sthbryan.ftm", "~/Library/WebKit/com.justcallmebryan.ftm"
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/com.justcallmebryan.ftm",
    "~/Library/Caches/com.justcallmebryan.ftm",
    "~/Library/Preferences/com.justcallmebryan.ftm.plist",
    "~/Library/WebKit/com.justcallmebryan.ftm",
  ]

  caveats <<~EOS
    ftm is not notarized yet. If macOS says the app is damaged, run:

      codesign --force --deep --sign - "#{appdir}/Foundry Tunnel Manager.app"
      xattr -cr "#{appdir}/Foundry Tunnel Manager.app"

    Or reinstall without Homebrew quarantine:

      HOMEBREW_CASK_OPTS="--no-quarantine" brew reinstall --cask sthbryan/tap/ftm
  EOS
end
