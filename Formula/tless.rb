class Tless < Formula
  desc "Terminal viewer for JSON, YAML, and TOON"
  homepage "https://github.com/commandzero/tless"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.0/tless-v0.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "79cd3115d3a6b1307797c91b6e03c2f68e260d0ea478fd5ca737c7be3757590f"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.0/tless-v0.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "ca0d1d33a2a4a428b46f040c115a0b8d3b552d92fccb73155d53ee5bed35f8e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.0/tless-v0.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ef6082f238a08aa53473e257e68c9eda6ca58fa7ca12ac24e6676eaeb4c79f5d"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.0/tless-v0.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "23261626775528eb423d53d6714a9be91c3742f035ba1a1c420be6bef8fb93a3"
    end
  end

  def install
    bin.install "tless"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tless --version")
  end
end
