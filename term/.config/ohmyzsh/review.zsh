worktree-checkout() {
	commitish="$1"
	# go to project root to get folder name
	cd "$(git rev-parse --show-toplevel)" || return 1
	project="$(basename "$(pwd)")"

	# create worktree
	new_wt="$HOME/git/worktrees/$project/$commitish"

	if [ ! -d "$new_wt" ]; then
		git worktree add "$new_wt" "$commitish" || return 1
	fi
	echo "worktree available: $new_wt"

	# session=$(realpath --relative-to="$HOME" "$new_wt")
	#
	# if ! tmux has-session -t="$session" 2>/dev/null; then
	# 	tmux new-session -ds "$session" -c "$new_wt"
	# fi
	#
	# if [ -z "$TMUX" ]; then
	# 	tmux attach -t "$session"
	# else
	# 	tmux switch-client -t "$session"
	# fi
	# tmux refresh-client -S
}

compdef _git worktree-checkout=git-checkout
