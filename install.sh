#!/usr/bin/env bash

set -e

(cd $HOME && ln -sf .dotfiles/.gemrc)
(cd $HOME && ln -sf .dotfiles/.config)
(cd $HOME && ln -sf .dotfiles/.gitconfig)
(cd $HOME && ln -sf .dotfiles/.navimrc)

which /usr/local/bin/brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install git ruby-install neovim fish htop safe-rm aria2 ripgrep tig docker-clean m-cli dnscrypt-proxy python go pup fzy diff-so-fancy gpg

pip3 install --upgrade pip
pip3 install neovim

brew tap caskroom/fonts
brew cask install font-hack-nerd-font

brew install caskroom/versions/docker-edge

brew cask install keybase
brew cask install google-cloud-sdk
brew cask install alfred
brew cask install istat-menus
brew cask install android-studio

go get -u github.com/justjanne/powerline-go

# objective see apps:

# blockblock
# dhs
# kextviewr
# knockknock
# lockdown
# ostiarius
# oversight
# ransomwhere
# taskexplorer
# whatsyoursign
