
notes ()
{
    choice=$(fd -E venv . ~/notes | fzf --preview='bat --color=always {}' --preview-window=right:60%)
    if [ -n "$choice" ]; then
        if [ -d "$choice" ]; then
            cd "$choice"
            return
        fi
        cd ~/notes
        echo "cwd changed"
        nvim "$choice"
    fi
}
