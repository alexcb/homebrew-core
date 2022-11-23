class Colorgrep < Formula
  desc "Highlight matching text with color"
  homepage "https://github.com/alexcb/colorgrep/"
  url "https://github.com/alexcb/colorgrep.git",
      tag:      "v0.0.2",
      revision: "acacfa83f5ae9ab7e2f0339008008394854150c3"
  license "MPL-2.0"
  head "https://github.com/alexcb/colorgrep.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=homebrew
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork dfheredoc forceposix"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/main.go"
  end

  test do
    expected_output = "he\e[0;36mll\e[0mo"
    output = shell_output("echo hello | #{bin}/colorgrep -c cyan l+").chomp
    assert_match expected_output, output
  end
end
