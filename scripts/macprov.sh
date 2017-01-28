#!/usr/bin/env bash

set -e

usage() {
  cat >&2 <<EOF

usage: $(basename "$0") <args>
  $(basename "$0") provisions a Mac with a functional development environment.

args:
  -w [workspace]  Path to base working directory directory.

EOF
}

parse_args() {
  while :; do
    case $1 in
      -h|--help)
        usage
        exit
        ;;
    esac
  done
}

main() {
  # Install homebrew
  /usr/bin/ruby -e \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # Install brew cask
  brew tap caskroom/cask

  # Install packages
  brew install htop watch
}
