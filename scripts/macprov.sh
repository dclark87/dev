#!/usr/bin/env bash

set -e

usage() {
  cat >&2 <<EOF

usage: $(basename "$0") <args>
  $(basename "$0") provisions a Mac with a functional development environment.

args:
  --workspace, -w <workspace>  Path to base working directory directory.
EOF
}

parse_args() {
  while :; do
    case $1 in
      -h|--help)
        usage
        exit
        ;;
      *)
        break
        ;;
    esac
  done
}

main() {
  parse_args "$@"

  # Install homebrew.
  if [ ! -f "`which brew`" ]; then
      echo -e "Installing homebrew...\n"
      /usr/bin/ruby -e \
          "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # Vim.
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  git clone https://github.com/scrooloose/nerdtree.git ~/.vim/plugged/nerdtree

  # Install brew cask.
  brew tap caskroom/cask

  # Install packages via brew.
  brew install go htop kubernetes-cli the_silver_searcher watch

  # Cask install GUI applications.
  brew cask install google-chrome google-cloud-sdk iterm2 jetbrains-toolbox mactex
}

main "$@"
