class Vistan < Formula
  desc "Renders Markdown as a page a human reads"
  homepage "https://github.com/Zovaris/Vistan"
  version "0.1.0"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/Zovaris/Vistan/releases/download/v#{version}/vistan_#{version}_darwin_arm64.tar.gz"
      sha256 "0787aa09b3db38f874038987b3d03b00dd4641dec1c1fcb319555a448629911c"
    end
    on_intel do
      url "https://github.com/Zovaris/Vistan/releases/download/v#{version}/vistan_#{version}_darwin_amd64.tar.gz"
      sha256 "f5b89e726618e95c0be3ea44a1c353ba0c56a7b6b42bbff508339face29287a3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Zovaris/Vistan/releases/download/v#{version}/vistan_#{version}_linux_arm64.tar.gz"
      sha256 "2229c86b2ec892dcd667d9ac918d33c3f56c2ced51455e1d65c4a92606eff5d9"
    end
    on_intel do
      url "https://github.com/Zovaris/Vistan/releases/download/v#{version}/vistan_#{version}_linux_amd64.tar.gz"
      sha256 "a1f9731bb4b902fcb6a8e6a3916eb14525cb9f2d63dd823437a7a19b2a956ea1"
    end
  end

  def install
    bin.install "vistan"
  end

  test do
    assert_match "vistan #{version}", shell_output("#{bin}/vistan --version")
  end
end
