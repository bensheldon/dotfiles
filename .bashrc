#
# Reload after changes: source ~/.bashrc
#

# chruby
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
chruby 2.1.1

# ruby-build
RUBY_BUILD_CACHE_PATH=$HOME/.rubies/cache

# Python virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Workspace
source /usr/local/bin/virtualenvwrapper.sh

# NVM
[ -s $HOME/.nvm/nvm.sh ] && . $HOME/.nvm/nvm.sh

# pear
export PATH="/users/bensheldon/.pear/bin:$PATH"

# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Heroku
export PATH="/usr/local/heroku/bin:$PATH"

# Postgres.app
export PATH="/Applications/Postgres.app/Contents/MacOS/bin:${PATH}"
export PGHOST=/tmp

# Cairo (for `npm install node-canvas`)
export PKG_CONFIG_PATH="/opt/X11/lib/pkgconfig:$PKG_CONFIG_PATH"
#export PKG_CONFIG_PATH="/lib/pkgconfig:/usr/local/opt/pixman/lib/pkgconfig:/usr/local/opt/fontconfig/lib/pkgconfig:/usr/local/opt/freetype/lib/pkgconfig:/usr/local/opt/libpng/lib/pkgconfig:/usr/X11/lib/pkgconfig:$PKG_CONFIG_PATH"

###############
#             #
#   ALIASES   #
#             #
###############

# multitool
alias plz="foreman run bundle exec "

# sublime
alias sublime="open -a /Applications/Sublime\ Text.app "

function ref {
  open http://www.omniref.com/?q="$*"
}

# Onebox
alias mount-onebox="mkdir /Volumes/Onebox; sshfs root@onebox:/ /Volumes/Onebox -olocal,auto_cache,reconnect,defer_permissions,noappledouble,volname=Onebox; echo 'Pantheon Onebox Mounted 🎉'"
alias umount-onebox="umount /Volumes/Onebox; echo 'Pantheon Onebox Unmounted 👾'"

# added by travis gem
[ -f /Users/bensheldon/.travis/travis.sh ] && source /Users/bensheldon/.travis/travis.sh

# Get the Pull Request for a given GITHUB_UPSTREAM= 
function pr_for_sha {
  git log --merges --ancestry-path --oneline $1..master | grep 'pull request' | tail -n1 | awk '{print $5}' | cut -c2- | xargs -I % open https://github.com/$GITHUB_UPSTREAM/${PWD##*/}/pull/%
}
