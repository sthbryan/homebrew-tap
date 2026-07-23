cask "curie" do
  version "0.1.0"
  sha256 "64cddf28fa5282357137513410212e1493b66aa7b9a43bb7d432182f0dc58577"

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

  # Unsigned release builds trip Gatekeeper ("damaged and can't be opened").
  # Strip quarantine after install so first launch works without manual xattr.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Curie.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Application Support/com.curie.app",
    "~/Library/Caches/com.curie.app",
    "~/Library/Preferences/com.curie.app.plist",
    "~/Library/WebKit/com.curie.app",
  ]

  caveats <<~EOS
    Curie is not notarized yet. If macOS says the app is damaged, run:

      xattr -dr com.apple.quarantine #{appdir}/Curie.app

    Or reinstall without quarantine:

      brew reinstall --cask --no-quarantine sthbryan/tap/curie
  EOS
end
