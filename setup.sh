# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew tap homebrew/cask-versions
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

echo "Installing Git..."
brew install git

echo "Git config"
git config --global user.name "Tobias Knudsen"
git config --global user.email tobias.hartvedt.knudsen@gmail.com
git config --global pull.rebase true
git config --global push.autoSetupRemote true

# This should already be done since this file is in the dotfiles repo
# echo "Getting dotfiles..."
# alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
# git clone --bare git@github.com:tobiasknudsen/dotfiles.git $HOME/.dotfiles.git
# dotfiles checkout
# dotfiles config --local status.showUntrackedFiles no

echo "Set up SSH with 1password"
read -p "Press [Enter] when finished..."

echo "Installing other brew stuff..."
brew install fzf
brew install bat
brew install pyenv
brew install direnv
brew install precommit
brew install xz #(To make python from asdf work)
brew install terraform
brew install poetry
brew install bruno

echo "Install asdf..."
brew install asdf

echo "Install latest version of python"
asdf plugin add python
asdf install python latest

echo "Install latest version of nodejs"
asdf plugin add nodejs
asdf install nodejs latest

echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


apps=(
    raycast
    firefox
    firefox@developer-edition
    dropbox
    slack
    bettertouchtool
    simplenote
    shottr
    cursor
    1password
)

for app in "${apps[@]}"; do
    if ! brew list --cask "$app" &>/dev/null; then
        echo "Installing $app..."
        brew install --appdir="/Applications" --cask "$app"
    else
        echo "$app is already installed."
    fi
done

echo "Installing zsh plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting

echo "Open Cursor to create Application Support folder"
read -p "Press [Enter] when finished..."

echo "Create symlink for settings and keybindings"
rm ~/Library/Application\ Support/Cursor/User/settings.json
ln -s ~/.vscodium/settings.json ~/Library/Application\ Support/Cursor/User/settings.json

rm ~/Library/Application\ Support/Cursor/User/keybindings.json
ln -s ~/.vscodium/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json

echo "Download non brew apps"
curl -L https://github.com/davidwernhart/AlDente-Charge-Limiter/releases/download/1.20/AlDente.dmg --output ~/Downloads/AlDente.dmg
curl -L https://updates.topnotch.app/TopNotch-latest.zip --output ~/Downloads/TopNotch-latest.zip
curl -L https://download.bjango.com/istatmenus5/ --output ~/Downloads/istatmenus5.zip
curl -L https://macrelease.matthewpalmer.net/Vanilla.dmg --output ~/Downloads/Vanilla.dmg

printf 'Set Mac OS settings(y/n)? '
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "Setting Mac OS settings..."

    # Dock
    defaults write com.apple.dock tilesize -int 60
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock show-recents -bool false
    killall Dock

    #"Expanding the save panel by default"
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

    #"Automatically quit printer app once the print jobs complete"
    defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

    #"Saving to disk (not to iCloud) by default"
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

    #"Disable smart quotes and smart dashes"
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    #"Avoiding the creation of .DS_Store files on network volumes"
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

    # Save screenshots to ~/Screenshots
    mkdir ~/Screenshots
    defaults write com.apple.screencapture "location" -string "~/Screenshots" && killall SystemUIServer

    killall Finder
fi

echo "Done!"