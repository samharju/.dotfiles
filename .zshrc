#!/usr/bin/zsh
# check .oh-my-zsh/templates/zshrc.zsh-template for removed stuff

binpaths=$HOME/bin\
:$HOME/.local/bin\
:$HOME/.local/scripts\
:$HOME/go/bin\
:/usr/local/bin\
:/usr/local/go/bin

if ! [[ "$PATH" =~ "$binpaths" ]]; then
    export PATH=$binpaths:$PATH
fi

# ZSH
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM=$HOME/.custom_zsh
ZSH_THEME="sami"
plugins=(
    git
    zsh-autosuggestions
    docker
    python
    golang
)

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# make ansible print stuff readable by default
export ANSIBLE_STDOUT_CALLBACK=debug

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND='fd --type d'
export FZF_COMPLETION_TRIGGER=ff

# tokens and stuff from this guy
[ -f ~/.secrets ] && source ~/.secrets

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


export TZ='Europe/Helsinki'

GPG_TTY=$(tty)
export GPG_TTY

if [[ -z $(fd --max-depth 1 --type f --hidden --changed-within=12hour .dotfilescheck ~/) ]]; then
    echo "Dotfiles:"
    GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME gitpullneeded
    touch ~/.dotfilescheck
fi
