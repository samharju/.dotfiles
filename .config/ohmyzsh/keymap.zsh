
gitprojects() {
    project=$(gitprojectfind)

    if [ -z "$project" ]; then
        return
    fi

    cd "$project" || echo "failed to cd"
    echo
    zle reset-prompt
}

zle -N gitprojects


folders() {
    ff=$(folderfind)

    if [ -z "$ff" ]; then
        return
    fi

    cd "$ff" || echo "failed to cd"
    echo
    zle reset-prompt
}

zle -N folders


# alt-m for fuzzy finding git projects
bindkey "^[m" gitprojects

# alt-n for fuzzy finding all folders
bindkey "^[n" folders

