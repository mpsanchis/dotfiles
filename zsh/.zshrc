# DIRENV (https://direnv.net/)
eval "$(direnv hook zsh)"

# MISE (software manager)
eval "$(/opt/homebrew/bin/mise activate zsh)"

# ZED IDE (and other binaries installed manually)
export PATH=$HOME/.local/bin:$PATH

# homebrew
# export HOMEBREW_PREFIX=/opt/homebrew
## Make homebrew-installed libraries available by default
export DYLD_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_LIBRARY_PATH"
export LIBRARY_PATH="/opt/homebrew/lib:$LIBRARY_PATH"

# XDG BASE DIRECTORY (Used by JJ (and potentially other tools) for configuration)
export XDG_CONFIG_HOME=$HOME/.config

# Add IntelliJ to the path
export PATH=$PATH:/Applications/IntelliJ\ IDEA.app/Contents/MacOS

# CONFIGURE THE CLI
## Get git branch
function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}
## Enable colors
CLI_COLOR_DEF=$'%f'
CLI_COLOR_USR=$'%F{243}'
CLI_COLOR_DIR=$'%F{yellow}'
CLI_COLOR_GIT=$'%F{39}'
CLI_NEWLINE_CHARACTER=$'\n'
setopt PROMPT_SUBST
export PROMPT='${CLI_COLOR_USR}%n ${CLI_COLOR_DIR}%~ ${CLI_COLOR_GIT}$(parse_git_branch)${CLI_COLOR_DEF}${CLI_NEWLINE_CHARACTER}$ '

# Aliases
alias k=kubectl
alias nx="npx nx"
alias tsc="npx tsc"

# Keyboard
## Holding a key repeats its value, instead of opening a menu with options (such as adding accents). Might need to restart terminal to apply.
defaults write -g ApplePressAndHoldEnabled -bool false

# Keep at the end: start tmux
if [ -z "$TMUX" ]; then
  tmux attach || tmux new
fi
