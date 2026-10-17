class Tq < Formula
  desc "Run jq-style queries over TOON, YAML, JSON, CSV, and TSV"
  homepage "https://github.com/commandzero/tq"
  url "https://github.com/commandzero/tq/archive/refs/tags/v0.5.0.tar.gz"
  version "0.5.0"
  sha256 "58c8b8a37229121011c0a64c3fd89b0cdb07993846f68e6613178df4a44bb9ed"
  license "MIT"

  bottle do
    root_url "https://github.com/commandzero/homebrew-tools/releases/download/bottles"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11863205ffc7777d5dea7a10c9ec2dcd972b621136a9dbe83629b3cb412a4812"
    sha256 cellar: :any,                 arm64_linux:   "d863b3a4ca5c9783b251fe87a427aad33f8ffca9ccff28310f7c061b87829ea0"
    sha256 cellar: :any,                 x86_64_linux:  "eea3927c42bdddbcef0be1f238d812d762f2cf175be2c42afdad7babd52c43af"
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
