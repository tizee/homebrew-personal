class Borders < Formula
  env :std
  desc "A window border system for macOS"
  homepage "https://github.com/FelixKratz/JankyBorders"
  license "GPL-3.0-only"
  head "https://github.com/FelixKratz/JankyBorders.git", branch: "main"

  depends_on :macos => :ventura

  def install
    (var/"log/jankyborders").mkpath
    system "make", "-j1"

    system "codesign", "--force", "-s", "-", "#{buildpath}/bin/borders"
    bin.install "#{buildpath}/bin/borders"
    man1.install "#{buildpath}/docs/borders.1"
  end

  test do
    assert_match "Refer to the man page for help: man borders", shell_output("#{opt_bin}/borders --help")
  end
end
