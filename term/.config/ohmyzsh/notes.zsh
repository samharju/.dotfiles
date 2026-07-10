
notes ()
{
    set -e
    choice=$(fd -E venv -t f . ~/user/documents/notes | fzf --preview='bat --color=always {}' --preview-window=right:60%)
    if [ -n "$choice" ]; then
        if [ -d "$choice" ]; then
            cd "$choice"
            return
        fi
        sessari=notes
        if ! tmux has-session -t="$sessari" 2> /dev/null; then
            tmux new-session -ds "$sessari" -c "$HOME/user/documents/notes"
        fi

        if [ -z "$TMUX" ]; then
            tmux attach -t "$sessari"
        else
            tmux switch-client -t "$sessari"
        fi
        tmux refresh-client -S

        tmux send-keys -t "$sessari:1" "vim $choice" ENTER
    fi
}
