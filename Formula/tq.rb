class Tq < Formula
  desc "Run jq-style queries over TOON, YAML, JSON, CSV, and TSV"
  homepage "https://github.com/commandzero/tq"
  url "https://github.com/commandzero/tq/archive/refs/tags/v0.5.0.tar.gz"
  version "0.5.0"
  sha256 "58c8b8a37229121011c0a64c3fd89b0cdb07993846f68e6613178df4a44bb9ed"
  license "MIT"

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
