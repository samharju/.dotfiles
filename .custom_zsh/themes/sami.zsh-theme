# zsh theme

local green="%{$fg_bold[green]%}"
local red="%{$fg_bold[red]%}"
local cyan="%{$fg_bold[cyan]%}"
local yellow="%{$fg_bold[yellow]%}"
local blue="%{$fg_bold[blue]%}"
local magenta="%{$fg_bold[magenta]%}"
local grey="%{$fg_bold[grey]%}"
local reset="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=" $blue("
ZSH_THEME_GIT_PROMPT_SUFFIX="$blue)"
ZSH_THEME_GIT_PROMPT_DIRTY=" $red✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" $green✔"

ZSH_THEME_GIT_PROMPT_UNTRACKED=""
ZSH_THEME_GIT_PROMPT_MODIFIED=""
ZSH_THEME_GIT_PROMPT_DELETED=""
ZSH_THEME_GIT_PROMPT_RENAMED=""
ZSH_THEME_GIT_PROMPT_ADDED=""
ZSH_THEME_GIT_PROMPT_STASHED="${cyan}-s-${reset}"

local pwd="$green%1~$reset"
local prevcmd="%(?.$green➜.$red%?)"
local jobs="$magenta{bg: %j}$reset"
local timee="${grey}%*$reset"
PROMPT='[$timee]$reset ${prevcmd} ${pwd}$(git_prompt_info)$reset$(git_prompt_status)%1(j. $jobs.) $ '
RPROMPT=''


