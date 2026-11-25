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
