# dotfiles

May or may not work on your machine, this is mostly just a notebook for myself.

```bash
if [[ ! -e .dotfiles ]]; then
    sudo apt install git
    git clone --bare git@github.com:samharju/.dotfiles.git .dotfiles
    git --git-dir=$HOME/.dotfiles config --local core.worktree $HOME
    git --git-dir=$HOME/.dotfiles checkout
    git --git-dir=$HOME/.dotfiles submodule update --init
    git --git-dir=$HOME/.dotfiles remote set-branches origin '*'
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
