class Tq < Formula
  desc "Run jq-style queries over TOON, YAML, JSON, and JSON Lines"
  homepage "https://github.com/commandzero/tq"
  license "MIT"
  head "https://github.com/commandzero/tq.git", branch: "main"

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
