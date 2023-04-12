# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell_2"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/.zsh

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    ssh-agent
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
    )

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Make pyenv work
eval "$(pyenv init --path)"


export PATH=$PATH:/Users/tobiasknudsen/.klipy/bin/
zle_highlight+=(paste:none)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Save history
HISTSIZE=1000000  # how many lines of history to keep in memory
SAVEHIST=1000000  # how many lines to keep in the history file
# Configure direnv
eval "$(direnv hook zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Interactive branch deletion from: https://peterp.me/cli-tips-interactive-branch-delete/
ibd() {
  local branches branch
  branches=$(git for-each-ref --sort=-committerdate refs/heads/ --format='%(color:blue)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:magenta)%(authorname)%(color:reset)' --color=always|column -ts'|') &&
  branch=$(echo "$branches" | fzf --multi --ansi )
  git branch -D $(echo "$branch" | sed "s/ .*//")
}

# Interactive branch selection
branch() {
  local branches branch
  branches=$(git for-each-ref --sort=-committerdate refs/heads/ --format='%(color:blue)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:magenta)%(authorname)%(color:reset)' --color=always|column -ts'|') &&
  branch=$(echo "$branches" | fzf --ansi )
  if [ ! -z "$branch" ];
  then
    git checkout $(echo "$branch" | sed "s/ .*//")
  fi
}

# Interactive branch selection
remote_branch() {
  local branches branch
  branches=$(git for-each-ref --sort=-committerdate refs/remotes/ --format='%(color:blue)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:magenta)%(authorname)%(color:reset)' --color=always|column -ts'|') &&
  branch=$(echo "$branches" | fzf --ansi )
  if [ ! -z "$branch" ];
  then
    git checkout $(echo "$branch" | sed "s/ .*//" | cut -d "/" -f 2-)
  fi
}

ganotify() {
  runs=$(gh run list | awk -F'\t' '{print "\033[36m"$7"\033[0m:"$5":"$3":"$4":"$6":"$8":"$9}' | column -ts ":")
  run=$(echo "$runs" | fzf --ansi --prompt="notify when complete:")
  gh run watch $(echo "$run") && osascript -e 'display notification "Github workflow finished" with title "Tienda"'
}

# Name stash after current branch
gs() {
  branch=$(git symbolic-ref --short -q HEAD)
  git stash -m "$branch"
}

# Stash picker
gsl(){
  stash_index=$(git stash list | fzf | cut -d "{" -f2 | cut -d "}" -f1)
  if [ ! -z "$stash_index" ];
  then
    git stash pop "$stash_index"
  fi
}

. /opt/homebrew/opt/asdf/libexec/asdf.sh
