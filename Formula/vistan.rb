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
      url "https://github.com/Zovaris/Vistan/releases/download/v0.1.1/vistan_0.1.1_darwin_arm64.tar.gz"
      sha256 "a1dbb7c60cba003c15f551b13893c2492420066cc0ebeba0be490c504b886c9c"
    end
    on_intel do
      url "https://github.com/Zovaris/Vistan/releases/download/v0.1.1/vistan_0.1.1_darwin_amd64.tar.gz"
      sha256 "09eafe91d99effc41c98400777b8aeb2e2cccc72bfdfac28157b34221261be4d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Zovaris/Vistan/releases/download/v0.1.1/vistan_0.1.1_linux_arm64.tar.gz"
      sha256 "5502505958b5256ea20c0ad28fdd32646c5983cccd29b014ba792b46bc2308bb"
    end
    on_intel do
      url "https://github.com/Zovaris/Vistan/releases/download/v0.1.1/vistan_0.1.1_linux_amd64.tar.gz"
      sha256 "38db60bf2173481b6060db3bf1aa1f2541e8bb4ab4666765fdc42b5e560a22fe"
    end
  end

  def install
    bin.install "vistan"
  end

  test do
    assert_match "vistan #{version}", shell_output("#{bin}/vistan --version")
  end
end
