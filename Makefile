SHELL=/bin/bash

nvim_version = v0.11.3

go_checksum = dea9ca38a0b852a74e81c26134671af7c0fbe65d81b0dc1c5bfe22cf7d4c8858
go_version = 1.24.0
go_pkg = go$(go_version).linux-amd64.tar.gz

bat_pkg = bat-musl_0.23.0_amd64.deb

all: apt go nvim ohmyzsh nvm python3.11 thefuck formatters fzf bat docker luarocks tmux ripgrep lsps ansible

terminfo:
	@figlet terminfo
	curl -o ~/tempterminfo https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo
	tic -x -o ~/.terminfo ~/tempterminfo
	rm ~/tempterminfo

nvim: .local/bin/nvim

.ONESHELL:
.local/bin/nvim:
	figlet nvim $(nvim_version)
	cd ~/tooling/neovim
	git checkout $(nvim_version)
	make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/home/sami/.local
	make install
	nvim --version
	nvim --headless "+Lazy! restore" +qa

nvim-update:
	@figlet nvim-update
	rm .local/bin/nvim || true
	$(MAKE) nvim


ohmyzsh: .oh-my-zsh/oh-my-zsh.sh

.oh-my-zsh/oh-my-zsh.sh: apt
	@figlet oh my zsh
	sh -c $$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)


nvm: .nvm/nvm.sh

.nvm/nvm.sh:
	@figlet node version manager
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash


pyenvdeps:
	@figlet pyenvdeps
	# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
	sudo apt update
	sudo apt install -y build-essential libssl-dev zlib1g-dev \
		libbz2-dev libreadline-dev libsqlite3-dev curl \
		libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
	sudo apt autoremove -y

.pyenv/bin/pyenv: pyenvdeps
	@figlet pyenv
	cd .pyenv && git describe

.pyenv/shims/python3.11: .pyenv/bin/pyenv
	@figlet python3.11
	pyenv install 3.11
	pyenv global 3.11

python3.11: .pyenv/shims/python3.11

thefuck: .local/bin/thefuck

.local/bin/thefuck: pipx
	@figlet fuck
	pipx install thefuck


.PHONY: go
go: /usr/local/go/bin/go

go-update:
	@figlet go-update
	@sudo rm /usr/local/go/bin/go
	@$(MAKE) go

$(go_pkg):
	@figlet get go $(go_version)
	wget https://go.dev/dl/$(go_pkg)

/usr/local/go/bin/go: | $(go_pkg)
	@figlet install go $(go_version)
	sha256sum -c <<< "$(go_checksum) $(go_pkg)"
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf $(go_pkg)
	go version


prettier:
	@figlet prettier
	npm i -g prettier
	npm i -g @fsouza/prettierd

.local/bin/stylua:
	@figlet stylua 2.0.2
	wget https://github.com/JohnnyMorganz/StyLua/releases/download/v2.0.2/stylua-linux-x86_64.zip
	unzip stylua-linux-x86_64.zip -d .local/bin
	rm stylua-linux-x86_64.zip


formatters: gotools prettier .local/bin/stylua


gotools: go
	@figlet gotools
	go install github.com/fatih/gomodifytags@latest
	go install github.com/josharian/impl@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/segmentio/golines@latest
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(shell go env GOPATH)/bin v1.64.5
	go install github.com/jesseduffield/lazygit@latest
	go install github.com/go-delve/delve/cmd/dlv@latest

apt:
	@[ -n "$$(command -v figlet)" ] && figlet apt || true
	sudo add-apt-repository -y universe
	sudo apt update
	sudo apt install -y curl zip unzip shellcheck figlet libfuse2 zsh
	sudo apt autoremove -y

ripgrep: /usr/bin/rg

/usr/bin/rg:
	@figlet ripgrep 14.1.0
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
	sudo dpkg -i ripgrep_14.1.0-1_amd64.deb

tmux: /usr/local/bin/tmux

