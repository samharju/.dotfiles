#!/usr/bin/env zsh


_dirty_git_projects() {
    projects="$(fd -u .git$ ~/git | sed -re 's|/.git/?$||' )"

    {
        for project in ${(f)projects}; do
            if [[ "$(cd $project; git status -s | wc -l)" != 0 ]];then
                echo "$project"
            fi
        done
    } 2> /dev/null
}


dirty() {
    t="$(_dirty_git_projects | fzf --preview='cd {}; git -c color.status=always status')"
    [[ -n "$t" ]] && cd "$t" || return 1
    git status
}
