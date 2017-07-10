#!/usr/bin/env bash

set -e

(cd $HOME && ln -sf .dotfiles/.gemrc)
(cd $HOME && ln -sf .dotfiles/.config)
(cd $HOME && ln -sf .dotfiles/.gitconfig)

which /usr/local/bin/brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap caskroom/fonts
brew install git ruby-install neovim fish htop safe-rm aria2 ripgrep tig docker-clean m-cli dnscrypt-proxy python go
brew cask install font-hack-nerd-font

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
