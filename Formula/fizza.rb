class Fizza < Formula
  desc "Local kanban board for humans and coding agents"
  homepage "https://github.com/sthbryan/fizza"
  version "1.0.0"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/sthbryan/fizza/releases/download/v#{version}/fizza_#{version}_darwin_arm64.tar.gz"
      sha256 "40f048fb4bc780ccc9344aecd1c7f07ce10ce3b8565369451ab8b7f851035dde"
    end
    on_intel do
      url "https://github.com/sthbryan/fizza/releases/download/v#{version}/fizza_#{version}_darwin_amd64.tar.gz"
      sha256 "a5b6381d2b56a8f6a2305d6b3e3ba5c861bbacddc0481f45d1b9fd73f3a37ab4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sthbryan/fizza/releases/download/v#{version}/fizza_#{version}_linux_arm64.tar.gz"
      sha256 "6f5ec76a4615e3e419fa3751f831b66c85d7a600a47352f1965ec45a1016e4ba"
    end
    on_intel do
      url "https://github.com/sthbryan/fizza/releases/download/v#{version}/fizza_#{version}_linux_amd64.tar.gz"
      sha256 "f12b23ef9a1d155ff6b0c329e95ec30f2d747b803af82012e8a3f3203f0d69ba"
    end
  end

  def install
    bin.install "fizza"

    # Unsigned GitHub release builds trip Gatekeeper ("damaged" / blocked).
    # Ad-hoc sign and strip quarantine so the CLI runs after brew install.
    return unless OS.mac?

    system "codesign", "--force", "--sign", "-", bin/"fizza"
    system "xattr", "-cr", bin/"fizza"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fizza --version")
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      Fizza is not notarized. If macOS blocks the binary, run:

        codesign --force --sign - #{opt_bin}/fizza
        xattr -cr #{opt_bin}/fizza
    EOS
  end
end
