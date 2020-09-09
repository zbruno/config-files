# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/zacharybruno/.oh-my-zsh"

#------------------
# PATH Manipulations
#------------------
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH}"
PATH="/usr/local/git/bin:/sw/bin:${PATH}"
# Homebrew
PATH="/usr/local/sbin:${PATH}"
# VS Code terminal command (code)
PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}"
PATH="~/.local/bin:${PATH}"
PATH="~/.gem/bin:${PATH}"
PATH="~/.rvm/bin:${PATH}"

export PATH

#------------------
# Zsh hooks
#------------------

# Enable the addition of zsh hook functions
autoload -U add-zsh-hook

# Set the tab title to the current working directory before each prompt
function tabTitle () {
  window_title="\033]0;${PWD##*/}\007"
  echo -ne "$window_title"
}

# Executes load-nvmrc when the present working directory (pwd) changes
# add-zsh-hook chpwd load-nvmrc
# Executes tabTitle before each prompt
add-zsh-hook precmd tabTitle

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  yarn 
  web-search 
  jsontools
  macports
  node 
  osx 
  sudo
  thor
  docker
)

source $ZSH/oh-my-zsh.sh

# User configuration

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Reload the plugin to highlight the commands each time Iterm2 starts 
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

### VISUAL CUSTOMISATION ### 

# Elements options of left prompt (remove the @username context)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv vcs)
# Elements options of right prompt
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

# Add a second prompt line for the command
POWERLEVEL9K_PROMPT_ON_NEWLINE=true

# Add a space in the first prompt 
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%f"

# Visual customisation of the second prompt line
local user_symbol="$"
if [[ $(print -P "%#") =~ "#" ]]; then
    user_symbol = "#"
fi
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{%B%F{black}%K{yellow}%} $user_symbol%{%b%f%k%F{yellow}%} %{%f%}"

# Change the git status to red when something isn't committed and pushed
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='red'

# Add a new line after the global prompt 
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# Colorise the top Tabs of Iterm2 with the same color as background
# Just change the 18/26/33 wich are the rgb values 
echo -e "\033]6;1;bg;red;brightness;18\a"
echo -e "\033]6;1;bg;green;brightness;26\a"
echo -e "\033]6;1;bg;blue;brightness;33\a"

alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias ls='colorls --group-directories-first --almost-all'
alias ll='colorls --group-directories-first --almost-all --long'
cd() { builtin cd "$@"; ll; }
alias cd..='cd ../'
alias ~="cd ~"
alias which='type -all'
alias path='echo -e ${PATH//:/\\n}'
alias undo='git reset HEAD~1'
alias gcm="git commit -m"
alias notifyDone='osascript ~/Sites/config-files/AppleScripts/NotifyDone.scpt'

#------------------
# Miscellaneous
#------------------

# Allow the use of the z plugin to easily navigate directories
. /usr/local/etc/profile.d/z.sh

# Set Spaceship ZSH as a prompt
autoload -U promptinit
promptinit
prompt spaceship

# Add colors to terminal commands (green command means that the command is valid)
source /usr/local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

function anybar { echo -n $1 | nc -4u -w0 localhost ${2:-1738}; }

#   Git Commands
#   ------------------------------------------
alias gst="git status -s"                   # Git: Git status
alias ga="git add -p"                       # Git: Git add

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

source $ZSH/oh-my-zsh.sh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
eval "$($(go env GOPATH)/bin/assume-role -init)"

export MONOREPO_PATH="$HOME/sites/repo" && source $MONOREPO_PATH/scripts/rc/rc.sh
eval "$(rbenv init -)"

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

source /usr/local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
