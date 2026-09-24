class Tview < Formula
  desc "Terminal viewer for CSV, JSON, and SQLite data"
  homepage "https://github.com/commandzero/tview"
  url "https://github.com/commandzero/tview/releases/download/v0.1.0/tview-v0.1.0-aarch64-apple-darwin.tar.gz"
  sha256 "21203c803d50596b169b3e3362cfad8e2d218da610261a9adb01393905394387"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :sonoma
  end

  on_linux do
    on_arm do
      url "https://github.com/commandzero/tview/releases/download/v0.1.0/tview-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "287948ecded1e9cb2970cf1f74e2515a50290bd6caf08e749c76e5ac615e943b"
    end
    on_intel do
      url "https://github.com/commandzero/tview/releases/download/v0.1.0/tview-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "412509117a38d1b28f159640bfcfa2d4092c517b2de2bfdd0dfcca9339b97ed1"
    end
  end

  def install
    bin.install "tview"
    pkgshare.install "LICENSE.txt", "BUILD-INFO.txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tview --version")
    output = pipe_output("#{bin}/tview --no-view --output json -", "name,value\nrelease,42\n", 0)
    assert_equal({ "columns" => %w[name value], "rows" => [["release", "42"]] }, JSON.parse(output))
  end
end
