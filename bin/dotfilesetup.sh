#!/usr/bin/env bash

install_zsh() {
    if ! command -v zsh; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    echo "zsh ok"
}

install_nvim() {
    wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
    sudo apt install ./nvim-linux64.deb
    rm nvim-linux64.deb

    sudo npm i -g prettier
}

install_utils() {
    sudo apt update
    sudo apt install \
        zip \
        unzip \
        ripgrep \
        shellcheck \
        tmux

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
}

install_fuck() {
    sudo apt install python3-dev python3-pip python3-setuptools
    pip3 install --upgrade pip
    pip3 install thefuck --user
}

install_python() {
    sudo apt install software-properties-common 
    sudo add-apt-repository ppa:deadsnakes/ppa 
    sudo apt update
    sudo apt install python3.10 python3.10-venv python3-pip python3.10-dev
}

if [[ $# -eq 0 ]]; then
    echo "zsh nvim py utils fuck"
fi

while test $# -gt 0
do 
    case "$1" in 
        zsh)
            install_zsh
            ;;
        nvim)
            install_nvim
            ;;
        py)
            install_python
            ;;
        utils)
            install_utils
            ;;
        fuck)
            install_fuck
            ;;
        *)
            echo "invalid command: $1"
            ;;
    esac
    shift
done

