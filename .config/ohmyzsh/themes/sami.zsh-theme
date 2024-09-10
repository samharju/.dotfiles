# zsh theme

local green="%{$FG[002]%}"
local red="%{$FG[160]%}"
local cyan="%{$FG[123]%}"
local blue="%{$FG[075]%}"
local magenta="%{$FG[201]%}"
local grey="%{$FG[241]%}"
local reset="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX=" $blue"
ZSH_THEME_GIT_PROMPT_SUFFIX="$reset"
ZSH_THEME_GIT_PROMPT_DIRTY="$red✗$reset"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED=""
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_DELETED=""
ZSH_THEME_GIT_PROMPT_DIVERGED="$red↯$reset"
ZSH_THEME_GIT_PROMPT_MODIFIED=""
ZSH_THEME_GIT_PROMPT_RENAMED=""
ZSH_THEME_GIT_PROMPT_STASHED="$cyan⮥$reset"
ZSH_THEME_GIT_PROMPT_UNMERGED="$red↯$reset"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$red…$reset"

local pwd="$green%1~$reset"
local prevcmd="%(?.$green➜.$red%?)$reset"
local jobs="%1(j.$magenta%j$reset .)"
local timee="$grey%*$reset"
local git='$(git_prompt_info)$(git_prompt_status)'

PROMPT="${prevcmd}${git} ${pwd} ${jobs}$grey\$$reset "
RPROMPT=''
