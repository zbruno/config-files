# Homebrew's paths are set up in ~/.zprofile.

#-----------------------
# PATH
#-----------------------

typeset -U path  # no duplicate entries
path=("$HOME/.local/bin" "/opt/homebrew/opt/mysql/bin" $path)

#-----------------------
# History and completion
#-----------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case-insensitive tab completion
zstyle ':completion:*' menu select

#-----------------------
# Aliases
#-----------------------

alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --git --group-directories-first'
alias la='eza -la --icons --git --group-directories-first'
alias tree='eza --tree --icons'

alias path='echo -e ${PATH//:/\\n}'
alias gst="git status -s"
alias ga="git add -p"
alias undo='git reset HEAD~1'
alias gcm="git commit -m"
alias stopcoder='pkill -f "systemcontainer"'

#-----------------------
# Functions
#-----------------------

# Amphetamine replacement: `awake` keeps the Mac awake (lid closed too) for a chosen time; `sleepok` undoes it.
awake() {
  local choice PS3="Stay awake for how long? "
  select choice in indefinitely "1 hour" "2 hours" "3 hours" "4 hours" "5 hours"; do
    [[ -n $choice ]] && break
  done
  [[ -z $choice ]] && return 1
  sudo -v || return 1
  sudo pkill -f '[a]wake-timer'  # cancel any earlier timer so it can't cut this one short
  sudo pmset -a disablesleep 1 || return 1
  if [[ $choice == indefinitely ]]; then
    echo "Awake until you run sleepok."
  else
    local hours=${choice%% *}
    sudo -b nohup sh -c "sleep $((hours * 3600)); pmset -a disablesleep 0" awake-timer >/dev/null 2>&1
    echo "Awake for $choice (until $(date -v+${hours}H '+%-I:%M %p'))."
  fi
}

sleepok() {
  sudo pkill -f '[a]wake-timer'
  sudo pmset -a disablesleep 0 && echo "Sleep re-enabled."
}

# Machine-only settings and secrets; never committed.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

#-----------------------
# Tools
#-----------------------

# Prompt
eval "$(starship init zsh)"

# Plugins (syntax highlighting must be last)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
