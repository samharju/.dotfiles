alias pypath='export PYTHONPATH=$(pwd)'

alias nvimconfig='GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME nvim $HOME/.config/nvim'

eval $(thefuck --alias)

alias l='ls -lah --group-directories-first'
alias la='ls -lAh --group-directories-first'
alias ll='ls -lh --group-directories-first'
alias ls='ls --color=tty --group-directories-first'
alias lsa='ls -lah --group-directories-first'
alias tm='tmux'

alias rgf="rg --files | rg"
