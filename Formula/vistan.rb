class Vistan < Formula
  desc "Renders Markdown as a page a human reads"
  homepage "https://github.com/Zovaris/Vistan"
  license "GPL-3.0-or-later"
  livecheck do
    url :homepage
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/Zovaris/Vistan/releases/download/v0.1.2/vistan_0.1.2_darwin_arm64.tar.gz"
      sha256 "5286860d6fd33665d4b5785b8993f8f7959d7173ce5f9ce6837b0dfe1f849b31"
    end
    on_intel do
      url "https://github.com/Zovaris/Vistan/releases/download/v0.1.2/vistan_0.1.2_darwin_amd64.tar.gz"
      sha256 "4e946d28944855003e2c56764bf8f7a98efcd98f106a42f56d4b313234c33ee7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Zovaris/Vistan/releases/download/v0.1.2/vistan_0.1.2_linux_arm64.tar.gz"
      sha256 "60a11934c80f85ec38332d0f402b7d7ed9f2c7458a0b37877ae9e01519b8d408"
    end
    on_intel do
      url "https://github.com/Zovaris/Vistan/releases/download/v0.1.2/vistan_0.1.2_linux_amd64.tar.gz"
      sha256 "4ab1734b94151e50252ef8d0d8cbc590c6f9e032e1ff4c34d6b31ffb6c82e0cc"
    end
  end

  def install
    bin.install "vistan"
  end

  test do
    assert_match "vistan #{version}", shell_output("#{bin}/vistan --version")
  end
end
