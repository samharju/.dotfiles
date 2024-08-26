#!/usr/bin/zsh
# check .oh-my-zsh/templates/zshrc.zsh-template for removed stuff

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
)

for p in $binpaths; do
    if [[ ! "$PATH" =~ "$p" ]] && [[ -d "$p" ]]; then
        export PATH=$p:$PATH
    fi
done

#-XDG-------------------------------------------------------------------------#
# these are defaults, but need to have them fixed so that source ~/.zshrc cleans
# any modifications
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

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

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

#-nvm-------------------------------------------------------------------------#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#-fzf-------------------------------------------------------------------------#
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND='fd --type d'
export FZF_COMPLETION_TRIGGER=ff

#-pyenv-----------------------------------------------------------------------#
export PYENV_ROOT="$HOME/.pyenv"
if ! [[ "$PATH" =~ "$PYENV_ROOT" ]]; then
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
fi
eval "$(pyenv init -)"

# other parameters------------------------------------------------------------#
export TZ='Europe/Helsinki'
GPG_TTY=$(tty)
export GPG_TTY
export SUDO_EDITOR=/home/sami/.local/bin/nvim

# make ansible print stuff readable by default
export ANSIBLE_STDOUT_CALLBACK=debug

# tokens and stuff from this guy
[ -f ~/.secrets ] && source ~/.secrets

# dotfile sanity check
if [[ -z $(fd --max-depth 1 --type f --hidden --changed-within=12hour .dotfilescheck ~/) ]]; then
    echo "Dotfiles:"
    http_proxy= http_proxy= GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME gitpullneeded
    touch ~/.dotfilescheck
fi

