# dotfiles

May or may not work on your machine, this is mostly just a notebook for myself.

```bash
if [[ ! -e .dotfiles ]]; then
    git clone --bare git@github.com:samharju/.dotfiles.git .dotfiles
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME submodule init
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME submodule update --remote --merge
fi

source ~/.zshrc

dotfilesetup
```
