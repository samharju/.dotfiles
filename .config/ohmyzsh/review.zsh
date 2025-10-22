
worktree-checkout ()
{
    commitish="$1"
    # go to project root to get folder name
    cd "$(git rev-parse --show-toplevel)" || return 1
    project="$(basename "$(pwd)")"
    echo $project

    name="$project-$commitish"
    # create worktree
    new_wt="$HOME/git/worktrees/$name"
    echo $new_wt

    if [ ! -d "$new_wt" ]; then
        git worktree add "$new_wt" "$commitish" || return 1
    fi

    if ! tmux has-session -t="$name" 2> /dev/null; then
        tmux new-session -ds "$name" -c "$new_wt"
    fi

    if [ -z "$TMUX" ]; then
        tmux attach -t "$name"
    else
        tmux switch-client -t "$name"
    fi
    tmux refresh-client -S
}

compdef _git worktree-checkout=git-checkout
