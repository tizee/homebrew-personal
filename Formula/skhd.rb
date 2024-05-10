class Skhd < Formula
  desc "Simple hotkey-daemon for macOS. - my fork of skhd"
  homepage "https://github.com/tizee/skhd"
  head "https://github.com/tizee/skhd.git"
  depends_on :macos => :ventura

  def install
    ENV.deparallelize
    system "make", "-j1", "install"
    system "codesign", "-fs", "-", "#{buildpath}/bin/skhd"
    bin.install "#{buildpath}/bin/skhd"
    (pkgshare/"examples").install "#{buildpath}/examples/skhdrc"
  end

  def caveats; <<~EOS
    Copy the example configuration into your home directory:
      cp #{opt_pkgshare}/examples/skhdrc ~/.skhdrc

    If you want skhd to be managed by launchd (start automatically upon login):
      skhd --start-service

    When running as a launchd service logs will be found in:
      /tmp/skhd_<user>.[out|err].log
    EOS
  end

  test do
    assert_match "skhd-v", shell_output("#{bin}/skhd --version")
  end
end
