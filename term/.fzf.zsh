# Setup fzf
# ---------
if [[ ! "$PATH" == */home/sharju/tooling/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/sharju/tooling/fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/sharju/tooling/fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/home/sharju/tooling/fzf/shell/key-bindings.zsh"
