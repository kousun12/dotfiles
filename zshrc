export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting)

# ssh
export SSH_KEY_PATH="~/.ssh/dsa_id"
export ANDROID_HOME="${HOME}/Library/Android/sdk"
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"

export OPENNI2_REDIST=/usr/local/lib/ni2
export OPENNI2_INCLUDE=/usr/local/include/ni2

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
source "${HOME}/.finrc"
source "${FIN_HOME}/fin-dev/bashrc"
source "${HOME}/.bash_secrets"

source $ZSH/oh-my-zsh.sh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
eval "$(pyenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
