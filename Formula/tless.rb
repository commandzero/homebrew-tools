class Tless < Formula
  desc "Terminal viewer for JSON, YAML, and TOON"
  homepage "https://github.com/commandzero/tless"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.2/tless-v0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "88c5f18cca6d169aaddbc1d81af43487304122b0f4a1b9bcec8a18a11541ef1e"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.2/tless-v0.2.2-x86_64-apple-darwin.tar.gz"
      sha256 "b6e7814525f9b1a00e0a9afed8dfd1ddcc72dd6b4afa453534e42a1176f830d4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.2/tless-v0.2.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "87cadad131f0b6ffda7e2689bfb2adaa5b7d93b45cc2512c92b471022ecc2a7d"
    end
    on_intel do
      url "https://github.com/CommandZero/tless/releases/download/v0.2.2/tless-v0.2.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d61ff0034d50f137e1615e32f82fa92e9a6f299bdb1b7130b61cedf4816c24ac"
    end
  end

  def install
    bin.install "tless"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tless --version")
    input = '{"release":true}'
    json = pipe_output("#{bin}/tless --input-format json --output-format json -", input, 0)
    assert_equal({ "release" => true }, JSON.parse(json))
    assert_equal "release: true", pipe_output("#{bin}/tless --input-format json -", input, 0).strip
  end
end
