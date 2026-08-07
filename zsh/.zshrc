autoload -U colors && colors
autoload -U compinit && compinit
autoload -Uz add-zsh-hook

source /usr/share/zsh-antidote/antidote.zsh
antidote load ~/.zsh_plugins.txt

zstyle ':fzf-tab:complete:*' fzf-bindings 'tab:accept'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt GLOB_DOTS
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history
setopt correct
setopt prompt_subst

git_prompt() {
    local branch dirty

    branch=$(git branch --show-current 2>/dev/null) || return
    if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
        dirty="*"
    else
        dirty=""
    fi

    echo "${branch}${dirty}"
}

sync_history() {
    fc -R "$HISTFILE"
}
add-zsh-hook precmd sync_history

PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$reset_color%}\$ "
RPROMPT='%{$fg[magenta]%}$(git_prompt) %{$reset_color%}'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ts='tmux-sessionizer'

git() {
    # color conventional commit types
    if [[ "$1" == "log" ]]; then
        shift
        command git log --color=always "$@" | sed -E \
            -e "s/(^|[[:space:]])feat:/\1\x1b[32mfeat\x1b[0m:/g" \
            -e "s/(^|[[:space:]])fix:/\1\x1b[31mfix\x1b[0m:/g" \
            -e "s/(^|[[:space:]])docs:/\1\x1b[34mdocs\x1b[0m:/g" \
            -e "s/(^|[[:space:]])refactor:/\1\x1b[35mrefactor\x1b[0m:/g" \
            -e "s/(^|[[:space:]])test:/\1\x1b[33mtest\x1b[0m:/g" \
            -e "s/(^|[[:space:]])chore:/\1\x1b[36mchore\x1b[0m:/g" \
            -e "s/(^|[[:space:]])style:/\1\x1b[37mstyle\x1b[0m:/g" \
            -e "s/(^|[[:space:]])perf:/\1\x1b[91mperf\x1b[0m:/g"
    else
        command git "$@"
    fi
}

bindkey -v

bindkey '^F' autosuggest-accept

# tmux support for changing cursor shape based on vi mode
function zle-keymap-select {
    if [[ $KEYMAP == vicmd ]]; then
       printf '\e[2 q'
    else
        printf '\e[6 q'
    fi
} 

function zle-line-init {
    printf '\e[6 q'
}

zle -N zle-keymap-select
zle -N zle-line-init

export PATH="$HOME/.local/bin:$PATH"
export KEYTIMEOUT=1
export EDITOR='nvim'
