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

  postflight do
    app_path = "#{appdir}/Apex.app"
    system_command "/usr/bin/codesign",
                   args: ["--force", "--deep", "--sign", "-", app_path]
    system_command "/usr/bin/xattr",
                   args: ["-cr", app_path]

    # Migrate user data from the old bundle id so an upgrade from v0.3.x
    # (where the id was dev.apex.desktop) keeps settings/state.
    from = "dev.apex.desktop"
    to   = "com.justcallmebryan.apex"
    home = Dir.home
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
