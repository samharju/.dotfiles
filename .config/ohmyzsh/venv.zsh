
createvenv ()
{
    version="$(pyenv versions --bare | fzf --height 10% --reverse --prompt "Select python version: ")"
    if [ -z "$version" ]; then
        echo "No version selected"
        return 1
    fi
    pyenv shell "$version"
    python -m venv venv
    pyenv shell --unset
    [ -d "venv" ] && echo "venv created" || echo "venv not created"
}
