# config-files

This is my repo of different settings and config files that I want to share across computers

## Initial setup

Install homebrew and git:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install git
```

Clone config repo:

```
git clone git@github.com:zbruno/config-files.git ~/Sites/config-files
```

Move zshrc to root

```
cp ~/Sites/config-files/{.zshrc,.p10k.zsh} ~
```

Let homebrew install dependencies

```
cd ~/Sites/config-files/ && brew bundle
```

Set the hammerspoon config location

```
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/Sites/config-files/hammerspoon.lua"
```
