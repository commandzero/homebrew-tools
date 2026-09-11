class Tless < Formula
  desc "Terminal viewer for JSON, YAML, and TOON"
  homepage "https://github.com/commandzero/tless"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.0/tless-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "f8f2e4c430e53149ca45e2492072d244bf900fcbff71389fab8ac1eb19f1bbfc"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.0/tless-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "9dc9b1f90f73dde1f9a457ee796e2863a4d8af5dcba5b4ad497acefb6ff656d0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.0/tless-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f2f9d277f27719f6718de31244c97497a583a98a1a7b2101066fe0fc25c02b43"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.1.0/tless-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eee8695ba1d068a58cc08ae2c4f53fe9bb6848374d7582218b71cd20fc21a1b3"
    end
  end

  def install
    bin.install "tless"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tless --version")
  end
end
