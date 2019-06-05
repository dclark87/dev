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

  # Install brew cask.
  brew tap caskroom/cask

  # Install packages via brew.
  brew install go htop the_silver_searcher watch

  # Cask install GUI applications.
  brew cask install google-chrome iterm2 mactex
}

main "$@"
