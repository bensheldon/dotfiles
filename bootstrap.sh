#!/usr/bin/env zsh
#
# Sets up dotfiles using a bare git repo so that files in $HOME
# are tracked directly — no symlinks or copying needed.
#
# Usage:
#   ./bootstrap.sh          # interactive prompt
#   ./bootstrap.sh --force  # skip confirmation
#
# After running, use the `dotfiles` alias instead of `git` to manage:
#   dotfiles status
#   dotfiles add ~/.zshrc
#   dotfiles commit -m "Update zshrc"
#   dotfiles push

set -e

DOTFILES_REPO="$HOME/.dotfiles.git"
DOTFILES_REMOTE="https://github.com/bensheldon/dotfiles.git"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"

function dotfiles() {
        /usr/bin/git --git-dir="$DOTFILES_REPO" --work-tree="$HOME" "$@"
}

function doIt() {
        # Clone as a bare repo if it doesn't exist yet
        if [ ! -d "$DOTFILES_REPO" ]; then
                echo "Cloning dotfiles bare repo..."
                git clone --bare "$DOTFILES_REMOTE" "$DOTFILES_REPO"
        fi

        # Don't show untracked files (otherwise every file in $HOME appears)
        dotfiles config --local status.showUntrackedFiles no

        # Try to checkout; back up any conflicting files
        if ! dotfiles checkout 2>/dev/null; then
                echo "Backing up existing dotfiles to $BACKUP_DIR..."
                mkdir -p "$BACKUP_DIR"
                dotfiles checkout 2>&1 \
                        | grep -E "^\s+" \
                        | awk '{print $1}' \
                        | while read -r file; do
                                mkdir -p "$BACKUP_DIR/$(dirname "$file")"
                                mv "$HOME/$file" "$BACKUP_DIR/$file"
                        done
                dotfiles checkout
        fi

        echo "Dotfiles installed successfully."
        source "$HOME/.zprofile"
        echo "Use 'dotfiles' instead of 'git' to manage your dotfiles."
}

if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
        doIt
else
        read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
                doIt
        fi
fi
