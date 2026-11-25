# config-files

This is my repo of different settings and config files that I want to share across computers.

These steps set up a fresh Mac from nothing. They assume Apple Silicon (Homebrew at
`/opt/homebrew`). Run them in order.

| What | File in this repo | How it gets loaded |
| --- | --- | --- |
| Apps and command-line tools | `Brewfile` | `brew bundle` (step 4) |
| Shell: prompt, aliases, plugins | `.zshrc` | copied to `~` (step 5) |
| iTerm2 profile and colors | `iTerm/iterm.json` | imported in iTerm2 (step 7) |
| Caps lock as hyper key | `karabiner/karabiner.json` | copied to `~/.config/karabiner` (step 8) |
| Hotkeys and window management | `hammerspoon.lua`, `Spoons/` | Hammerspoon reads them from this repo (step 9) |

## 1. Install Homebrew

Open the built-in Terminal app and run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

The installer also installs Apple's Command Line Tools, which include `git`. Then put
Homebrew on your PATH, now and for every future shell:

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## 2. Sign in to GitHub

A fresh Mac has no SSH key, so the clone in step 3 fails without this.

```bash
brew install gh
gh auth login
```

Choose **GitHub.com**, then **SSH**, then let it **generate a new SSH key**, then log in
with the browser. This creates `~/.ssh/id_ed25519` and adds it to your GitHub account.

## 3. Clone this repo

It has to live at `~/Sites/config-files`; the Hammerspoon config expects that path.

```bash
mkdir -p ~/Sites
git clone git@github.com:zbruno/config-files.git ~/Sites/config-files
```

## 4. Install everything in the Brewfile

This installs the apps (iTerm2, Hammerspoon, Karabiner-Elements, Raycast, 1Password, ...),
the Nerd Fonts, and what the `.zshrc` loads: the Starship prompt, `eza` (the `ls` aliases),
`zsh-autosuggestions` and `zsh-syntax-highlighting`.

```bash
cd ~/Sites/config-files/ && brew bundle
```

Then make macOS pick up the new fonts:

```bash
killall fontd
```

On a fresh Mac the `~/Library/Fonts` folder does not exist until Homebrew creates it, and
the macOS font service only watches folders that existed when you logged in. Until it
restarts, the Nerd Fonts are on disk but no app can see them, and icons show as boxes.
Logging out and back in does the same thing.

## 5. Copy the shell config and reload

```bash
cp ~/Sites/config-files/.zshrc ~
exec zsh
```

Put anything specific to one machine (API keys, work functions) in `~/.zshrc.local`.
The `.zshrc` loads it if it exists, and it never goes into this repo.

The Starship prompt works with no config. To customize it, create
`~/.config/starship.toml` (see https://starship.rs/config/).

Icons in the prompt and in `ls` show as boxes until the terminal uses a Nerd Font, which
step 7 takes care of for iTerm2.

## 6. Set your git identity

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

## 7. Import the iTerm2 profile

Open iTerm2 and use it from here on.

1. iTerm2 → Settings → Profiles → Other Actions → **Import JSON Profiles**.
2. Choose `~/Sites/config-files/iTerm/iterm.json`.
3. Select the imported profile, then Other Actions → **Set as Default**.
4. Open a new window.

The profile carries the Shades of Purple colors, transparency and **Hack Nerd Font Mono**.
If icons still show as boxes, check Profiles → Text → Font.

## 8. Make caps lock the hyper key (Karabiner-Elements)

The Hammerspoon hotkeys all use "hyper" (shift + control + option + command), which
Karabiner maps onto caps lock. Copy the config in before opening the app:

```bash
mkdir -p ~/.config/karabiner
cp ~/Sites/config-files/karabiner/karabiner.json ~/.config/karabiner/
```

Then open Karabiner-Elements, approve its driver extension and grant **Input Monitoring**
when macOS asks (System Settings → Privacy & Security). If Karabiner was already open, it
picks up the copied file on its own.

The config holds two things:

- **Caps lock → hyper** — applies to every keyboard.
- **Swap left option and left command** — applies only to one specific external keyboard,
  matched by its vendor and product ID, so it does nothing on other keyboards.

## 9. Point Hammerspoon at the config in this repo

```bash
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/Sites/config-files/hammerspoon.lua"
```

Then open Hammerspoon, grant it **Accessibility** permission (System Settings → Privacy &
Security → Accessibility), and turn on **Launch Hammerspoon at login** in its settings. A
"Config Loaded" notification means it worked. If Hammerspoon was already open when
you ran the command, quit and reopen it: it only reads this setting at launch, so Reload
Config keeps looking in `~/.hammerspoon`.

What you get, all on caps lock plus a key:

- **Arrows / Return** — snap the window to a half, or full screen.
- **Letters** — jump to an app (`q` Visual Studio Code, `w` iTerm, `e` Chrome, `a` Slack, `c` Claude, ...;
  the full list is at the top of `hammerspoon.lua`).
- **F5 / F6 / F7** — Spotify previous, play/pause, next.
- **- / =** — volume down, up.

## 10. Start the databases

Postgres needs its data cluster created on first install; both services then run in the
background. `postgresql@18` is keg-only and not on the PATH, so its commands are run by
full path here. `mysql` is on the PATH through the `.zshrc`.

```bash
/opt/homebrew/opt/postgresql@18/bin/initdb -D /opt/homebrew/var/postgresql@18
brew services start postgresql@18
brew services start mysql
brew services list   # confirm both show "started"
```

Optional MySQL hardening / a default DB matching your user:

```bash
mysql_secure_installation
/opt/homebrew/opt/postgresql@18/bin/createdb "$(whoami)"
```

## 11. Enable signed commits (GPG Suite)

`gpg-suite-no-mail` is installed by `brew bundle`. Open **GPG Keychain** and import (or
generate) your signing key, and confirm the same key is added as a GPG key on GitHub
(Settings → SSH and GPG keys). Then turn on signing for every commit:

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

## Remaining app setup

- **Raycast** — grant **Accessibility** permission in System Settings → Privacy & Security.
- **1Password** — sign in, and enable browser / CLI integration if you use it.
- **Wallpapers** — desktop backgrounds and screen savers are in `Wallpapers/`; set them in
  System Settings → Wallpaper.

GUI apps installed as casks (Discord, Slack, Visual Studio Code, Obsidian, Claude, Codex, GitHub
Desktop, WhatsApp) need nothing beyond launching and signing in.

## Keeping this repo up to date

`.zshrc`, the Karabiner config and the iTerm2 profile are copies, so changes made on a machine do not flow back
here on their own.

- After editing `~/.zshrc`: `cp ~/.zshrc ~/Sites/config-files/.zshrc`
- After changing Karabiner settings:
  `cp ~/.config/karabiner/karabiner.json ~/Sites/config-files/karabiner/`
- After changing the iTerm2 profile: Settings → Profiles → Other Actions → Save Profile as
  JSON, and overwrite `iTerm/iterm.json`.
- After installing something with Homebrew that you want everywhere: add it to `Brewfile`.

`hammerspoon.lua` is read straight from this repo, so edits to it apply immediately.
