# Personal homebrew scripts

Some homebrew formuales I use.

## Motivation

- I'd like to make my hands dirty by building packages from source. Then I could write how I build it from source in Homebrew Formula.
- I prefer to live on the bleeding edge of tools so this would force me to understand how them work in order to make them suit my need. Any one can know how to use but the point is to understand how them works via using these tools.

## Usage

```
brew tap tizee/personal
```

### How to update the package with latest commit

```
brew upgrade --fetch-HEAD <package_name>
```

## Formula maintenance

Workflow for editing a formula or cask in this tap.

### Where files live

`brew` reads formulae from the **installed tap clone**, not from a working
checkout elsewhere:

```
$(brew --repository tizee/personal)/Formula/<name>.rb
# = /opt/homebrew/Library/Taps/tizee/homebrew-personal/Formula/<name>.rb
```

If you keep a separate working copy of this repo, edit there and copy the file
into the tap clone (or just edit the tap clone directly), then commit and push
so `brew update` picks it up.

### Lint before committing

Always run both checks; they must pass with no output / no offenses:

```sh
brew style tizee/personal/<name>            # rubocop style
brew audit --formula --strict tizee/personal/<name>
```

For a cask use `--cask` instead of `--formula`. Common fixes the linter wants:
use `File::NULL` not `"/dev/null"`, `assert_path_exists` not
`assert_predicate ..., :exist?`, and avoid removed OS-version symbols
(`:sierra`, `:high_sierra`, ...) which newer Homebrew rejects.

### Build and test locally

```sh
brew install --HEAD --build-from-source tizee/personal/<name>   # build it
brew test tizee/personal/<name>                                 # run the test block
brew info tizee/personal/<name>                                 # check desc/caveats render
```

For HEAD formulae, iterate with `brew reinstall --HEAD` after each change.

### Documentation in a formula

User-facing docs live in the `desc` (one line) and the `caveats` block (shown
after install and in `brew info`). Keep them in sync with the upstream project
README when behaviour changes. For the `tmux` formula specifically, the
`caveats` documents capture mode usage and the `@capture-*` options, and the
test block asserts the capture feature is compiled in.

## Formula

- ✅ `zeal`
    - A simple offline documentation browser, which could be considered as an open source alternative for Dash in macOS.
- ✅ `tmux`
    - build terminal multiplexer with OSC8 hyperlinks support
- ✅ `perl-xml-parser`
    - building with homebrew's `perl` instead of building against system `perl`
- ✅ `aseprite`
    - A pixel-art tool
- ✅ `fastfetch`
    - A screenfetch/neofetch-like alternative
- ✅ `borders`
    - Draw borders for yabai
- ✅ `yabai`
    - Tiling Window manager in macOS
- ✅ `skhd`
    - A simple hotkey daemon in macOS
- ✅ `gitstatus`
    - **gitstatus** is a 10x faster alternative to `git status` and `git describe`.
- ✅ `wezterm`
    - GPU-accelerated cross-platform terminal emulator and multiplexer

## Cask

- ✅ `ice`
    - Powerful menu bar manager for macOS. This cask installs the newest
      pre-release build (`0.11.13-dev.2`) that fixes the UI issues on macOS 26
      Tahoe, since the latest stable release is long outdated.

### yabai

- Install
```
brew install --HEAD tizee/personal/yabai
```

### skhd

- Install
```
brew install --HEAD tizee/personal/skhd
```

### JankyBorders

- Install
```
brew install --HEAD tizee/personal/boreders
```

### Aseprite.app

- see [tizee/build-aseprite-from-source](https://github.com/tizee/build-aseprite-from-source)

- Install
```
brew install --HEAD tizee/personal/aseprite
```

- link to `/Applications`
```
ln -s $(brew --prefix aseprite)/Aseprite.app /Applications/Aseprite.app
```

### Zeal.app

- Install
```
brew install --HEAD tizee/personal/zeal
```

- link to `/Applications`
```
ln -s $(brew --prefix zeal)/Zeal.app /Applications/Zeal.app
```

The scirpt is modified from:

- https://github.com/markwu/homebrew-personal
- https://github.com/koraysels/homebrew-personal

See https://github.com/zealdocs/zeal/wiki/Build-Instructions-for-macOS for more details.

### tmux

- Install
```
brew install --HEAD tizee/personal/tmux
```

### perl-xml-parser

- Install
```
brew install --HEAD tizee/personal/perl-xml-parser
```

- Verify installation
```
PERL5LIB=$(brew --prefix perl-xml-parser)/libexec/lib/perl5 perl -e "require XML::Parser"
```

### Wezterm

- Install
```
brew install --HEAD tizee/personal/wezterm
```

- links to `/Applications`
```
ln -s $(brew --prefix wezterm)/Wezterm.app /Applications/Wezterm.app
```

### Ice.app

A powerful menu bar manager for macOS. The latest stable release predates macOS
Tahoe and has many UI issues on current systems, so this cask intentionally
tracks the newest pre-release build (`0.11.13-dev.2`) that fixes the macOS 26
Tahoe rendering. Requires macOS Tahoe (26) or newer.

- Install
```
brew install --cask tizee/personal/ice
```

- Uninstall (with cleanup)
```
brew uninstall --cask --zap tizee/personal/ice
```

## Other taps

- [plan9port-rb](https://github.com/tizee/plan9port-rb/tree/main)

## Roadmap

- Manage my scripts in macOS with homebrew Formula

