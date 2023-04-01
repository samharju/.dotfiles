# dotfiles

init:

```bash
if [[ ! -e .dotfiles ]]; then

    git clone --bare git@github.com:samharju/dotfiles.git .dotfiles
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local user.name 'Sami Harju'
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local user.email sami.harju@gmail.com
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout

fi
```
