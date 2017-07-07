#!/usr/bin/env bash

set -e

which /usr/local/bin/brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap caskroom/fonts
brew install git ruby-install neovim fish htop safe-rm
brew cask install font-hack-nerd-font

(cd $HOME && ln -sf .dotfiles/.gemrc)
(cd $HOME && ln -sf .dotfiles/.config)
