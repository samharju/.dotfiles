
pj() {
    project=$(gitprojectfind)

    if [ -z "$project" ]; then
        return
    fi

    cd "$project" || echo "failed to cd"
    echo
    zle reset-prompt
}

zle -N pj

bindkey "^[m" pj
