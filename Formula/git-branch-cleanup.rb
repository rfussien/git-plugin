class GitBranchCleanup < Formula
  desc "Git plugin to clean up merged and stale branches"
  homepage "https://github.com/rfussien/git-plugins"
  url "https://raw.githubusercontent.com/rfussien/git-plugins/main/src/git-branch-cleanup"
  version "1.0.0"
  sha256 "642299ff4b7d37398fbe4270651d4408894f19b12a6da6fc02142b04ef58fc86"
  license "MIT"

  def install
    bin.install "git-branch-cleanup"
  end

  test do
    system "#{bin}/git-branch-cleanup", "--version"
  end
end
