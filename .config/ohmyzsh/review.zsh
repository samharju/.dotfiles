
worktree-checkout ()
{
    commitish="$1"
    # go to project root to get folder name
    cd "$(git rev-parse --show-toplevel)" || return 1
    project="$(basename "$(pwd)")"

    # create worktree to dump
    new_wt="$HOME/wt-dump/$project/$commitish"

    if [ ! -d "$new_wt" ]; then
        git worktree add "$new_wt" "$commitish"
    fi

    sessari="$project-$commitish"
    if ! tmux has-session -t="$sessari" 2> /dev/null; then
        tmux new-session -ds "$sessari" -c "$new_wt"
    fi

    if [ -z "$TMUX" ]; then
        tmux attach -t "$sessari"
    else
        tmux switch-client -t "$sessari"
    fi
    tmux refresh-client -S
}

compdef _git worktree-checkout=git-checkout
