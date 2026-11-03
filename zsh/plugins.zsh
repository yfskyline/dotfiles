# zplug plugin declarations shared by shell startup and setup
# Diagnose registration failures at the specific plugin, not merely at source time.
_zplug_register() {
    # zplug mistakes pipe-backed stdin for its deprecated pipe syntax in CI/LXD.
    # Registration never needs input, so make it a normal non-pipe file descriptor.
    if ! zplug "$@" </dev/null; then
        print -u2 -- "ERROR: zplug registration failed: $1"
        return 1
    fi
}
_zplug_register 'zplug/zplug', hook-build:'zplug --self-manage' || return 1
_zplug_register "mafredri/zsh-async"                     || return 1 # asynchronous processing
_zplug_register "zsh-users/zsh-syntax-highlighting"      || return 1 # Syntax Highlight
_zplug_register "zsh-users/zsh-autosuggestions"          || return 1 # command-suggestion referring history
_zplug_register "zsh-users/zsh-completions"              || return 1 # zplug completions
_zplug_register "chrissicool/zsh-256color"               || return 1 # zplug 256-color
_zplug_register "zsh-users/zsh-history-substring-search" || return 1 # zplug history-substring search
unfunction _zplug_register
