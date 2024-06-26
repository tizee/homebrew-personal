class Zeal < Formula
  desc 'Zeal is a simple offline documentation browser inspired by Dash.'
  homepage "http://zealdocs.org/"
  head "https://github.com/zealdocs/zeal.git", branch: "main"

  depends_on :macos => :high_sierra
  depends_on "cmake" => :build
  depends_on "qt@5"
  depends_on "libarchive"

  def caveats
    <<~EOS
      You can link Zeal.app to the Applications folder.

      ln -s $(brew --prefix zeal)/Zeal.app /Applications/Zeal.app

    EOS
  end

  def install
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      opt_prefix.install "build/Zeal.app"

      system "codesign", "--force", "-s", "-", "#{opt_prefix}/Zeal.app/Contents/MacOS/Zeal"

      # link to /Applications
      (opt_prefix/"Zeal.app").install_symlink "/Applications/Zeal.app"

      (bin/"zeal").write("#!/bin/sh\n#{opt_prefix}/Zeal.app/Contents/MacOS/Zeal \"$@\"\n")
  end

  test do
    assert_match "Zeal", shell_output("#{bin}/zeal --version")
  end
end

