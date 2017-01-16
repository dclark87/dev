# Terminal coloring
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# The next line updates PATH for the Google Cloud SDK.
if [ -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc ]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc ]; then
  source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
fi

# PATH variable
export PATH=$HOME/local/bin:$PATH

# Git completion
source $HOME/.git/git-completion.bash

# Go projects
export GOPATH=$HOME/Projects/workspace
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin:$GOPATH/wbin:$HOME/bin
source $GOPATH/src/github.com/pippio/devops/dev/bashrc.arbor
source <(kubectl completion bash)
export PROMPT_COMMAND=precmd

# Bash completion for Homebrew
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
fi
