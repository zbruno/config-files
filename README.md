# config-files

This is my repo of different settings and config files that I want to share across computers.

Assumes Apple Silicon (Homebrew at `/opt/homebrew`). Run the steps in order.

## 1. Install Homebrew and git

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install git
```

## 2. Clone this repo

```bash
git clone git@github.com:zbruno/config-files.git ~/Sites/config-files
```

## 3. Install oh-my-zsh + the Powerlevel10k theme

The `.zshrc` is built on oh-my-zsh (`source $ZSH/oh-my-zsh.sh`) and loads p10k as an
oh-my-zsh theme (`ZSH_THEME="powerlevel10k/powerlevel10k"`). Neither is a Homebrew
package, so install them before copying the config. `--keep-zshrc` stops the installer
from clobbering the `.zshrc` you're about to copy in.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
```

## 4. Copy the shell config into your home dir

```bash
cp ~/Sites/config-files/{.zshrc,.p10k.zsh} ~
```

## 5. Let Homebrew install everything else

```bash
cd ~/Sites/config-files/ && brew bundle
```

## 6. Install colorls (used for shell completion in .zshrc)

```bash
sudo gem install colorls
```

## 7. Start the databases

Postgres needs its data cluster created on first install; both services then run in the
background. `mysql` and `postgresql@18` are keg-only — the PATH lines they need are
already in the copied `.zshrc`.

```bash
/opt/homebrew/opt/postgresql@18/bin/initdb -D /opt/homebrew/var/postgresql@18
brew services start postgresql@18
brew services start mysql
brew services list   # confirm both show "started"
```

Optional MySQL hardening / a default DB matching your user:

```bash
mysql_secure_installation
createdb "$(whoami)"
```

## 8. Point Hammerspoon at the config in this repo

```bash
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/Sites/config-files/hammerspoon.lua"
```

## 9. Authenticate the GitHub CLI

```bash
gh auth login
```

## 10. Reload the shell

```bash
exec zsh
p10k configure   # only if you want to regenerate ~/.p10k.zsh; the repo's copy already works
```

## Manual steps (no script can do these)

These require GUI clicks / macOS permission grants:

- **iTerm2 font** — set the font to **Hack Nerd Font** (installed by `brew bundle`) so the
  p10k prompt glyphs render. iTerm2 → Settings → Profiles → Text → Font.
- **Karabiner-Elements** — approve the driver extension, then grant **Input Monitoring** in
  System Settings → Privacy & Security.
- **Hammerspoon** and **Raycast** — grant **Accessibility** permission in
  System Settings → Privacy & Security → Accessibility.
- **1Password** — enable browser / CLI integration if you use it.

GUI apps installed as casks (Discord, Slack, Cursor, Obsidian, Claude, Codex, GitHub
Desktop) need nothing beyond launching.
