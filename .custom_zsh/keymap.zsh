
pj() {
    projects=$(fd -H -t d "\.git$" "$HOME/git" | sed -e "s/\/\.git$//" )

    selected=$(echo "$projects" | fzf)
    if [ -n "$selected" ]; then
        cd "$selected" || echo "failed to cd" 
        zle reset-prompt
    fi
}

zle -N pj

bindkey "^[m" pj
