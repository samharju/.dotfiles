
nvimconfig () {

    if [ -z "TMUX" ]; then
        tmux new-session -s nvimconfig 'GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME nvim --cmd "cd $HOME/.config/nvim"'
    else
        tmux new-window -n nvimconfig 'GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME nvim --cmd "cd $HOME/.config/nvim"'
    fi

}
