class FtmCli < Formula
  desc "Share your Foundry VTT world without port forwarding (CLI + local web)"
  homepage "https://github.com/sthbryan/ftm"
  version "0.13.0"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-macos-arm64"
      sha256 "88da60981f3670df4c89d7ca08fab7e70845acbbd3dbf10a434a7654bdd4a01e"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-macos-x64"
      sha256 "5ced3fdc26af200c9a7a7604ff25458334f43443d228e44bb2f4b625aa2f4480"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-linux-arm64"
      sha256 "7e464eb1e6a1b17693d41b1b077a1288fa32840d80b515770e8b7e07d4cbd265"
    end
    on_intel do
      url "https://github.com/sthbryan/ftm/releases/download/v#{version}/ftm-linux-x64"
      sha256 "758bfdaede3bd4352b47963778873106c39c27c6fd3bc2649340f5b199ff2278"
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
