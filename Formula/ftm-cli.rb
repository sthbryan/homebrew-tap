class FtmCli < Formula
  desc "Share your Foundry VTT world without port forwarding (CLI + local web)"
  homepage "https://github.com/sthbryan/ftm"
  version "0.15.0"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-macos-arm64"
      sha256 "2ed98e593488bdf37d11041f2b9df3831750eb53bc74bc797d9f5c0708b6ca21"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-macos-x64"
      sha256 "4f6a40cb6e90d8f52ded73389a26749322a092b24c89ae4338d22b1853f0b584"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-linux-arm64"
      sha256 "a5f67c3aa62d9b8f9e83a173fd04844f57768fa1ff5c3d8b0aefe2580c847e34"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-linux-x64"
      sha256 "13ef0345852a21d15352c0dd385f33c186356857c6ab27518774a85d278d0b12"
    end
  end

  def install
    # Release pipeline publishes raw binaries (no tarball wrapper); install
    # under the canonical `ftm` name regardless of the URL suffix.
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ftm-macos-arm64" => "ftm"
    elsif OS.mac?
      bin.install "ftm-macos-x64" => "ftm"
    elsif Hardware::CPU.arm?
      bin.install "ftm-linux-arm64" => "ftm"
    else
      bin.install "ftm-linux-x64" => "ftm"
    end

    return unless OS.mac?

    system "codesign", "--force", "--sign", "-", bin/"ftm"
    system "xattr", "-cr", bin/"ftm"
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      ftm is not notarized. If macOS blocks the binary, run:

        codesign --force --sign - #{opt_bin}/ftm
        xattr -cr #{opt_bin}/ftm
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ftm --version")
  end
end
