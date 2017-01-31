#!/usr/bin/env bash

set -e

usage() {
  cat >&2 <<EOF

usage: $(basename "$0") <args>
  $(basename "$0") provisions Ubuntu with a functional development environment.

args:
-w [workspace]  (Optional) Path to base working directory directory.
                Defaults to \$HOME/Projects

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
  # Install packages
  apt-get install htop
}
