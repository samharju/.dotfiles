
review ()
{
    commitish="$1"
    # go to project root to get folder name
    cd "$(git rev-parse --show-toplevel)" || return 1
    project="$(basename "$(pwd)")"

    # create worktree to dump
    new_wt="$HOME/wt-dump/$project/$commitish"
    git worktree add "$new_wt" "$commitish"

    echo "$new_wt"
    cd "$new_wt"
}

compdef _git review=git-checkout
