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

export KEYTIMEOUT=1
bindkey -v
bindkey '^F' autosuggest-accept
export EDITOR='nvim'
