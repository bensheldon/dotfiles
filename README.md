Dotfiles
========

`bootstrap.sh` script courtesty of [mathiasbynens](https://github.com/mathiasbynens/dotfiles).



Applications
------------

### SSH

Don't forget to add all the custom keys with `$ ssh-add -K path/to/my_key`

### Sublime Text

```
{
	"auto_indent": true,
	"ensure_newline_at_eof_on_save": true,
	"ignored_packages":
	[
		"Vintage"
	],
	"tab_size": 2,
	"trailing_spaces_highlight_color": "comment",
	"translate_tabs_to_spaces": true,
	"trim_automatic_white_space": true,
	"trim_trailing_white_space_on_save": true
}
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
