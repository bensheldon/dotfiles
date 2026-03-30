Dotfiles
========

Managed using a [bare git repo](https://www.atlassian.com/git/tutorials/dotfiles) so that files in `$HOME` are tracked directly — no symlinks or copying needed.

Setup
-----

### New machine

```sh
git clone https://github.com/bensheldon/dotfiles.git ~/Repositories/bensheldon/dotfiles
cd ~/Repositories/bensheldon/dotfiles
./bootstrap.sh
```

This will:

1. Clone the repo as a bare repo to `~/.dotfiles.git`
2. Checkout tracked files into `$HOME`, backing up any conflicts to `~/.dotfiles-backup/`
3. Add a `dotfiles` alias to `.zshrc`

### Day-to-day usage

Use the `dotfiles` alias instead of `git`:

```sh
dotfiles status
dotfiles add ~/.zshrc
dotfiles commit -m "Update zshrc"
dotfiles push
```

Any changes you make to tracked files (e.g. editing `~/.zshrc`) will show up in `dotfiles status` automatically.

### Adding a new file

```sh
dotfiles add ~/.config/starship.toml
dotfiles commit -m "Track starship config"
dotfiles push
```

Note: untracked files are hidden by default so `dotfiles status` only shows changes to files you've explicitly added.

Applications
------------

### SSH

Don't forget to add all the custom keys with `$ ssh-add -K path/to/my_key`

Add this to `~/.ssh/config` to improve timeout behavior and prevent frozen consoles:

```
ServerAliveInterval 30
ServerAliveCountMax 4
```

### iTerm 2

To get Option-Arrow move by word that the OSX Terminal provides:

Preferences -> Profiles -> Keys

```
Keyboard Shortcut: Option <-
Action: Send Escape Sequence
Esc+: b

Keyboard Shortcut: Option ->
Action: Send Escape Sequence
Esc+: f
```
