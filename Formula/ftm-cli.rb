class FtmCli < Formula
  desc "Share your Foundry VTT world without port forwarding (CLI + local web)"
  homepage "https://github.com/sthbryan/ftm"
  version "0.16.0"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-macos-arm64"
      sha256 "86b4ddc68ac6d21d3ffabf4d47dcd045f6b9f0212650d92b2383113d12e60f98"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-macos-x64"
      sha256 "1d972e61e1db6f94345afc035175b6546e739708dfb7442a120cb299d3efeae5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-linux-arm64"
      sha256 "10ca1aae97cb07672816648a210e3863d1c2bf6f42b5b3cca952dc0db558004b"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-linux-x64"
      sha256 "27b3bed2ea341ae8c30f4fd7f8d26f88938c1aabacb46c79019c20bd4ccd9c16"
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
