# Personal homebrew scripts

Some homebrew formuales I use.

## Motivation

- I'd like to make my hands dirty by building packages from source. Then I could write how I build it from source in Homebrew Formula.
- I prefer to live on the bleeding edge of tools so this would force me to understand how them work in order to make them suit my need. Any one can know how to use but the point is to understand how them works via using these tools.

## Usage

```
brew tap tizee/personal
```

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
ln -s $(brew --prefix zeal)/Zeal.app /Applications/Zeal.app
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

## Other taps

- [plan9port-rb](https://github.com/tizee/plan9port-rb/tree/main)

## Roadmap

- Manage my scripts in macOS with homebrew Formula

