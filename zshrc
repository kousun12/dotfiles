export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting zsh-completions)


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

# compctl -g '~/.teamocil/*(:t:r)' itermocil

bindkey -v
bindkey '^R' history-incremental-search-backward
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
eval "$(pyenv init --path)"
export PATH="$OPENSSL_ROOT/bin:$HOME/.rbenv/bin:$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files'

export PATH="$PATH:$HOME/code/sq"
# eval "$(_SQ_COMPLETE=zsh_source sq)"

export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/postgresql@12/bin:$PATH"
