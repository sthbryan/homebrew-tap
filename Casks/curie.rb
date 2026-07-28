cask "curie" do
  version "0.4.1"
  sha256 "599fbeaf525611b203be7a3ab2efbc654548ca8b8dad9994cd37f074091948f9"

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

  # Unsigned builds trip Gatekeeper ("Curie is damaged and can't be opened").
  # Ad-hoc sign + strip all xattrs so first launch works after brew install.
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
