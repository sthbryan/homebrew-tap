cask "gigi" do
  version "0.4.3"
  sha256 "fc081e3db14c8f4ef2d506e5e1254fc50a306c1ddbe7c98477a51950bf4fad8c"

  url "https://github.com/Zovaris/GiGi/releases/download/v#{version}/GiGi-#{version}-macos-arm64.zip"
  name "GiGi"
  desc "Keep the display awake with scheduled cursor movements"
  homepage "https://github.com/Zovaris/GiGi"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The release pipeline only ships an arm64 zip.
  depends_on arch: :arm64
  depends_on macos: :ventura

  app "GiGi-#{version}-macos-arm64/GiGi.app"
  binary "GiGi-#{version}-macos-arm64/gigi"

  # The bundle is already ad-hoc signed by the build, but Homebrew quarantines every download and
  # this app is not notarized: without this, Gatekeeper refuses the app and kills the CLI.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/GiGi.app"]
    run "/usr/bin/xattr", args: ["-cr", "{{staged_path}}/GiGi-{{version}}-macos-arm64/gigi"]
  end

  zap trash: [
    "~/.config/gigi",
    "~/Library/Logs/GiGi",
    "~/Library/Preferences/com.justcallmebryan.gigi.plist",
  ]

  caveats <<~EOS
    GiGi moves the cursor, so macOS asks for Accessibility permission once:
      System Settings > Privacy & Security > Accessibility > enable GiGi

    Without it the display still stays awake, but the cursor never moves.
    The companion CLI is on your PATH as `gigi` (status, start, stop, jiggle).
    Configuration: ~/.config/gigi/config.json   Logs: ~/Library/Logs/GiGi
  EOS
end
