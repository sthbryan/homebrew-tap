class FtmCli < Formula
  desc "Share your Foundry VTT world without port forwarding (CLI + local web)"
  homepage "https://github.com/sthbryan/ftm"
  version "0.12.0"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-macos-arm64"
      sha256 "826f30b19ba01cddcee42a38c9d1e35657e45ab4f46cea91b4eb541a8ef8bf24"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-macos-x64"
      sha256 "c2577f05636c27410400a5abeb007fe0a6b1261c5f43c8fb4ea6398974cbda43"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-linux-arm64"
      sha256 "cf5e8b58b16cec183d5f6c5a7e2547f68bcedf316e0657f21b92910c3af06c3b"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-linux-x64"
      sha256 "7117cf491c793025c7d5127888139134c9fd476604f81a41b8e1eb84f9e04e3f"
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
