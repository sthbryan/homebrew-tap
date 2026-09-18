cask "pulso" do
  version "0.2.1"
  sha256 "b4cdc6e0bfc6126017af5445becda99714c3a6c83e2609e118e7649b202bfbb2"

  url "https://github.com/Zovaris/Pulso/releases/download/v#{version}/Pulso_#{version}_aarch64.dmg"
  name "Pulso"
  desc "Project commands, from the menu bar"
  homepage "https://github.com/Zovaris/Pulso"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The release pipeline only ships an arm64 DMG.
  depends_on arch: :arm64
  depends_on :macos

  app "Pulso.app"

  postflight_steps do
    run "/usr/bin/codesign", args: ["--force", "--deep", "--sign", "-", "{{appdir}}/Pulso.app"]
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/Pulso.app"]
  end

  zap trash: [
    "~/Library/Application Support/com.justcallmebryan.pulso",
    "~/Library/Caches/com.justcallmebryan.pulso",
    "~/Library/Preferences/com.justcallmebryan.pulso.plist",
    "~/Library/WebKit/com.justcallmebryan.pulso",
  ]

  caveats <<~EOS
    Pulso is not notarized yet. The cask ad-hoc codesigns it and strips the
    quarantine attribute on install. If macOS still refuses to open it, run:

      codesign --force --deep --sign - #{appdir}/Pulso.app
      xattr -cr #{appdir}/Pulso.app
  EOS
end
