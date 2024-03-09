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
alias tmhere='name="$(basename $(pwd))" && tmux new -s "${name//./-}"'
alias tss='tmux switch-client -t $(tmux list-sessions -F "#{session_name}" | fzf --height=~5 --layout=reverse-list)'

# rg file names
alias rgf="fd -t f | rg"

# deactivate python virtual env
alias dea='[ -n "$VIRTUAL_ENV" ] && deactivate'

alias vim="nvim"

# use for single command, withdotfiles <cmd>
alias withdotfiles='GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME'

# toggle dotfile vcs globally
alias dotfiles='export GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME'
alias nodotfiles='unset GIT_DIR GIT_WORK_TREE'

# just some shorthands
alias cnf='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias cnfs='cnf status -unormal'

# heavy duty flaking for code review
alias flakereview="~/.local/bin/flake8 --max-line-length=88 --extend-ignore=E501,E203,U101  --extend-select=B9 --enable-extensions=G --unused-arguments-ignore-variadic-names --unused-arguments-ignore-dunder"


# env
alias envf='env | fzf'

# ssh
alias ssh='TERM=xterm-256color ssh'

alias cdr='grootdir=$(git rev-parse --show-toplevel) && cd $grootdir && pwd'

alias gitfixup='git -c sequence.editor=true rebase -i --autosquash'
