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

# Install homebrew.
function install_brew() {
  echo "Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

main() {
  parse_args "$@"

  # Homebrew
  which brew || install_brew

  brew update && brew upgrade

  # Install packages via brew.
  brew install go htop jq kubernetes-cli terraform the_silver_searcher watch

  # Cask install GUI applications.
  brew cask install docker google-chrome google-cloud-sdk iterm2 jetbrains-toolbox slack
}

main "$@"
