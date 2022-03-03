# dotfiles

This repository manages my dotfiles with git, inspired by
[harfangk](https://harfangk.github.io/2016/09/18/manage-dotfiles-with-a-git-bare-repository.html).

## Bootstrapping a new machine

```
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
git clone --bare git@github.com:tobiasknudsen/dotfiles.git $HOME/.dotfiles.git
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```
