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

    # Migrate user data from the old bundle id so an upgrade from v0.15.x
    # (where the id was sthbryan.ftm) keeps connections/state.
    from = "sthbryan.ftm"
    to   = "com.justcallmebryan.ftm"
    home = ENV.fetch("HOME")
    [
      ["Application Support", false],
      ["Caches",              false],
      ["Preferences",         true],
      ["WebKit",              false],
    ].each do |sub, plist|
      src = File.join(home, "Library", sub, plist ? "#{from}.plist" : from)
      next unless File.exist?(src)
      dst = src.sub(from, to)
      if File.exist?(dst)
        puts "  [skip] #{sub}: destination already exists"
      else
        puts "  [move] #{sub}: #{File.basename(src)} -> #{File.basename(dst)}"
        File.rename(src, dst)
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
