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

brew install caskroom/versions/docker-edge caskroom/versions/slack-beta

brew tap caskroom/fonts
brew cask install keybase \
                  google-cloud-sdk \
                  alfred \
                  istat-menus \
                  font-hack-nerd-font \
                  android-studio


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
