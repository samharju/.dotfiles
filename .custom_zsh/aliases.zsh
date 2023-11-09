# quickly set cwd to pythonpath
alias pypath='export PYTHONPATH=$(pwd)'

# typo fixing
eval $(thefuck --alias)

# typical bash aliases
alias l='ls -lah --group-directories-first'
alias la='ls -lAh --group-directories-first'
alias ll='ls -lh --group-directories-first'
alias ls='ls --color=tty --group-directories-first'
alias lsa='ls -lah --group-directories-first'


# tmux shortcuts
alias tm='tmux a'
alias tmn='tmux new -s'
alias tmhere='tmux new -s "$(basename $(pwd))"'
alias tss='tmux switch-client -t $(tmux list-sessions -F "#{session_name}" | fzf --height=~5 --layout=reverse-list)'

# rg file names
alias rgf="fd -t f | rg"

# deactivate python virtual env
alias dea='[ -n "$VIRTUAL_ENV" ] && deactivate'

alias vim="nvim"
#
# open neovim config folder as a project
alias nvimconfig='GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME nvim --cmd "cd $HOME/.config/nvim"'

# use for single command, withdotfiles <cmd>
alias withdotfiles='GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME'

# toggle dotfile vcs globally
alias dotfiles='export GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME'
alias nodotfiles='unset GIT_DIR GIT_WORK_TREE'

# just some shorthands
alias cnf='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias cnfs='cnf status -unormal'


