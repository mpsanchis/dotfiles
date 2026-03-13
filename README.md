# Dotfiles

This is my dotfiles repository. It contains all the useful configuration files that I maintain, to customize tools.

## Directory structure

Each tool will have its own directory. In each directory, the nested structure below it represents the structure below `~`. All files in this repo which configure a tool are below its tool directory: `<tool>/path/to/xxx` corresponds to `~/path/to/xxx`.

For instance, for the `.zshrc` file:
```
zsh/.zshrc -- corresponds to --> ~/.zshrc
```

but also for the whole config dir of jj:
```
jj/.config/jj/* -- corresponds to --> ~/.config/jj/*
```

## How to configure

Run:
```
stow */
```
to symlink all dirs, or:

```
stow foo/
```
to symlink only one tool.

## Notes

### On nvim

In case I want to rebase, I keep `~/.config/nvim` as a separate repository. This can be simplified in the future, if I have my own custom nvim config, instead of a fork of kickstart.nvim. 

