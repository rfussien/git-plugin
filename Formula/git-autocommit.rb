class GitAutocommit < Formula
  desc "Git plugin to automatically create formatted commits based on branch names"
  homepage "https://github.com/rfussien/git-plugins"
  url "https://raw.githubusercontent.com/rfussien/git-plugins/main/src/git-autocommit"
  version "1.0.0"
  sha256 "ec8b643bd9f749c33ec2c469894c133bf0a5b5aa12cba75c35134ff3ab330e2c"
  license "MIT"

  def install
    bin.install "git-autocommit"
  end

  test do
    system "#{bin}/git-autocommit", "--version"
  end
end 