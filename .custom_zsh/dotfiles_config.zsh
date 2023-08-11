
alias nvimconfig='GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME nvim $HOME/.config/nvim'

alias withdotfiles='GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME'

alias dotfiles='export GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME'
alias nodotfiles='unset GIT_DIR GIT_WORK_TREE'

alias cnf='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias cnfs='cnf status -unormal'

