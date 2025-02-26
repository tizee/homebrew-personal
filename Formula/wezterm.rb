class Wezterm < Formula
  env :std
  desc "GPU-accelerated cross-platform terminal emulator and multiplexer"
  homepage "https://wezfurlong.org/wezterm/"

  # Change this to point to your local or remote repo
  head "https://github.com/wez/wezterm.git",
       using: :git,
       branch: "main"

  # Robust Rust check for stable or nightly, requiring >= 1.80.1
  def rust_version_check
    system "rustup", "default", "nightly"
    rust_version_output = `rustc --version`.strip
    cargo_path = `which cargo`.strip
    rustc_path = `which rustc`.strip
    puts "using Rust #{rust_version_output}"
    puts "using cargo #{cargo_path}"
    puts "using rustc #{rustc_path}"
    if rust_version_output.include?("nightly")
      # e.g. "rustc 1.87.0-nightly (abc123 2025-02-25)"
      rust_version_number = rust_version_output.split(" ")[1].split("-")[0]
    else
      rust_version_number = rust_version_output.split(" ")[1]
    end

    if Gem::Version.new(rust_version_number) < Gem::Version.new("1.80.1")
      odie "Rust version >= 1.80.1 is required. You have: #{rust_version_output}"
    end
  end

  def install
    puts "PATH: #{ENV["PATH"]}"
    puts "CARGO_HOME: #{ENV["CARGO_HOME"]}"
    # Now that PATH is set, check that rustc is available.
    rust_version_check

    # 1) Build with Cargo in release mode
    system "cargo", "build", "--release"

    # 2) Create (or copy) the macOS App bundle structure
    app_src  = buildpath/"assets/macos/WezTerm.app"
    app_dest = buildpath/"WezTerm.app"

    rm_rf app_dest
    cp_r app_src, app_dest

    # 3) Remove MetalANGLE .dylibs if needed
    dylibs = Dir[app_dest/"*.dylib"]
    dylibs.each { |dylib| rm_rf dylib } unless dylibs.empty?

    # 4) Ensure required folders exist
    (app_dest/"Contents/MacOS").mkpath
    (app_dest/"Contents/Resources").mkpath

    # 5) Copy shell integration and shell completions into Resources
    resources_dir = app_dest/"Contents/Resources"
    cp_r buildpath/"assets/shell-integration/.", resources_dir
    cp_r buildpath/"assets/shell-completion", resources_dir

    # 6) Compile wezterm’s terminfo data into the bundle’s Resources/terminfo
    terminfo_dir = resources_dir/"terminfo"
    terminfo_dir.mkpath
    system "tic", "-xe", "wezterm", "-o", terminfo_dir, "termwiz/data/wezterm.terminfo"

    # 7) Copy binaries directly from target/release into the .app bundle
    bins = %w[wezterm wezterm-mux-server wezterm-gui strip-ansi-escapes]
    bins.each do |bin_name|
      cp "target/release/#{bin_name}", app_dest/"Contents/MacOS"/bin_name
    end

    # 8) Move the finalized .app bundle into Homebrew’s prefix
    prefix.install app_dest

    # 9) Create symlinks so users can run WezTerm from the CLI
    bins.each do |bin_name|
      bin.install_symlink prefix/"WezTerm.app/Contents/MacOS/#{bin_name}"
    end

    # 10) Install shell completions by symlinking from the app bundle
    # According to the reference, the files must be renamed:
    #   - The zsh file is linked as "_wezterm" in share/zsh/site-functions
    #   - The bash file as "wezterm" in etc/bash_completion.d
    #   - The fish file as "wezterm.fish" in share/fish/vendor_completions.d

    zsh_completion   = prefix/"WezTerm.app/Contents/Resources/shell-completion/zsh"
    bash_completion  = prefix/"WezTerm.app/Contents/Resources/shell-completion/bash"
    fish_completion  = prefix/"WezTerm.app/Contents/Resources/shell-completion/fish"

    (share/"zsh/site-functions").mkpath
    ln_sf zsh_completion, share/"zsh/site-functions/_wezterm"

    (etc/"bash_completion.d").mkpath
    ln_sf bash_completion, etc/"bash_completion.d/wezterm"

    (share/"fish/vendor_completions.d").mkpath
    ln_sf fish_completion, share/"fish/vendor_completions.d/wezterm.fish"
  end

  def caveats
    <<~EOS
      WezTerm is built from source and packaged into a Mac .app bundle at:
        #{opt_prefix}/WezTerm.app

      For a convenient Finder icon, symlink it to /Applications:
        ln -s #{opt_prefix}/WezTerm.app /Applications/WezTerm.app

      This formula does NOT code-sign or notarize the app. It is only for local use.

      Command-line tools:
        wezterm
        wezterm-gui
        wezterm-mux-server
        strip-ansi-escapes
    EOS
  end

  test do
    assert_match "wezterm", shell_output("#{bin}/wezterm --version")
  end
end

