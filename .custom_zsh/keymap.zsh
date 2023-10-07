
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


bindkey "^[m" gitprojects
bindkey "^[n" folders

