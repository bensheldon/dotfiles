# Editor
export EDITOR="/Applications/RubyMine.app/Contents/MacOS/rubymine --edit --wait"

# iTerm2
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

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
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:${PATH}"
export PGHOST=/tmp
export PATH="$PATH:$HOME/.docker/bin" # Docker Desktop
export PATH="$HOME/.local/bin:$PATH" # sentry

# Mise (after PATH additions so its tools win). Agent tool shells (e.g. Claude Code)
# never draw a prompt, so `mise activate` hooks don't fire there; use shims instead.
if [[ -n "$CLAUDECODE" || -z "$TERM_PROGRAM" ]]; then
  # Prepend shims, removing any existing entries to prevent duplicates
  path=($HOME/.local/share/mise/shims ${path:#*mise/shims*})
else
  eval "$(mise activate zsh)"
fi

# Allow # inline comments
setopt interactivecomments

# Completions
FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH
autoload -Uz compinit && compinit
setopt PROMPT_SUBST
autoload -U colors && colors

# Dotfiles bare repo alias
alias dotfiles="/usr/bin/git --git-dir=\$HOME/.dotfiles.git --work-tree=\$HOME"

# Aliases
alias rake='noglob rake'
alias ll='ls -lGa'
alias railshunt="lsof -wni tcp:3000"
alias killruby="ps -e | grep ruby | grep -v grep | awk '{print \$1}' | xargs kill"

# Delete local branches merged into the default branch (or the one given)
function git_prune() {
  local base=${1:-$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)}
  base=${base#origin/}; base=${base:-main}
  git checkout "$base" && git branch --merged "$base" | grep -vE "^[*+]|^ +$base\$" | xargs -n 1 git branch -d
  git remote prune origin
}

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

# Machine-specific config (untracked)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
