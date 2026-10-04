class Tless < Formula
  desc "Terminal viewer for JSON, YAML, and TOON"
  homepage "https://github.com/commandzero/tless"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.4/tless-v0.1.4-aarch64-apple-darwin.tar.gz"
      sha256 "02b1c2fa9338c0677ab3604a5fc8432c87c3e25409b9edd9a21a70fc6322314d"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.4/tless-v0.1.4-x86_64-apple-darwin.tar.gz"
      sha256 "5a42336f56275420610d295550a5c1668e29fadeb8be4a30fd16664ed866804d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.4/tless-v0.1.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a5076e8472e2fbd938d4bb22cf550428e583a3d6112fe37b3f45597253d8aeec"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.4/tless-v0.1.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6103cd00e13f16f09004f667c2d6c40f3e3279bc109eea870d82675c80045cec"
    end
  end

  def install
    bin.install "tless"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tless --version")
  end
end
