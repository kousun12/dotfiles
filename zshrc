export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting)

# ssh
export SSH_KEY_PATH="~/.ssh/dsa_id"
export ANDROID_HOME="${HOME}/Library/Android/sdk"
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
export NVM_DIR="$HOME/.nvm"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export RCT_METRO_PORT=8083

export OPENNI2_REDIST=/usr/local/lib/ni2
export OPENNI2_INCLUDE=/usr/local/include/ni2
export OPENSSL_ROOT="$(brew --prefix openssl)"
export LDFLAGS="-L${OPENSSL_ROOT}/lib"
export CPPFLAGS="-I${OPENSSL_ROOT}/include"
export PKG_CONFIG_PATH="${OPENSSL_ROOT}/lib/pkgconfig"

compctl -g '~/.teamocil/*(:t:r)' itermocil

bindkey -v
bindkey '^R' history-incremental-search-backward
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
autoload -U compinit
compinit -u

ZSH_THEME="robbyrussell"
function chpwd() {
  emulate -L zsh
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


COMPLETION_WAITING_DOTS="true"

autoload bashcompinit
bashcompinit
source "${HOME}/.bash_aliases"
#source "${HOME}/.finrc"
#source "${FIN_HOME}/fin-dev/bashrc"
source "${HOME}/.bash_secrets"

# NVM Load
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"
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
eval "$(pyenv init -)"
export PATH="$OPENSSL_ROOT/bin:$HOME/.rbenv/bin:$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# if [[ $(docker-machine status  2>/dev/null) != "Running" ]]; then docker-machine start  >/dev/null; fi
# eval $(docker-machine env)
# export HOST=$(docker-machine ip)
export ENSE_DIR=/Users/robertcheung/code/development
export ENSE_MOBILE=/Users/robertcheung/code/ense-rn

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/robertcheung/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/robertcheung/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/robertcheung/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/robertcheung/google-cloud-sdk/completion.zsh.inc'; fi
