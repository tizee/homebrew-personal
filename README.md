# Personal homebrew scripts

Some homebrew formuales I use.

## Motivation

I'd like to make my hands dirty by building packages from source. Then I could write how I build it from source in Homebrew Formula.

## Usage

```
brew tap tizee/personal
```

## Formula

- ✅ `zeal`
    - A simple offline documentation browser, which could be considered as an open source alternative for Dash in macOS.
- 🚧`tmux`
    - build terminal multiplexer with OSC8 hyperlinks support
- ✅ `perl-xml-parser`
    - building with homebrew's `perl` instead of building against system `perl`
- 🚧`aseprite`
    - pixel-art tool
- 🚧`fastfetch`
    - screenfetch-like alternative
- 🚧`borders`
    - JankyBorders for yabai
- 🚧`yabai`
    - Tiling Window manager in macOS

### Roadmap

- Manage my scripts with homebrew Formula

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

- Verify installation by listing available
```
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

## Other taps

- [plan9port-rb](https://github.com/tizee/plan9port-rb/tree/main)
