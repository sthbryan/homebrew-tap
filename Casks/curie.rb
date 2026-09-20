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
  depends_on :macos

  app "Curie.app"

  postflight_steps do
    run "/usr/bin/codesign", args: ["--force", "--deep", "--sign", "-", "{{appdir}}/Curie.app"]
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/Curie.app"]

    # v0.7.x shipped as com.curie.app: carry its state over so an upgrade keeps
    # settings. A destination that already exists is left untouched.
    if_path_exists "~/Library/Application Support/com.curie.app" do
      unless_path_exists "~/Library/Application Support/com.justcallmebryan.curie" do
        move "~/Library/Application Support/com.curie.app",
             "~/Library/Application Support/com.justcallmebryan.curie"
      end
    end
    if_path_exists "~/Library/Caches/com.curie.app" do
      unless_path_exists "~/Library/Caches/com.justcallmebryan.curie" do
        move "~/Library/Caches/com.curie.app", "~/Library/Caches/com.justcallmebryan.curie"
      end
    end
    if_path_exists "~/Library/Preferences/com.curie.app.plist" do
      unless_path_exists "~/Library/Preferences/com.justcallmebryan.curie.plist" do
        move "~/Library/Preferences/com.curie.app.plist",
             "~/Library/Preferences/com.justcallmebryan.curie.plist"
      end
    end
    if_path_exists "~/Library/WebKit/com.curie.app" do
      unless_path_exists "~/Library/WebKit/com.justcallmebryan.curie" do
        move "~/Library/WebKit/com.curie.app", "~/Library/WebKit/com.justcallmebryan.curie"
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
