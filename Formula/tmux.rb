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

  # Self-maintained dev build: keep full debug symbols in the installed binary
  # so the ring-buffer crash logger (--enable-crash-log) and macOS .ips reports
  # symbolize to function/line without a separate dSYM. skip_clean also prevents
  # Homebrew's Cleaner from stripping bin/tmux. See docs/DEBUGGING.md section 5.
  skip_clean "bin/tmux"

  def install
    system "sh", "autogen.sh"

    args = %W[
      --enable-sixel
      --enable-utf8proc
      --enable-capture-mode
      --enable-crash-log
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
    # Keep reliable, symbolizable backtraces for the ring-buffer crash logger
    # (--enable-crash-log) and macOS .ips reports: frame pointers survive -O2
    # and -g keeps function/line info. See docs/DEBUGGING.md section 5.
    ENV.append "CFLAGS", "-fno-omit-frame-pointer -g"
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

      This is tizee's fork of tmux with native capture mode, built with
      --enable-capture-mode. Capture mode overlays keyboard hints on copy
      mode to quickly select URLs, file paths, git SHAs, emails and more.

      Usage:
        - Prefix + Y           enter capture mode from a normal pane
        - Y (in copy mode)     arm the hint overlay on the current view
        - type a hint          copy the match to the buffer and clipboard
        - q / Escape / C-c     dismiss the overlay

      Configure via tmux.conf user options, for example:
        set -g @capture-patterns       "regex1|regex2"
        set -g @capture-hint-keys      "asdfjklgh"
        set -g @capture-hint-style     "fg=#282828,bg=#fabd2f,bold"

      Custom patterns use POSIX extended regular expressions (ERE). Use
      POSIX classes like [[:digit:]] and [[:alnum:]], not Perl shorthands
      (\\d, \\w, \\b are unsupported). @capture-patterns appends to the
      built-ins; @capture-patterns-override replaces them entirely:
        set -g @capture-patterns "[A-Z]+-[[:digit:]]+|TODO|FIXME"

      See the CAPTURE MODE section of the tmux(1) manual for details.
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
