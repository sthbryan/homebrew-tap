cask "asterism" do
  version "1.1.0"
  sha256 "13aa1147ad16d4a3f2ef42ba927efa22208733b544a41576a56875eadf024e0a"

  url "https://github.com/sthbryan/Asterism/releases/download/v#{version}/Asterism_#{version}_aarch64.dmg"
  name "Asterism"
  desc "GitHub stats for the repos you actually track"
  homepage "https://github.com/sthbryan/Asterism"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "Asterism.app"

  postflight_steps do
    run "/usr/bin/codesign", args: ["--force", "--deep", "--sign", "-", "{{appdir}}/Asterism.app"]
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/Asterism.app"]
  end

  zap trash: [
    "~/Library/Application Support/com.sthbryan.asterism",
    "~/Library/Caches/com.sthbryan.asterism",
    "~/Library/Preferences/com.sthbryan.asterism.plist",
    "~/Library/WebKit/com.sthbryan.asterism",
  ]

  caveats <<~EOS
    Asterism is not notarized yet. The cask ad-hoc codesigns it and strips the
    quarantine attribute on install. If macOS still refuses to open it, run:

      codesign --force --deep --sign - #{appdir}/Asterism.app
      xattr -cr #{appdir}/Asterism.app
  EOS
end
