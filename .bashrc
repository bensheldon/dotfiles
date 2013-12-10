#
# Reload after changes: source ~/.bashrc
#

# rbenv
eval "$(rbenv init -)"

# python virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Workspace
source /usr/local/bin/virtualenvwrapper.sh

# pear
export PATH="/users/bensheldon/.pear/bin:$PATH"

# Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Heroku
export PATH="/usr/local/heroku/bin:$PATH"

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
alias sublime="open -a /Applications/Sublime\ Text\ 2.app "

function ref {
  open http://www.omniref.com/?q="$*"
}
