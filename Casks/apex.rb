cask "apex" do
  version "0.3.0"
  sha256 "04a31f9c8b834b7d4418dd7f3927ccb6b63affca94d4bb35c2eb277fb9b2df0f"

  url "https://github.com/sthbryan/Apex/releases/download/v#{version}/Apex_#{version}_aarch64.dmg"
  name "Apex"
  desc "AI Agent Desktop Hub for Claude Code, Codex, Gemini, and any CLI"
  homepage "https://github.com/sthbryan/Apex"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Release pipeline only ships an arm64 DMG; the Linux .deb / .rpm / .AppImage
  # targets are not packaged here.
  depends_on arch: :arm64
  depends_on macos: :high_sierra

  app "Apex.app"

  postflight do
    app_path = "#{appdir}/Apex.app"
    system_command "/usr/bin/codesign",
                   args: ["--force", "--deep", "--sign", "-", app_path]
    system_command "/usr/bin/xattr",
                   args: ["-cr", app_path]
  end

  zap trash: [
    "~/Library/Application Support/dev.apex.desktop",
    "~/Library/Caches/dev.apex.desktop",
    "~/Library/Preferences/dev.apex.desktop.plist",
    "~/Library/WebKit/dev.apex.desktop",
  ]

  caveats <<~EOS
    Apex is not notarized yet. If macOS says the app is damaged, run:

      codesign --force --deep --sign - #{appdir}/Apex.app
      xattr -cr #{appdir}/Apex.app

    Or reinstall without Homebrew quarantine:

      HOMEBREW_CASK_OPTS="--no-quarantine" brew reinstall --cask sthbryan/tap/apex
  EOS
end
