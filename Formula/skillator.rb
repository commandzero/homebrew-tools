class Skillator < Formula
  desc "Terminal UI and CLI for managing agent skills across Git repositories"
  homepage "https://github.com/commandzero/skillator"
  url "https://github.com/commandzero/skillator/releases/download/v0.1.0/skillator-v0.1.0-aarch64-apple-darwin.tar.gz"
  sha256 "16494d9b383f531a389601af3a0661b7396f809d28b2fe06738bbd5f365c0267"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    on_arm do
      url "https://github.com/commandzero/skillator/releases/download/v0.1.0/skillator-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ac08d1b41b83805b9ec6f82e84b9cfdecf0653deb3e661b778a83c02b24c6b7a"
    end
    on_intel do
      url "https://github.com/commandzero/skillator/releases/download/v0.1.0/skillator-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "83b125e322a6edf0a14580e4f88dbc3eaef00247ddb018184f8bf686efcdf2be"
    end
  end

  def install
    bin.install Dir["skillator-v#{version}-*"].fetch(0) => "skillator"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillator --version")
    (testpath/"library/example/SKILL.md").write <<~EOS
      ---
      name: example
      description: Example skill for the Homebrew test
      ---
      Follow the example instructions.
    EOS
    system bin/"skillator", "library", "add", testpath/"library"
    assert_match "example", shell_output("#{bin}/skillator library list")
  end
end
