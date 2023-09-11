# vim:ft=ruby
require 'formula'

class Zeal < Formula
  desc 'Zeal is a simple offline documentation browser inspired by Dash.'
  homepage "http://zealdocs.org/"
  head "https://github.com/zealdocs/zeal.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "qt@5"
  depends_on "libarchive"

  def caveats
    <<~EOS
    You can move Zeal.app to the Applications folder.

    Apple Silicon

      cp -Rp /opt/homebrew/Cellar/zeal/*/Zeal.app /Applications/

      Intel Macs

      cp -Rp /usr/local/Cellar/zeal/*/Zeal.app ~/Applications/

    EOS
  end

  def install
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      prefix.install "build/Zeal.app"
      (bin/"zeal").write("#! /bin/sh\n#{prefix}/Zeal.app/Contents/MacOS/Zeal \"$@\"\n")
  end

  test do
    system "zeal", "-h"
  end
end