/usr/local/bin/tmux:
	@figlet tmux 3.5a
	sudo apt install libevent-dev ncurses-dev build-essential bison pkg-config automake
	git clone https://github.com/tmux/tmux.git ~/git/tmux || true
	cd ~/git/tmux; git checkout 3.5a; sh autogen.sh; ./configure; make && sudo make install


fzf: .local/bin/fd

.local/bin/fd:
	@figlet fzf
	~/.fzf/install
	sudo apt install fd-find
	ln -s $$(command -v fdfind) ~/.local/bin/fd

bat: /usr/bin/bat

/usr/bin/bat:
	@figlet bat
	wget "https://github.com/sharkdp/bat/releases/download/v0.23.0/$(bat_pkg)"
	sudo dpkg -i "$(bat_pkg)"


docker:
	@figlet docker
	sudo apt update

	sudo apt remove -y docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc || true

	@figlet docker apt

	sudo apt install -y ca-certificates curl gnupg
	sudo mkdir -m 0755 -p /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	echo \
		"deb [arch=$(shell dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
		$(shell . /etc/os-release && echo "$$VERSION_CODENAME") stable" | \
		sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	sudo apt update

	@figlet docker install

	sudo apt install \
	    docker-ce \
	    docker-ce-cli \
	    containerd.io \
	    docker-buildx-plugin \
	    docker-compose-plugin

	sudo apt autoremove -y

	sudo usermod -aG docker sami
	sudo systemctl enable docker
	sudo systemctl start docker


nlua: /bin/luarocks .luarocks/bin/nlua

pipx: .local/bin/pipx

.local/bin/pipx:
	@figlet pipx
	python -m pip install --user pipx
	pipx ensurepath

/bin/luarocks:
	@figlet luarocks
	sudo apt install luarocks
	sudo apt autoremove -y

.luarocks/bin/nlua:
	@figlet nlua
	luarocks --local install nlua
	echo "print(1+2)"| nlua
	luarocks config lua_version 5.1
	luarocks config lua_interpreter nlua
	luarocks config variables.LUA_INCDIR /usr/include/luajit-2.1

busted: .luarocks/bin/busted

.luarocks/bin/busted:
	@figlet busted
	luarocks --local install busted
	busted --version

ansible:
	pipx install --include-deps ansible

# language servers etc

lsps: basedpyright bashls gopls luals dockerls composels treesittercli ansiblels

basedpyright: pipx
	@figlet basedpyright
	pipx install --force basedpyright==1.31.0

bashls:
	@figlet bashls
	npm i -g bash-language-server

gopls:
	@figlet gopls
	go install golang.org/x/tools/gopls@latest

luals: .local/bin/lua-language-server

.local/bin/lua-language-server:
	@figlet luals 3.13.6
	wget https://github.com/LuaLS/lua-language-server/releases/download/3.13.6/lua-language-server-3.13.6-linux-x64.tar.gz
	mkdir -p .local/share/nvim/luals
	tar -xf lua-language-server-3.13.6-linux-x64.tar.gz -C .local/share/nvim/luals
	ln -s .local/share/nvim/luals/bin/lua-language-server .local/bin/lua-language-server
	rm lua-language-server-3.13.6-linux-x64.tar.gz

dockerls:
	@figlet dockerls
	npm i -g dockerfile-language-server-nodejs


composels:
	@figlet composels
	npm i -g @microsoft/compose-language-service

treesittercli:
	@figlet tree-sitter-cli
	npm i -g tree-sitter-cli

ansiblels:
	@figlet ansiblels
	npm i -g @ansible/ansible-language-server


# linters

linters: .local/bin/hadolint .local/bin/ansible-lint

.local/bin/hadolint:
	@figlet hadolint
	wget https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64
	mv hadolint-Linux-x86_64 .local/bin/hadolint
	chmod +x .local/bin/hadolint

.local/bin/ansible-lint:
	@figlet ansible-lint
	pipx install ansible-lint

