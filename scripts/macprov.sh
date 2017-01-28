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
      -w|--workspace)
        if [ -n "$2" ]; then
          WORKSPACE=$2
          shift
          shift
        else
          echo -e "ERROR: '--workspace' requires a non-empty string argument" >&2
          usage
          exit 1
        fi
        ;;
    esac
  done
}

main() {

  parse_args "$@"

  # Install homebrew
  echo -e "Installing homebrew...\n"
  /usr/bin/ruby -e \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # Install brew cask
  brew tap caskroom/cask

  # Install packages
  brew install htop watch

  if [ -z "$WORKSPACE" ]; then
    echo -e "\nWorkspace not set, auto-setting to $HOME/Projects...\n"
    WORKSPACE="$HOME"/Projects
    mkdir -p "$WORKSPACE"
  else
    echo -e "\nUsing $WORKSPACE for workspace...\n"
  fi
}

main "$@"
