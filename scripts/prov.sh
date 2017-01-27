#!/usr/bin/env bash

# Install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install brew cask
brew tap caskroom/cask

# Install packages
brew install htop
