reviewcheckout() {
    cd "$(git rev-parse --show-toplevel)"
    git worktree add --track -b "$1" "$1" "$2"
    echo "$1" >> .git/info/exclude
    cd "$1"
    echo "Created worktree $1 and opened it"
    pwd
}

reviewclean() {
    cd "$(git rev-parse --show-toplevel)"
    git worktree remove "$1"
    sed -i "/$1/d" .git/info/exclude
    git branch -D "$1"
    echo "Cleaned $1"
}
