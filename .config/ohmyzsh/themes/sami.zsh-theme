#!/usr/bin/env zsh

local green="%{$FG[002]%}"
local red="%{$FG[160]%}"
local cyan="%{$FG[123]%}"
local blue="%{$FG[075]%}"
local magenta="%{$FG[201]%}"
local grey="%{$FG[241]%}"
local reset="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=" $blue"
ZSH_THEME_GIT_PROMPT_SUFFIX="$reset"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN="$green✓"

ZSH_THEME_GIT_PROMPT_ADDED="$green+$reset"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_DELETED="$red-$reset"
ZSH_THEME_GIT_PROMPT_DIVERGED="$red↯$reset"
ZSH_THEME_GIT_PROMPT_MODIFIED="$red+$reset"
ZSH_THEME_GIT_PROMPT_RENAMED="$green $reset"
ZSH_THEME_GIT_PROMPT_STASHED="${cyan} ${reset}"
ZSH_THEME_GIT_PROMPT_UNMERGED="$red↯$reset"
ZSH_THEME_GIT_PROMPT_UNTRACKED="${red}_${reset}"

from_git_root() {
    local git_root
    git_root=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ $? -eq 0 ]]; then
        local root=$(dirname $git_root)
        echo "${PWD#$root/}"
    else
        echo '%1~'
    fi
}

project() {
    git_root=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ $? -eq 0 ]]; then
        echo " ${cyan}$(basename $git_root)"
    fi
}

wip() {
    if git log -1 --pretty=%B 2> /dev/null | rg -qi wip; then
        echo "${green}-󰲼 "
    fi
}

noprojectroot() {
    git_root=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ "$git_root" != "$PWD" ]] ; then
        echo " $green%1~$reset"
    fi
}

local prevcmd="%(?.$green➜.$red%?)$reset"
local jobs="%1(j.$magenta%j$reset .)"
local timee="$grey%*$reset"
local git='$(project)$(git_prompt_info)$(git_prompt_status)$(wip)$reset'
local pwd='$(noprojectroot)'

PROMPT="$prevcmd${git}$pwd ${jobs}$grey\$$reset "
RPROMPT=''
