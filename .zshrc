# check .oh-my-zsh/templates/zshrc.zsh-template for removed stuff

export PATH=$HOME/bin\
:$HOME/.local/bin\
:$HOME/go/bin\
:/usr/local/bin\
:/usr/local/go/bin\
:$PATH


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

# tokens and stuff from this guy
[ -f ~/.secrets ] && source ~/.secrets
