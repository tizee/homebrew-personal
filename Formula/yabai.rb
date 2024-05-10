class Yabai < Formula
  env :std
  desc "Yabai - Tiling Window Manager for MacOS"
  homepage "https://github.com/koekeishiya/yabai"
  head "https://github.com/koekeishiya/yabai.git", branch: "master"

  depends_on :macos => :high_sierra

  def clear_env
    ENV.delete("CFLAGS")
    ENV.delete("LDFLAGS")
    ENV.delete("CXXFLAGS")
  end

  def install
    clear_env
    (var/"log/yabai").mkpath

    system "make", "-j1", "install"
    system "codesign", "--force", "-s", "-", "#{buildpath}/bin/yabai"

    bin.install "#{buildpath}/bin/yabai"
    (pkgshare/"examples").install "#{buildpath}/examples/yabairc"
    (pkgshare/"examples").install "#{buildpath}/examples/skhdrc"
    man1.install "#{buildpath}/doc/yabai.1"
  end

  def caveats; <<~EOS
    Copy the example configuration into your home directory:
      cp #{opt_pkgshare}/examples/yabairc ~/.yabairc
      cp #{opt_pkgshare}/examples/skhdrc ~/.skhdrc

    If you want yabai to be managed by launchd (start automatically upon login):
      yabai --start-service

    When running as a launchd service logs will be found in:
      /tmp/yabai_<user>.[out|err].log

    If you are using the scripting-addition; remember to update your sudoers file:
      sudo visudo -f /private/etc/sudoers.d/yabai

    Build the configuration row by running:
      echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(\which yabai) | cut -d " " -f 1) $(\which yabai) --load-sa"

    README: https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition
    EOS
  end

  service do
    run "#{opt_bin}/yabai"
    environment_variables PATH: std_service_path_env
    keep_alive true
    process_type :interactive
  end

  test do
    assert_match "yabai-v", shell_output("#{bin}/yabai --version")
  end
end

