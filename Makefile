SHELL=/bin/bash

nvim_version = v0.10.0

go_checksum = f6c8a87aa03b92c4b0bf3d558e28ea03006eb29db78917daec5cfb6ec1046265
go_version = 1.22.0
go_pkg = go$(go_version).linux-amd64.tar.gz

bat_pkg = bat-musl_0.23.0_amd64.deb

all: apt go nvim ohmyzsh nvm python3.10 thefuck formatters fzf bat docker luarocks tmux ripgrep

.PHONY: nvim
nvim: .local/bin/nvim

.local/bin/nvim:
	@figlet nvim $(nvim_version)
	wget https://github.com/neovim/neovim/releases/download/$(nvim_version)/nvim.appimage
	wget https://github.com/neovim/neovim/releases/download/$(nvim_version)/nvim.appimage.sha256sum
	sha256sum -c nvim.appimage.sha256sum
	rm nvim.appimage.sha256sum
	chmod u+x nvim.appimage
	mkdir -p ~/.local/bin
	mv nvim.appimage ~/.local/bin/nvim
	nvim --version
	nvim --headless "+Lazy! sync" +qa

.PHONY: nvim-update
nvim-update:
	rm .local/bin/nvim
	$(MAKE) nvim


.PHONY: ohmyzsh
ohmyzsh: .oh-my-zsh/oh-my-zsh.sh

.oh-my-zsh/oh-my-zsh.sh: apt
	@figlet oh my zsh
	sh -c $$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)


.PHONY:
nvm: .nvm/nvm.sh

.nvm/nvm.sh:
	@figlet node version manager
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash


.pyenv/bin/pyenv:
	@figlet pyenv
	# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
	sudo apt update
	sudo apt install -y build-essential libssl-dev zlib1g-dev \
		libbz2-dev libreadline-dev libsqlite3-dev curl \
		libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
	sudo apt autoremove -y

.pyenv/shims/python3.10: .pyenv/bin/pyenv
	@figlet python3.10
	pyenv install 3.10.13
	pyenv global 3.10.13

.PHONY: python3.10
python3.10: .pyenv/shims/python3.10

.PHONY: thefuck
thefuck: .local/bin/thefuck

.local/bin/thefuck: python3.10
	@figlet fuck
	pip3 install thefuck --user


.PHONY: go
go: /usr/local/go/bin/go

.PHONY: go-update
go-update:
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


.PHONY: prettier
prettier:
	@figlet prettier
	npm i -g prettier
	npm i -g @fsouza/prettierd


.PHONY: formatters
formatters: gotools prettier


.PHONY: gotools
gotools: go
	@figlet gotools
	go install github.com/fatih/gomodifytags@latest
	go install github.com/josharian/impl@latest
	go install golang.org/x/tools/cmd/goimports@latest
	go install github.com/segmentio/golines@latest
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(shell go env GOPATH)/bin v1.55.2
	go install github.com/jesseduffield/lazygit@latest
	go install github.com/go-delve/delve/cmd/dlv@latest

.PHONY: apt
apt:
	@[ -n "$$(command -v figlet)" ] && figlet apt || true
	sudo add-apt-repository -y universe
	sudo apt update
	sudo apt install -y curl zip unzip shellcheck figlet libfuse2 zsh
	sudo apt autoremove -y

.PHONY: ripgrep
ripgrep: /usr/bin/rg

/usr/bin/rg:
	@figlet ripgrep 14.1.0
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
	sudo dpkg -i ripgrep_14.1.0-1_amd64.deb

.PHONY: tmux
tmux: /usr/local/bin/tmux

/usr/local/bin/tmux:
	@figlet tmux 3.4
	sudo apt install libevent-dev ncurses-dev build-essential bison pkg-config
	git clone https://github.com/tmux/tmux.git ~/git/tmux
	cd ~/git/tmux; git checkout 3.4; sh autogen.sh; ./configure; make && sudo make install


.PHONY: fzf
fzf: .local/bin/fd

.local/bin/fd:
	@figlet fzf
	~/.fzf/install
	sudo apt install fd-find
	ln -s $$(command -v fdfind) ~/.local/bin/fd

.PHONY: bat
bat: /usr/bin/bat

/usr/bin/bat:
	@figlet bat
	wget "https://github.com/sharkdp/bat/releases/download/v0.23.0/$(bat_pkg)"
	sudo dpkg -i "$(bat_pkg)"


.PHONY: docker
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


.PHONY: nlua
nlua: /bin/luarocks .luarocks/bin/nlua


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

.PHONY: busted
busted: .luarocks/bin/busted

.luarocks/bin/busted:
	@figlet busted
	luarocks --local install busted
	busted --version
