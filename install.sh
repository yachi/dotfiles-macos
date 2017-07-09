#!/usr/bin/env bash

set -e

(cd $HOME && ln -sf .dotfiles/.gemrc)
(cd $HOME && ln -sf .dotfiles/.config)
(cd $HOME && ln -sf .dotfiles/.gitconfig)

which /usr/local/bin/brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap caskroom/fonts
brew install git ruby-install neovim fish htop safe-rm aria2
brew cask install font-hack-nerd-font
