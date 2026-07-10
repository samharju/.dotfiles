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
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="$green+$reset"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_DELETED="$red-$reset"
ZSH_THEME_GIT_PROMPT_DIVERGED="$red↯$reset"
ZSH_THEME_GIT_PROMPT_MODIFIED="$red+$reset"
ZSH_THEME_GIT_PROMPT_RENAMED="$red+$reset"
ZSH_THEME_GIT_PROMPT_STASHED="$cyan^$reset"
ZSH_THEME_GIT_PROMPT_UNMERGED="$red↯$reset"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$red.$reset"


from_git_root () {
    local git_root
    git_root=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ $? -eq 0 ]]; then
        local root=$(dirname $git_root)
        echo "${PWD#$root/}"
    else
        echo '%1~'
    fi
    }

local pwd='$green$(from_git_root)$reset'
local prevcmd="%(?.$green➜.$red%?)$reset"
local jobs="%1(j.$magenta%j$reset .)"
local timee="$grey%*$reset"
local git='$(git_prompt_info)$(git_prompt_status)$reset'

PROMPT="${jobs}$grey\$$reset "
RPROMPT="$prevcmd${git} ${pwd} "
