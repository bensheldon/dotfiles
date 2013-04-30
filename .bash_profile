. ~/.profile
. ~/.bashrc

export PATH="/usr/local/bin:$PATH"

# Path to the bash it configuration
# export BASH_IT="/Users/bensheldon/.bash_it"

# Lock and Load a custom theme file
# export BASH_IT_THEME="bobby"

# Load Bash It
# source $BASH_IT/bash_it.sh

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

#homebrew
export PATH=/usr/local/bin:/usr/local/sbin:${PATH}
 
# homebrew python 2.7
export PATH="/usr/local/share/python:${PATH}"

# Postgres.app
export PATH="/Applications/Postgres.app/Contents/MacOS/bin:${PATH}"
export PGHOST=/tmp

#virtualenv wrapper
export WORKON_HOME=$HOME/workspace/Environments
source /usr/local/share/python/virtualenvwrapper.sh

