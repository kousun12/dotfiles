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
alias dk="docker-compose"
alias rn="react-native"
alias rios="react-native run-ios --port 8083"
alias rdb="open rndebugger://set-debugger-loc?host=localhost&port=8083"
