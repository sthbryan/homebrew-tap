cask "apex" do
  version "0.9.1"
  sha256 "520d4ba2baec2b8c7a72dce733dbb4f0e8ca125eb1d2e4e4f4b3bb17e8952e83"

  url "https://github.com/sthbryan/Apex/releases/download/v#{version}/Apex_#{version}_aarch64.dmg"
  name "Apex"
  desc "AI Agent Desktop Hub for Claude Code, Codex, Gemini, and any CLI"
  homepage "https://github.com/sthbryan/Apex"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Since v0.8.0 Apex updates itself from GitHub releases, so `brew upgrade`
  # only touches it with --greedy.
  auto_updates true
  # Release pipeline only ships an arm64 DMG; the Linux .deb / .rpm / .AppImage
  # targets are not packaged here.
  depends_on arch: :arm64
  depends_on :macos

  app "Apex.app"

  postflight_steps do
    run "/usr/bin/codesign", args: ["--force", "--deep", "--sign", "-", "{{appdir}}/Apex.app"]
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/Apex.app"]

    # v0.3.x shipped as dev.apex.desktop: carry its state over so an upgrade
    # keeps settings. A destination that already exists is left untouched.
    if_path_exists "~/Library/Application Support/dev.apex.desktop" do
      unless_path_exists "~/Library/Application Support/com.justcallmebryan.apex" do
        move "~/Library/Application Support/dev.apex.desktop",
             "~/Library/Application Support/com.justcallmebryan.apex"
      end
    end
    if_path_exists "~/Library/Caches/dev.apex.desktop" do
      unless_path_exists "~/Library/Caches/com.justcallmebryan.apex" do
        move "~/Library/Caches/dev.apex.desktop", "~/Library/Caches/com.justcallmebryan.apex"
      end
    end
    if_path_exists "~/Library/Preferences/dev.apex.desktop.plist" do
      unless_path_exists "~/Library/Preferences/com.justcallmebryan.apex.plist" do
        move "~/Library/Preferences/dev.apex.desktop.plist",
             "~/Library/Preferences/com.justcallmebryan.apex.plist"
      end
    end
    if_path_exists "~/Library/WebKit/dev.apex.desktop" do
      unless_path_exists "~/Library/WebKit/com.justcallmebryan.apex" do
        move "~/Library/WebKit/dev.apex.desktop", "~/Library/WebKit/com.justcallmebryan.apex"
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/com.justcallmebryan.apex",
    "~/Library/Caches/com.justcallmebryan.apex",
    "~/Library/Preferences/com.justcallmebryan.apex.plist",
    "~/Library/WebKit/com.justcallmebryan.apex",
  ]

  caveats <<~EOS
    Apex is not notarized yet. If macOS says the app is damaged, run:

      codesign --force --deep --sign - #{appdir}/Apex.app
      xattr -cr #{appdir}/Apex.app

    Or reinstall without Homebrew quarantine:

      HOMEBREW_CASK_OPTS="--no-quarantine" brew reinstall --cask sthbryan/tap/apex
  EOS
end
