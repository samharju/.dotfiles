alias pypath='export PYTHONPATH=$(pwd)'

eval $(thefuck --alias)

alias l='ls -lah --group-directories-first'
alias la='ls -lAh --group-directories-first'
alias ll='ls -lh --group-directories-first'
alias ls='ls --color=tty --group-directories-first'
alias lsa='ls -lah --group-directories-first'
alias tm='tmux a'
alias tmn='tmux new -s'
alias tmhere='tmux new -s $(basename $(pwd))'

alias rgf="fd -t f | rg"
alias dea="deactivate"

alias tss='tmux switch-client -t $(tmux list-sessions -F "#{session_name}" | fzf --height=~5 --layout=reverse-list)'

alias vim="nvim"

