#!/usr/bin/zsh
# check .oh-my-zsh/templates/zshrc.zsh-template for removed stuff
export TERM=wezterm
#-path------------------------------------------------------------------------#
# add existing binary folders to path if not present
binpaths=(
    "$HOME/.luarocks/bin"
    "/usr/local/go/bin"
    "/usr/local/bin"
    "$HOME/go/bin"
    "$HOME/.local/scripts"
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.local/share/zig"
)

for p in $binpaths; do
    if [[ ! "$PATH" =~ "$p" ]] && [[ -d "$p" ]]; then
        export PATH=$p:$PATH
    fi
done

loaded=0

log() {
    if [[ $loaded = 1 ]]; then
        echo -e "\e[1;30m$@\e[0m"
    fi
}

if [[ -z $(fd --max-depth 1 --type f --hidden --changed-within=12hour .loaded ~/) ]]; then
    loaded=1
    touch ~/.loaded
fi

log PATH="$PATH"
#-XDG-------------------------------------------------------------------------#
# these are defaults, but need to have them fixed so that source ~/.zshrc cleans
# any modifications
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

log XDG_CONFIG_HOME=$XDG_CONFIG_HOME
log XDG_CACHE_HOME=$XDG_CACHE_HOME
log XDG_DATA_HOME=$XDG_DATA_HOME
log XDG_STATE_HOME=$XDG_STATE_HOME
#-ZSH-------------------------------------------------------------------------#
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM=$XDG_CONFIG_HOME/ohmyzsh
ZSH_THEME="sami"
plugins=(
    git
    zsh-autosuggestions
    docker
    python
    golang
)
source $ZSH/oh-my-zsh.sh
log oh-my-zsh: loaded

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

source $ZSH_CUSTOM/plugins/zsh-histdb/sqlite-history.zsh
autoload -Uz add-zsh-hook

_zsh_autosuggest_strategy_histdb_top_here() {
    local query="select commands.argv from
history left join commands on history.command_id = commands.rowid
left join places on history.place_id = places.rowid
where places.dir LIKE '$(sql_escape $PWD)%'
and commands.argv LIKE '$(sql_escape $1)%'
group by commands.argv order by count(*) desc limit 1"
    suggestion=$(_histdb_query "$query")
}

ZSH_AUTOSUGGEST_STRATEGY=histdb_top_here

log ZSH=$ZSH
log ZSH_CUSTOM=$ZSH_CUSTOM
#-nvm-------------------------------------------------------------------------#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

log NVM_DIR=$NVM_DIR
#-fzf-------------------------------------------------------------------------#
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_ALT_C_OPTS=" --walker-skip .git,venv,node_modules --preview 'tree -C {}'"
export FZF_COMPLETION_TRIGGER=ff

log FZF_ALT_C_OPTS=$FZF_ALT_C_OPTS
log FZF_COMPLETION_TRIGGER=$FZF_COMPLETION_TRIGGER
#-pyenv-----------------------------------------------------------------------#
export PYENV_ROOT="$HOME/.pyenv"
if ! [[ "$PATH" =~ "$PYENV_ROOT" ]]; then
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
fi
eval "$(pyenv init -)"

log PYENV_ROOT=$PYENV_ROOT
#-other-parameters------------------------------------------------------------#
export TZ='Europe/Helsinki'
GPG_TTY=$(tty)
export GPG_TTY
export SUDO_EDITOR=/home/sami/.local/bin/nvim
export EDITOR=/home/sami/.local/bin/nvim
log TZ=$TZ
log GPG_TTY=$GPG_TTY
log SUDO_EDITOR=$SUDO_EDITOR

eval "$(direnv hook zsh)"

# make ansible print stuff readable by default
export ANSIBLE_STDOUT_CALLBACK=unixy
log ANSIBLE_STDOUT_CALLBACK=$ANSIBLE_STDOUT_CALLBACK

# tokens and stuff from this guy
[ -f ~/.secrets ] && source ~/.secrets

if ! ping -c 1 -W 0.5 "$proxy" &> /dev/null; then
    unset http_proxy https_proxy
fi

# dotfile sanity check
if [[ -z $(fd --max-depth 1 --type f --hidden --changed-within=12hour .dotfilescheck ~/) ]]; then
    GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME gitpullneeded
    touch ~/.dotfilescheck
fi

