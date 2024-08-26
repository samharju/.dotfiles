
commitfixup ()
{
    target="$1"
    git commit --fixup="$target"
    git -c sequence.editor=true rebase -i --autosquash "$target"^
}

compdef _git commitfixup=git-checkout
