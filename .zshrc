export LOADED=".zshrc($([[ -o interactive ]] && echo i || echo n)):$LOADED"

# Editor
export EDITOR="/Applications/RubyMine.app/Contents/MacOS/rubymine --edit --wait"

# iTerm2
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Mise: full activation only for real terminal programs. Tool calls are interactive so we can't use that.
if [[ -n "$TERM_PROGRAM" ]]; then
  eval "$(/opt/homebrew/bin/mise activate zsh)"
else
  # Force prepend mise shims to PATH and remove any existing mise entries to prevent duplicates
  path=($HOME/.local/share/mise/shims ${path:#*mise/shims*})
fi

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# RubyMine launcher workaround
# https://youtrack.jetbrains.com/issue/IDEA-318134/
function openRubyMine() {
  declare -a intellij_args=()
  declare -- wait=""
  for o in "$@"; do
    if [[ "$o" = "--wait" || "$o" = "-w" ]]; then
      wait="-W"
      o="--wait"
    fi
    if [[ "$o" =~ " " ]]; then
      intellij_args+=("\"$o\"")
    else
      intellij_args+=("$o")
    fi
  done
  open -na "/Applications/RubyMine.app/Contents/MacOS/rubymine" $wait --args "${intellij_args[@]}"
}
alias mine=openRubyMine

# PATH additions
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:${PATH}"
export PGHOST=/tmp

# Android Studio
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
autoload -Uz compinit && compinit
setopt PROMPT_SUBST
autoload -U colors && colors

# Aliases
alias rake='noglob rake'
alias ll='ls -lGa'
alias railshunt="lsof -wni tcp:3000"
alias git_prune='git checkout master && git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d && git remote prune origin'
alias killruby="ps -e | grep ruby | grep -v grep | awk '{print \$1}' | xargs kill"

function plz () {
  if [ -f Gemfile ]; then
    foreman run bundle exec $@
  else
    foreman run $@
  fi
}

function killitall {
  ps -e | grep -i "$*" | grep -v grep | awk '{print $1}' | xargs kill
}

# Starship Terminal Prompt: https://starship.rs/
eval "$(starship init zsh)"
