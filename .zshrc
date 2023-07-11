# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#-----------------------
# PATH Manipulations
#-----------------------

PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH}"
PATH="/usr/local/git/bin:/sw/bin:${PATH}"
# Homebrew
PATH="/usr/local/sbin:${PATH}"
# VS Code terminal command (code)
PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}"
PATH="~/.local/bin:${PATH}"
PATH="~/.gem/bin:${PATH}"
PATH="/opt/homebrew/opt/ruby/bin:$PATH"

export PATH

#-----------------------
# EXPORT Variables
#-----------------------

export ZSH="/Users/zacharybruno/.oh-my-zsh"
export SSH_KEY_PATH="~/.ssh/rsa_id"

#-----------------------
# THEME Variables
#-----------------------

ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="true"
plugins=(
  git
  yarn 
  node 
  macos 
  sudo
  zsh-z
)

#-----------------------
# VISUAL Customizations
#-----------------------

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} ➜%{%b%f%k%F{yellow}%} %{%f%}"
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='red'
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

#-----------------------
# ALIAS Customizations
#-----------------------

alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias ls='colorls --group-directories-first --almost-all'
alias ll='colorls --group-directories-first --almost-all --long'
cd() { builtin cd "$@"; ls; }
alias cd..='cd ../'
alias ~="cd ~"
alias which='type -all'
alias path='echo -e ${PATH//:/\\n}'
alias gst="git status -s"
alias ga="git add -p"
alias undo='git reset HEAD~1'
alias gcm="git commit -m"
alias notifyDone='osascript ~/Sites/config-files/AppleScripts/NotifyDone.scpt'

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh
source $(dirname $(gem which colorls))/tab_complete.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /Users/zacharybruno/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH=/usr/local/mysql/bin/:$PATH

if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh