# dotfiles

May or may not work on your machine, this is mostly just a notebook for myself.

```bash
if [[ ! -e .dotfiles ]]; then
    git clone --bare git@github.com:samharju/.dotfiles.git .dotfiles
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME submodule update --init
fi

sudo apt install make
make ohmyzsh
mv .zshrc.pre-oh-my-zsh .zshrc
make nvm
source ~/.zshrc

nvm install stable
nvm use stable

make

```
