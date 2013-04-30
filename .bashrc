#
# Reload after changes: source ~/.bashrc
#

# rvm
PATH=$PATH:$HOME/.rvm/bin

# virtualenvwrapper
WORKON_HOME=$HOME/workspace/Environments

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
