
pj() {
    project=$(fd --ignore-file="$HOME/.fdprojectignore" -H -t d "\.git$" "$HOME" | \
        sed -e 's|/.git$||' -e "s|$HOME/||" | \
        fzf)

    if [ -z "$project" ]; then
        return
    fi

    cd "$HOME/$project" || echo "failed to cd" 
    echo
    zle reset-prompt
}

zle -N pj

bindkey "^[m" pj
