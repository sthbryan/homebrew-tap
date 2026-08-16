cask "curie" do
  version "0.7.0"
  sha256 "87e3a4df1c3c6f29bfa7402233511ed2a3e80f424083013b45c19522d6a87542"

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
  end

  zap trash: [
    "~/Library/Application Support/com.curie.app",
    "~/Library/Caches/com.curie.app",
    "~/Library/Preferences/com.curie.app.plist",
    "~/Library/WebKit/com.curie.app",
  ]

  caveats <<~EOS
    Curie is not notarized yet. If macOS says the app is damaged, run:

      codesign --force --deep --sign - #{appdir}/Curie.app
      xattr -cr #{appdir}/Curie.app

    Or reinstall without Homebrew quarantine:

      HOMEBREW_CASK_OPTS="--no-quarantine" brew reinstall --cask sthbryan/tap/curie
  EOS
end
