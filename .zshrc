# Iterm2
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

#zsh
alias rake='noglob rake'

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Reload after changes: source ~/.bashrc
#

# chruby
# source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
# source /opt/homebrew/opt/chruby/share/chruby/auto.sh
# chruby 3.0.3

# rbenv
eval "$(rbenv init -)"

# Rake
alias rake='noglob rake'

# Rubymine made the launcher bad: https://youtrack.jetbrains.com/issue/IDEA-318134/
export PATH="/Applications/RubyMine.app/Contents/MacOS:$PATH"
alias mine='rubymine &> /dev/null'

export EDITOR="code -w"

# # Python virtualenvwrapper
# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/Workspace
# [ -f /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh
#
# # NVM
# export NVM_DIR="$HOME/.nvm"
# . "$(brew --prefix nvm)/nvm.sh"

export PATH="/usr/local/bin:$PATH"

# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Postgres.app
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:${PATH}"
export PGHOST=/tmp

# NVM
#export NVM_DIR="$HOME/.nvm"
#[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
# nvm use 12

# Go via `brew install go`
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

# Android Studio
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -Uz compinit && compinit

# Enable execution of $PS1
setopt PROMPT_SUBST
autoload -U colors && colors

# Add git branch to command prompt
# git_branch() {
#   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ %{%F{green}%}(ᛋ \1)%{%f%}/'
# }
#
# PS1='%{%F{red}%}%n@%M%{%f%} %{%F{yellow}%}%d%{%f%}$(git_branch) \$ '

# Cairo (for `npm install node-canvas`)
export PKG_CONFIG_PATH="/opt/X11/lib/pkgconfig:$PKG_CONFIG_PATH"
#export PKG_CONFIG_PATH="/lib/pkgconfig:/usr/local/opt/pixman/lib/pkgconfig:/usr/local/opt/fontconfig/lib/pkgconfig:/usr/local/opt/freetype/lib/pkgconfig:/usr/local/opt/libpng/lib/pkgconfig:/usr/X11/lib/pkgconfig:$PKG_CONFIG_PATH"

###############
#             #
#   ALIASES   #
#             #
###############

# multitool
function plz () {
  if [ -f Gemfile ]; then
    foreman run bundle exec $@
  else
    foreman run $@
  fi
}
alias plz=plz

# better ls
alias ll='ls -lGa'

# find processes binding on port 3000
alias railshunt="lsof -wni tcp:3000"

# sublime
alias sublime="open -a /Applications/Sublime\ Text.app "

alias git_prune='git checkout master && git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d && git remote prune origin'

alias killruby="ps -e | grep ruby | grep -v grep | awk '{print $1}' | xargs kill"

function killitall {
  ps -e | grep -i "$*" | grep -v grep | awk '{print $1}' | xargs kill
}

# Use powerlevel10k zsh plugin via homebrew
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW=true
