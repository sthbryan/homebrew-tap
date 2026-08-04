class FtmCli < Formula
  desc "Share your Foundry VTT world without port forwarding (CLI + local web)"
  homepage "https://github.com/sthbryan/ftm"
  version "0.11.0"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-macos-arm64"
      sha256 "350f1e54f9eac2d7d3a3d5c1ed5500369c399a870e22e55cfedc354544b92edf"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-macos-x64"
      sha256 "eb299d29322a9139be2beba8e7c4358aa596bbebe8c160befe7b9254bcd297c0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-linux-arm64"
      sha256 "cb496f37e93fc6dfc0038524738532f923decbf42e224dc0ee077db9708f2623"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-linux-x64"
      sha256 "25e01a2b9baf70a2cef46659000bf782cba9047e075ca43af5ab97fe227020f9"
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