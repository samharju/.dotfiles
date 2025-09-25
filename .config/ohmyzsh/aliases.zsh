# quickly set cwd to pythonpath
alias pypath='[[ -n $PYTHONPATH ]] && export PYTHONPATH="$PYTHONPATH:$(pwd)" || export PYTHONPATH="$(pwd)"'

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



# env
alias envf='env | fzf'

# ssh
alias ssh='TERM=xterm-256color ssh'

alias cdr='grootdir=$(git rev-parse --show-toplevel) && cd $grootdir && pwd'

alias gitfixup='git -c sequence.editor=true rebase -i --autosquash'
alias gloo='git log --oneline --decorate $(git merge-base $(git_main_branch) HEAD)..HEAD'

alias chmox="chmod +x"


alias rm='rm -v'
alias G='git'

alias glor='git log --all --graph --decorate=short --pretty="%C(auto)%h%C(auto)%d %Cgreen%ar %Cblue%<|(50)%an%Creset %s"'

alias dockerpyv='fd Dockerfile -x grep -oP "(?<=python:)[\d\.]+"'


alias cospagetchat='nvim -c "CospagetChat" -c "wincmd o"'

alias forkpointdiff='git diff --name-only --diff-filter=d `git merge-base --fork-point origin/master`..HEAD'

alias gbt='git branch --sort "authordate" --format "%(HEAD) %(align:width=12)%(authordate:short)%(end)%(if)%(HEAD)%(then)%(color:green)%(end)%(align:width=32)%(refname:short)%(end)%(color:reset) %(objectname:short) %(subject)"'
