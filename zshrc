export ZSH='~/.oh-my-zsh'

ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting)

# ssh
export SSH_KEY_PATH="~/.ssh/dsa_id"
export JAVA_HOME=$(/usr/libexec/java_home)

alias glog='git log --oneline --pretty=format:"%C(green bold dim)%h%Creset %C(auto)%d %C(cyan bold)%an%Creset %s %C(blue bold)(%cr)%Creset" --decorate --abbrev-commit --date=relative'
alias grhh='git reset --hard @'
alias gg='git grep -i'
alias alog='adb logcat | grep -i'
alias devices='adb devices'
alias xcodeclean="rm -frd ~/Library/Developer/Xcode/DerivedData/* && rm -frd ~/Library/Caches/com.apple.dt.Xcode/*"
alias fcore="cd ~/code/fin-core-beta"
alias fios="cd ~/code/fin-ios"
alias pi='bundle exec pod install'
alias ds='./dev-scripts/docker-shell.sh'
alias gdc='git diff --cached'
alias glast='git for-each-ref --count=20 --sort=-committerdate refs/heads/ --format="%(refname:short)"'
alias slint='swiftlint autocorrect'
alias lane='bundle exec fastlane'
alias bfg='java -jar ~/Downloads/bfg-1.12.14.jar'
alias fsync='docker-sync start'
alias up='git-up'
alias com='docker-compose'
alias c='git commit -m'

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

COMPLETION_WAITING_DOTS="true"

autoload bashcompinit
bashcompinit
source "${HOME}/.finrc"
source "${FIN_HOME}/fin-dev/bashrc"
source "${HOME}/.bash_secrets"

source $ZSH/oh-my-zsh.sh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
