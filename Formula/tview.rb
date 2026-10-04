class Tview < Formula
  desc "Terminal viewer for CSV, JSON, and SQLite data"
  homepage "https://github.com/commandzero/tview"
  url "https://github.com/commandzero/tview/releases/download/v0.1.1/tview-v0.1.1-aarch64-apple-darwin.tar.gz"
  sha256 "08fd1048143470f70d228a6d3109ca27c4d6877046f672fe319d1b7ff7546b63"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :sonoma
  end

  on_linux do
    on_arm do
      url "https://github.com/commandzero/tview/releases/download/v0.1.1/tview-v0.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "80af8d6eaeac220e81f90f90a7ff92c639e233ffc04abea18f5859c5055c3bee"
    end
    on_intel do
      url "https://github.com/commandzero/tview/releases/download/v0.1.1/tview-v0.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4fcdae51fc0864191707c6d816337f6f628b278408b6429ee0d2dbbb1959dbfb"
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
