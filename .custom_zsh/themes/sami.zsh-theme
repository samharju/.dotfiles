# zsh theme

local green="%{$FG[002]%}"
local red="%{$FG[160]%}"
local cyan="%{$FG[123]%}"
local blue="%{$FG[075]%}"
local magenta="%{$FG[201]%}"
local grey="%{$FG[241]%}"
local reset="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=" $blue("
ZSH_THEME_GIT_PROMPT_SUFFIX="$blue)"
ZSH_THEME_GIT_PROMPT_DIRTY="$red✗"
ZSH_THEME_GIT_PROMPT_CLEAN="$green✔"

ZSH_THEME_GIT_PROMPT_STASHED="${cyan}^"
ZSH_THEME_GIT_PROMPT_UNTRACKED=""
ZSH_THEME_GIT_PROMPT_MODIFIED=""
ZSH_THEME_GIT_PROMPT_DELETED=""
ZSH_THEME_GIT_PROMPT_RENAMED=""
ZSH_THEME_GIT_PROMPT_ADDED=""

local pwd="$green%1~$reset"
local prevcmd="%(?.$green➜.$red%?)"
local jobs="%1(j.$magenta{%j}$reset .)"
local timee="${grey}%*$reset"

PROMPT='${prevcmd} ${timee}$(git_prompt_info)${reset}$(git_prompt_status)${reset} ${pwd} ${jobs}$ '
RPROMPT=''
