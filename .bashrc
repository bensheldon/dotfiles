#
# Reload after changes: source ~/.bashrc
#

# chruby
# source /usr/local/opt/chruby/share/chruby/chruby.sh
# source /usr/local/share/chruby/auto.sh
# chruby 2.4.2

export EDITOR=atom

# # Python virtualenvwrapper
# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/Workspace
# [ -f /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh
#
# # NVM
# export NVM_DIR="$HOME/.nvm"
# . "$(brew --prefix nvm)/nvm.sh"


# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Postgres.app
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:${PATH}"
export PGHOST=/tmp

# $ brew install git bash-completion | https://github.com/OpenSC/OpenSC/issues/782
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Add git branch to command prompt
git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
case "$TERM" in
  xterm-color)
    PS1='[\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]]$(git_branch)\$ '
    ;;
  *)
    PS1='[\u@\h:\w]$(git_branch)\$ '
    ;;
esac

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

function ref {
  open http://www.omniref.com/?q="$*"
}

# added by travis gem
[ -f /Users/bensheldon/.travis/travis.sh ] && source /Users/bensheldon/.travis/travis.sh

# Get the Pull Request for a given GITHUB_UPSTREAM=
function pr_for_sha {
  git log --merges --ancestry-path --oneline $1..master | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2- | xargs -I % open https://github.com/$GITHUB_UPSTREAM/${PWD##*/}/pull/%
}
