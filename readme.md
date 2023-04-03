# dotfiles

init:

```bash
if [[ ! -e .dotfiles ]]; then

    git clone --bare git@github.com:samharju/.dotfiles.git
    config='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
    $config config --local status.showUntrackedFiles no
    $config config --local user.name 'Sami Harju'
    $config config --local user.email sami.harju@gmail.com
    $config checkout
    $config submodule init
    $config submodule update
fi
```
