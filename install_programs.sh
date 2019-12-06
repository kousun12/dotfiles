#!/bin/bash

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# zsh
brew install zsh

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install command-line tools
xcode-select --install

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install `wget` with IRI support.
brew install wget --with-iri

# install language version managers
brew install rbenv
brew install pyenv
brew install nvm

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install other useful binaries.
brew install ack
brew install git
brew install git-lfs

brew install vim
brew install yarn

# install casks

brew tap caskroom/cask
brew cask install spectacle \
  1password \
  alfred \
  docker \
  flux \
  iterm2 \
  java \
  jetbrains-toolbox \
  spotify \
  google-chrome \
  vlc


# Remove outdated versions from the cellar.
brew cleanup

