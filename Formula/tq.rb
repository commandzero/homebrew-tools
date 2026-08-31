class Tq < Formula
  desc "Run jq-style queries over TOON, YAML, JSON, and JSON Lines"
  homepage "https://github.com/commandzero/tq"
  url "https://github.com/commandzero/tq/archive/refs/tags/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "c64279cbd18e3e96ea6c22dbb8195949c901536622264cf3b989db1a2e2719a1"
  license "MIT"

  bottle do
    root_url "https://github.com/commandzero/homebrew-tools/releases/download/bottles"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "0f36e9e9994947184ef40a061f5585880308bee7ed89522979306b9a7c4cf6fc"
    sha256 cellar: :any,                 arm64_linux:  "5bd0652d7908d3f3828a2666261101cbd2414a136657b338ca51d1f0ba265374"
    sha256 cellar: :any,                 x86_64_linux: "2e2b5d1401bd6fa51970ec028671a03b1c13b929b77c42848f7b33e49bbd795a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tq-cli")
  end

  test do
    output = pipe_output(
      "#{bin}/tq --input-format json --output-format json --compact-output '.answer'",
      "{\"answer\":42}\n",
    )
    assert_equal "42\n", output
  end
end
