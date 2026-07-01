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
## Get VCS pointer (jj or git)
function get_vcs_pointer() {
    if [[ -d .jj ]]; then
        local jj_id
        jj_id=$(jj log -r @ --no-graph --ignore-working-copy --template 'change_id.short()' 2>/dev/null) || jj_id="err"
        echo "jj [$jj_id]"
        return
    fi

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        local ref
        ref=$(git branch --show-current 2>/dev/null)
        if [[ -n "$ref" ]]; then
            echo "git [$ref]"
        else
            echo "git [$(git rev-parse --short HEAD 2>/dev/null)]"
        fi
        return
    fi

    echo "[no_vcs]"
}
## Enable colors
CLI_COLOR_DEF=$'%f'
CLI_COLOR_USR=$'%F{243}'
CLI_COLOR_DIR=$'%F{yellow}'
CLI_COLOR_GIT=$'%F{39}'
CLI_NEWLINE_CHARACTER=$'\n'
setopt PROMPT_SUBST
export PROMPT='${CLI_COLOR_USR}%n ${CLI_COLOR_DIR}%~ ${CLI_COLOR_GIT}$(get_vcs_pointer)${CLI_COLOR_DEF}${CLI_NEWLINE_CHARACTER}$ '

# Aliases
alias k=kubectl
alias nx="pnpm exec nx"
alias forge="pnpm exec forge"
alias tsc="pnpm exec tsc"

# Keyboard
## Holding a key repeats its value, instead of opening a menu with options (such as adding accents). Might need to restart terminal to apply.
defaults write -g ApplePressAndHoldEnabled -bool false

# FZF (fuzzy search)
## Set up fzf key bindings and fuzzy completion
### C-r: enhanced reverse command search
### C-t: looks for files, and pastes their path when chosen
### **: appending '**' to commands like vim, ssh, cd, ssh, kill, etc AND then tabbing allows to fuzzy-find files or directories
source <(fzf --zsh)
## Commands enhanced with fuzzy search
alias cdf="cd \$(find * -type d | fzf)" # Might be easier than 'cd **<tab>'

# Keep at the end: start tmux
# if [ -z "$TMUX" ]; then
#   tmux attach || tmux new
# fi
