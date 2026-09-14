class Tless < Formula
  desc "Terminal viewer for JSON, YAML, and TOON"
  homepage "https://github.com/commandzero/tless"
  version "0.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.2/tless-v0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "20d16b127014ed6889f22a38855fd6b4765cf845d6b735c96ec3e00082e6d11d"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.2/tless-v0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "eb819355d55edd57f133b50f05496c400eaaebf45c2ce963bb3275d2a9e90942"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.2/tless-v0.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e9cc942a18b2100fc6c9504179987be7f330b686313dd9e9ecdf44680dcc33ca"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.2/tless-v0.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3353cf76aa2564fa1216c6b2156910cd45203c5cfa6744c6429937728ded3019"
    end
  end

  def install
    bin.install "tless"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tless --version")
  end
end
