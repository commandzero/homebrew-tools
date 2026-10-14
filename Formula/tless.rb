class Tless < Formula
  desc "Terminal viewer for JSON, YAML, and TOON"
  homepage "https://github.com/commandzero/tless"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.1/tless-v0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "7379e1f438049dc92f11d9907422666c4d9f785c46b6e414d35e96fa52da13ce"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.1/tless-v0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "cc5b86dcb9d84895567d2f4fcd909c86385205b22c3c7034e761b3337136e2e4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.1/tless-v0.2.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3ee0085e8dd89a90657ee463c71fbdfc6d094970bf7f996e026d5c7bd4e843dc"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.1/tless-v0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "68112740f7a8c87811132a1c496b716d4337a41526ba73e10c34114fb6dd7c55"
    end
  end

  def install
    bin.install "tless"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tless --version")
  end
end
