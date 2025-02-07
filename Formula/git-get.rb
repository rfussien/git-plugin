class GitGet < Formula
  desc "Git plugin to clone and manage repositories in an organized directory structure"
  homepage "https://github.com/rfussien/git-plugins"
  url "https://raw.githubusercontent.com/rfussien/git-plugins/main/src/git-get"
  version "1.0.0"
  sha256 "276b7dd33cdff671b3407f5e4a7f3d4128feaeac72b7f9673d120c9bbf24e0b0"
  license "MIT"
  
  def install
    bin.install "git-get"
  end
  
  test do
    system "#{bin}/git-get", "--version"
  end
end