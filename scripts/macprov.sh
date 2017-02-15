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
      *)
        if [ -n "$WORKSPACE" ]; then
          break
        else
          echo -e "ERROR: specify '--workspace' arg" >&2
          usage
          exit 1
        fi
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
  brew install go htop watch

  # Cask install GUI applications.
  brew cask install android-studio google-chrome iterm2 dropbox

  # Git completion setup.
  mkdir -p "$HOME"/.git
  curl -LSso "$HOME"/.git/git-completion.bash \
      https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

  # Check for workspace being set.
  if [ -z "$WORKSPACE" ]; then
    echo -e "\nWorkspace not set, auto-setting to $HOME/Projects...\n"
    WORKSPACE="$HOME"/Projects
    mkdir -p "$WORKSPACE"
  else
    echo -e "\nUsing $WORKSPACE for workspace...\n"
  fi

  # Clone projects.
  DEV_REPO="$WORKSPACE"/dev
  if [ ! -d "$DEV_REPO" ]; then
    echo -e "Cloning developer repository...\n"
    git clone https://github.com/dclark87/dev.git $DEV_REPO
  fi

  # Update submodules.
  echo -e "Updating submodules...\n"
  cd $DEV_REPO
  git submodule init && git submodule update --recursive

  # Symlink config files.
  echo -e "Symlinking config files...\n"
  ln -fs "$DEV_REPO"/dotfiles/bash_profile "$HOME"/.bash_profile
  ln -fs "$DEV_REPO"/dotfiles/pypirc "$HOME"/.pypirc
  ln -fs "$DEV_REPO"/dotfiles/tmux.conf "$HOME"/.tmux.conf
  ln -fs "$DEV_REPO"/dotfiles/vimrc "$HOME"/.vimrc
  rm -rf "$HOME"/.vim
  ln -fs "$DEV_REPO"/dotfiles/vim "$HOME"/.vim

  # Source bash_profile
  source "$HOME"/.bash_profile

  # Install pathogen for vim.
  echo -e "Installing pathogen for vim...\n"
  mkdir -p "$HOME"/.vim/autoload
  curl -LSso "$HOME"/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

  # Go setup/
  echo -e "Creating GOPATH: $GOPATH..."
  mkdir -p "$GOPATH"
}

main "$@"
