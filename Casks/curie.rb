cask "curie" do
  version "0.8.0"
  sha256 "f66b2de0a98ccd964bdcc07dd1f5dc767b27adbfb0e8860e9152ac153561028f"

  url "https://github.com/sthbryan/curie/releases/download/v#{version}/Curie_#{version}_aarch64.dmg"
  name "Curie"
  desc "Desktop manager for AI agent skills"
  homepage "https://github.com/sthbryan/curie"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :big_sur

  app "Curie.app"

  postflight do
    app_path = "#{appdir}/Curie.app"
    system_command "/usr/bin/codesign",
                   args: ["--force", "--deep", "--sign", "-", app_path]
    system_command "/usr/bin/xattr",
                   args: ["-cr", app_path]

    # Migrate user data from the old bundle id so an upgrade from v0.7.x
    # (where the id was com.curie.app) keeps settings/state.
    from = "com.curie.app"
    to   = "com.justcallmebryan.curie"
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
    "~/Library/Application Support/com.justcallmebryan.curie",
    "~/Library/Caches/com.justcallmebryan.curie",
    "~/Library/Preferences/com.justcallmebryan.curie.plist",
    "~/Library/WebKit/com.justcallmebryan.curie",
  ]

  caveats <<~EOS
    Curie is not notarized yet. If macOS says the app is damaged, run:

      codesign --force --deep --sign - #{appdir}/Curie.app
      xattr -cr #{appdir}/Curie.app

    Or reinstall without Homebrew quarantine:

      HOMEBREW_CASK_OPTS="--no-quarantine" brew reinstall --cask sthbryan/tap/curie
  EOS
end
