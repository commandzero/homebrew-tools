class Tless < Formula
  desc "Terminal viewer for JSON, YAML, and TOON"
  homepage "https://github.com/commandzero/tless"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.1/tless-v0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "f0b8cb22a6398b909d41c39d217af9ddd4d67289447c5709030133476722ad44"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.1/tless-v0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "8a7617cc2e0b6dcd868b277089b731d7cefcb4a62fc0ddff7d7887108edf7043"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.1/tless-v0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "492405e4d8eff4f4e37ce2c21f6ffa4e0c9265f8e9c28d5c857e9932b769ddea"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.1/tless-v0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "968362e3b017c7165410f84b2dad9715677cb94a49e670997cde29852875ff50"
    end
  end

  def install
    bin.install "tless"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tless --version")
  end
end
