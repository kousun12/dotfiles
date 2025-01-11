export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git fzf zsh-syntax-highlighting zsh-completions fzf-zsh-plugin colorize)
# stops the auto escape on paste
DISABLE_MAGIC_FUNCTIONS=true

eval "$(/opt/homebrew/bin/brew shellenv)"

# ssh
export SSH_KEY_PATH="~/.ssh/dsa_id"
export ANDROID_HOME="${HOME}/Library/Android/sdk"
export JAVA_HOME="$(/usr/libexec/java_home -v 1.20)"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export RCT_METRO_PORT=8083
export EDITOR=/usr/bin/vim

export OPENNI2_REDIST=/usr/local/lib/ni2
export OPENNI2_INCLUDE=/usr/local/include/ni2
export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"
export OPENSSL_ROOT="$(brew --prefix openssl)"
export LDFLAGS="-L${OPENSSL_ROOT}/lib"
export CPPFLAGS="-I${OPENSSL_ROOT}/include"
export PKG_CONFIG_PATH="${OPENSSL_ROOT}/lib/pkgconfig"

# compctl -g '~/.teamocil/*(:t:r)' itermocil

#setopt inc_append_history
#setopt hist_find_no_dups

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
HIST_STAMPS="yyyy-mm-dd"

HISTORY_IGNORE="(ls|pwd|exit)*"

setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY         # Share history between all sessions.
setopt HIST_IGNORE_DUPS      # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS  # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE     # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS     # Do not write a duplicate event to the history file.
setopt HIST_VERIFY           # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY        # append to history file (Default)
setopt HIST_NO_STORE         # Don't store history commands
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line being added to the history.

bindkey -v
#bindkey '^R' history-incremental-search-backward
#bindkey '^R' fzf-history-widget
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
autoload -U compinit
compinit

ZSH_THEME="robbyrussell"
function chpwd() {
  ls
}

add_alias() {
  if [[ $(rg "alias $1=" ~/.bash_aliases) ]]; then
    echo "You already have an alias for $1"
  else
    echo "alias $1=\"${@:2}\"" >> ~/.bash_aliases
    echo "made alias $1=\"${@:2}\""
    source "${HOME}/.zshrc"
  fi
}

filenamed() {
  rg -g "**/*$1*" --files
}


COMPLETION_WAITING_DOTS="true"

# autoload bashcompinit
# bashcompinit
source "${HOME}/.bash_aliases"
source "${HOME}/.bash_secrets"

# NVM Load

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

source $ZSH/oh-my-zsh.sh
eval "$(rbenv init -)"
eval "$(pyenv init --path)"
export PATH="$OPENSSL_ROOT/bin:$HOME/.rbenv/bin:$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files'

export PATH="$PATH:$HOME/code/sq:$HOME/.cargo/bin"
# eval "$(_SQ_COMPLETE=zsh_source sq)"
#export PYTHONPATH="$HOME/code/modal-client:$PYTHONPATH"

export PATH="/usr/local/sbin:$PATH"
#if [ -d "$HOME/code/ai-python" ] ; then
#  export PATH="$PATH:$HOME/code/ai-python"
#  eval "$(_AI_COMPLETE=zsh_source ai)"
#  # I also alias to just `a`  and `c`;)
#  alias a="ai"
#  alias c="ai --rc"
#fi

eval 
SRS_AC_ZSH_SETUP_PATH=/Users/robcheung/Library/Caches/srs/autocomplete/zsh_setup && test -f $SRS_AC_ZSH_SETUP_PATH && source $SRS_AC_ZSH_SETUP_PATH; # srs autocomplete setup

# For SkyPilot shell completion
. ~/.sky/.sky-complete.zsh


autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc
. "$HOME/.cargo/env"

source "${HOME}/.substrate/.substraterc"

unsetopt autocd


# Created by `pipx` on 2024-08-13 15:56:00
export PATH="$PATH:/Users/robcheung/.local/bin"

# bun completions
[ -s "/Users/robcheung/.bun/_bun" ] && source "/Users/robcheung/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/robcheung/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/robcheung/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/robcheung/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/robcheung/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
