class Tq < Formula
  desc "Run jq-style queries over TOON, YAML, JSON, CSV, and TSV"
  homepage "https://github.com/commandzero/tq"
  url "https://github.com/commandzero/tq/archive/refs/tags/v0.3.0.tar.gz"
  version "0.3.0"
  sha256 "15e30c5d3cf3550b5f207be122efb02d7bbc4a03c7b715b49b15c36791c0bed5"
  license "MIT"

  bottle do
    root_url "https://github.com/commandzero/homebrew-tools/releases/download/bottles"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "0a4eff3fe8a68df0bee85d537109fa82d0a865d08b45c61f92c549d1f8cae432"
    sha256 cellar: :any,                 arm64_linux:  "81ab5f9292d7f8f2940b50c894c2353582d61a7d637f64cded5218b3eafffc67"
    sha256 cellar: :any,                 x86_64_linux: "775f4df3893720338611799170298898a3e5b4b9667c375ea4c116a6cf986e0e"
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
