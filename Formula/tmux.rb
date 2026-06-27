class Tmux < Formula
  desc "Terminal multiplexer - tizee's fork with native capture mode"
  homepage "https://github.com/tizee/tmux"
  head "https://github.com/tizee/tmux.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "utf8proc"

  uses_from_macos "bison" => :build # for yacc

  def install
    system "sh", "autogen.sh"

    args = %W[
      --enable-sixel
      --enable-utf8proc
      --enable-capture-mode
      --sysconfdir=#{etc}
    ]

    # use homebrew's ncurses instead of system's ncurses library
    if OS.mac?
      # tmux finds the `tmux-256color` terminfo provided by our ncurses
      # and uses that as the default `TERM`, but this causes issues for
      # tools that link with the very old ncurses provided by macOS.
      # https://github.com/Homebrew/homebrew-core/issues/102748
      args << "--with-TERM=screen-256color"
    end

    ENV.append "LDFLAGS", "-lresolv"
    # use newer version of ncurses library to enable the OSC-8 hyperlinks feature
    ENV.append "PKG_CONFIG_PATH", "#{Formula["ncurses"].lib}/pkgconfig", ":"
    system "./configure", *args, *std_configure_args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
  end

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    system bin/"tmux", "-V"

    # test tmux OSC8 hyperlinks feature
    assert_match "hyperlinks", shell_output("man -P 'grep -o -m 1 hyperlinks' tmux").chomp

    # capture mode is this fork's distinguishing feature and is documented
    # in the manual only when --enable-capture-mode is in effect.
    assert_match "CAPTURE MODE",
                 shell_output("man -P cat tmux").chomp

    require "pty"

    socket = testpath/tap.user
    PTY.spawn bin/"tmux", "-S", socket, "-f", File::NULL
    sleep 10

    assert_path_exists socket
    assert_predicate socket, :socket?
    assert_equal "no server running on #{socket}", shell_output("#{bin}/tmux -S#{socket} list-sessions 2>&1", 1).chomp
  end
end
