export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell_2"

ZSH_CUSTOM=~/.zsh

plugins=(
    git
    ssh-agent
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
    )

source $ZSH/oh-my-zsh.sh

# Make overtime work
export PATH=$PATH:/Users/tobiasknudsen/dev/overtime/


export PATH=$PATH:/Users/tobiasknudsen/.klipy/bin/
zle_highlight+=(paste:none)

export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Make thefuck work
eval $(thefuck --alias)

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

# Name stash after current branch
gs() {
  branch=$(git symbolic-ref --short -q HEAD)
  git stash --include-untracked -m "$branch"
}

# Stash picker
gsl(){
  git stash list \
  | fzf \
      --ansi \
      --prompt='Pop > ' \
      --header-first \
      --preview-label=' Stash ' \
      --preview 'git stash show -p --stat --color=always $(echo {} | cut -d "{" -f2 | cut -d "}" -f1)' \
      --bind 'enter:execute(
          stash=$(echo {} | cut -d "{" -f2 | cut -d "}" -f1) \
          && [[ $stash != "" ]] \
          && git stash pop $stash
        )+abort' \
}

# Stash delete
gsd(){
  git stash list \
  | fzf \
      --ansi \
      --multi \
      --prompt='Delete > ' \
      --header-first \
      --preview-label=' Stash ' \
      --preview 'git stash show -p --stat --color=always $(echo {} | cut -d "{" -f2 | cut -d "}" -f1)' \
      --bind 'enter:execute(
          echo {} | while IFS= read -r line; do \
              stash=$(echo "$line" | grep -o "stash@{[0-9]*}" | head -1) \
              && [[ $stash != "" ]] \
              && echo "Dropping stash: $stash" \
              && git stash drop $stash; \
          done \
        )+abort' \
}

ga(){
  staged_files='git ls-files \
    --modified \
    --deleted \
    --other \
    --exclude-standard \
    --deduplicate \
    $(git rev-parse --show-toplevel)' \
  && unstaged_files='git status  --short \
    | grep "^[A-Z]" \
    | awk "{print \$NF}"' \
  && eval "$staged_files" | fzf \
    --multi \
    --reverse \
    --no-sort \
    --prompt='Add > ' \
    --header-first \
    --header '
    > CTRL-R to Reset | CTRL-A to Add
    ' \
    --preview='git status  --short \
          | grep "^[A-Z]" \
          | awk "{print \$NF}"' \
    --preview-label=' Staged ' \
    --bind='ctrl-a:change-prompt(Add > )' \
    --bind="ctrl-a:+change-preview($unstaged_files)" \
    --bind="ctrl-a:+change-preview-label( Staged )" \
    --bind="ctrl-a:+reload($staged_files)" \
    --bind='ctrl-r:change-prompt(Reset > )' \
    --bind="ctrl-r:+change-preview($staged_files)" \
    --bind="ctrl-r:+change-preview-label( Changes )" \
    --bind="ctrl-r:+reload($unstaged_files)" \
    --bind="enter:execute($staged_files | grep {} \
            && git add {+} \
            || git reset -- {+})" \
    --bind="enter:+reload(
            [[ \$FZF_PROMPT =~ 'Add >' ]] \
            && $staged_files \
            || $unstaged_files
            )" \
    --bind='enter:+refresh-preview' \
    --bind='ctrl-p:execute(git add --patch {+})'
}

gap(){
  staged_files='git ls-files \
    --modified \
    --deleted \
    --other \
    --exclude-standard \
    --deduplicate \
    $(git rev-parse --show-toplevel)' \
    && eval "$staged_files" | fzf \
    --preview 'git diff --color=always {}' \
    --bind="enter:execute(git diff --color=always {} | fzf --multi)"
}

gl(){
  git log \
    --graph \
    --color \
    --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an %Creset%s%Cgreen%d' \
    --date=short \
  | fzf \
    --ansi \
    --reverse \
    --no-sort \
    --multi \
    --bind 'enter:execute(
      hash=$(echo {+} | grep -o "[a-f0-9]\{7\}" | tr "\n" " ")\
      && [[ $hash != "" ]] \
      && echo $hash \
      && echo -n $hash | pbcopy
    )+abort' \
}

. /opt/homebrew/opt/asdf/libexec/asdf.sh

# Created by `pipx` on 2024-02-23 09:25:33
export PATH="$PATH:/Users/tobiasknudsen/.local/bin"
eval "$(asdf exec direnv hook "$(basename "$SHELL")")"

# Fabrica CLI wrapper function
source "/Users/tobiasknudsen/.zshrc.d/fabrica.sh"

# Fabrica directory
export FABRICA_DIR="/Users/tobiasknudsen/dev/fabrica"

# Auto-completion for fabrica CLI
source "/Users/tobiasknudsen/.zshrc.d/fabrica-completion.sh"
