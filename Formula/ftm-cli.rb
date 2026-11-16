class FtmCli < Formula
  desc "Share your Foundry VTT world without port forwarding (CLI + local web)"
  homepage "https://github.com/sthbryan/ftm"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v1.0.0/ftm-macos-arm64"
      sha256 "3bbcd3648862bbbe080e6edaf14c56978615f13460337815025fbc02b090a3f6"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v1.0.0/ftm-macos-x64"
      sha256 "f57a0e4fa5d25ad5a7358810d67dfc0adb828fb68fe6daba45087cdb3ffbb002"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v1.0.0/ftm-linux-arm64"
      sha256 "ce6db467d489e63a220d0977945865ef18fc1f300e4e2d0d78e20a37b8d74c33"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v1.0.0/ftm-linux-x64"
      sha256 "046ace4df09963dde686f638efb47acc01cb7bb435802a95bd11184622510352"
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
