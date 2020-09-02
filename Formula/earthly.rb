class Earthly < Formula
  desc "Build automation tool for the post-container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly/archive/v0.3.3.tar.gz"
  sha256 "e50ba1753ad7bea0461e2da643e1b7e9c58b60c3a641bdb8523bd68df3fa0483"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "276ce792b11e3a7167a16b5ec5fe9817b52e774aec3f306fe0c677156f1b57fb" => :catalina
    sha256 "4eeee0dead303506a9f4b415de4f4c4ac46cf190eb092219f0c89fc627b1d426" => :mojave
    sha256 "a75b91d1675f527c13bb65ee3c0b2ff2bf88ecaa7c5d2ac18dc410edeb809a0f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.DefaultBuildkitdImage=earthly/buildkitd:v0.3.3 -X main.Version=v0.3.3 -X" \
              " main.GitSha=839d87ffc38a817ad82c155015fe2320f732a2e7 "
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork"
    system "go", "build",
        "-tags", tags,
        "-ldflags", ldflags,
        *std_go_args,
        "-o", bin/"earth",
        "./cmd/earth/main.go"
  end

  test do
    (testpath/"build.earth").write <<~EOS

      default:
      \tRUN echo Homebrew
    EOS

    output = shell_output("#{bin}/earth --buildkit-host 127.0.0.1 +default 2>&1", 1).strip
    assert_match "Error while dialing invalid address 127.0.0.1", output
  end
end
