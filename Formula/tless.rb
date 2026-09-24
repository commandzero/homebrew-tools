class Tless < Formula
  desc "Terminal viewer for JSON, YAML, and TOON"
  homepage "https://github.com/commandzero/tless"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.3/tless-v0.1.3-aarch64-apple-darwin.tar.gz"
      sha256 "816a3a4c9fb81ab0591286912092c896e28915ab2d612cee113c36c47885d504"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.3/tless-v0.1.3-x86_64-apple-darwin.tar.gz"
      sha256 "67899041af2d5150b7d567cca3c7cd187b175b1a9a21497568a944a1e0c37118"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.3/tless-v0.1.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "630f7e716ce359869eff29e567bf88649cfc9476f7c9034d9f804ae52e9e59c1"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.3/tless-v0.1.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d718d5fecd1c6635ab4fec7db5f60e9bad9c89c2a0ad1c5e4ae792c304da2aef"
    end
  end

  def install
    bin.install "tless"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tless --version")
  end
end
