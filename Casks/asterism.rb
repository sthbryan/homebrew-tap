cask "asterism" do
  version "0.2.0"
  sha256 "23c351d3f41036cadd28496b687a4ba6354c71096f885174027b8f6f7a2cb4cc"

  url "https://github.com/sthbryan/Asterism/releases/download/v#{version}/Asterism_#{version}_aarch64.dmg"
  name "Asterism"
  desc "GitHub stats for the repos you actually track"
  homepage "https://github.com/sthbryan/Asterism"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :big_sur

  app "Asterism.app"

  postflight do
    app_path = "#{appdir}/Asterism.app"
    system_command "/usr/bin/codesign",
                   args: ["--force", "--deep", "--sign", "-", app_path]
    system_command "/usr/bin/xattr",
                   args: ["-cr", app_path]
  end

  zap trash: [
    "~/Library/Application Support/com.sthbryan.asterism",
    "~/Library/Caches/com.sthbryan.asterism",
    "~/Library/Preferences/com.sthbryan.asterism.plist",
    "~/Library/WebKit/com.sthbryan.asterism",
  ]

  caveats <<~EOS
    Asterism is not notarized yet. If macOS says the app is damaged, run:

      codesign --force --deep --sign - #{appdir}/Asterism.app
      xattr -cr #{appdir}/Asterism.app

    Or reinstall without Homebrew quarantine:

      HOMEBREW_CASK_OPTS="--no-quarantine" brew reinstall --cask sthbryan/tap/asterism
  EOS
end
