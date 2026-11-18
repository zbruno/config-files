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

## 3. Copy the shell config into your home dir

```bash
cp ~/Sites/config-files/.zshrc ~
```

## 4. Let Homebrew install everything else

This includes what the `.zshrc` loads: the Starship prompt, `eza` (the `ls` aliases),
`zsh-autosuggestions` and `zsh-syntax-highlighting`.

```bash
cd ~/Sites/config-files/ && brew bundle
```

## 5. Start the databases

Postgres needs its data cluster created on first install; both services then run in the
background. `mysql` and `postgresql@18` are keg-only — the PATH line for `mysql` is
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

## 6. Point Hammerspoon at the config in this repo

```bash
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/Sites/config-files/hammerspoon.lua"
```

## 7. Authenticate the GitHub CLI

```bash
gh auth login
```

## 8. Enable signed commits (GPG Suite)

`gpg-suite-no-mail` is installed by `brew bundle`. After you import/create your key in
GPG Keychain (see Manual steps), turn on signing for every commit:

```bash
git config --global commit.gpgsign true
```

If git can't find `gpg`, point it at GPG Suite's binary:

```bash
git config --global gpg.program /usr/local/MacGPG2/bin/gpg2
```

Set your signing key once you know the ID (GPG Keychain → key → Copy → Fingerprint, or
`gpg --list-secret-keys --keyid-format LONG`):

```bash
git config --global user.signingkey YOUR_KEY_ID
```

## 9. Reload the shell

```bash
exec zsh
```

The Starship prompt works with no config. To customize it, create
`~/.config/starship.toml` (see https://starship.rs/config/).

## Manual steps (no script can do these)

These require GUI clicks / macOS permission grants:

- **iTerm2 font** — set the font to **Hack Nerd Font** or **MesloLGS Nerd Font** (both
  installed by `brew bundle`) so the prompt and `eza` icons render.
  iTerm2 → Settings → Profiles → Text → Font.
- **Karabiner-Elements** — approve the driver extension, then grant **Input Monitoring** in
  System Settings → Privacy & Security.
- **Hammerspoon** and **Raycast** — grant **Accessibility** permission in
  System Settings → Privacy & Security → Accessibility.
- **1Password** — enable browser / CLI integration if you use it.
- **GPG Suite** — open **GPG Keychain**, import (or generate) your signing key, then finish
  step 8 so git signs with it. Confirm the same key is added as a GPG key on GitHub
  (Settings → SSH and GPG keys).

GUI apps installed as casks (Discord, Slack, Cursor, Obsidian, Claude, Codex, GitHub
Desktop) need nothing beyond launching.