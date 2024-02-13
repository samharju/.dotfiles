SHELL=/bin/bash

nvim_version = v0.9.5

go_checksum = f6c8a87aa03b92c4b0bf3d558e28ea03006eb29db78917daec5cfb6ec1046265
go_version = 1.22.0
go_pkg = go$(go_version).linux-amd64.tar.gz

bat_pkg = bat-musl_0.23.0_amd64.deb

all: apt go nvim .oh-my-zsh .nvm python3.10 thefuck formatters fzf bat docker

.local/bin/nvim:
	@figlet nvim $(nvim_version)
	wget https://github.com/neovim/neovim/releases/download/$(nvim_version)/nvim.appimage
	wget https://github.com/neovim/neovim/releases/download/$(nvim_version)/nvim.appimage.sha256sum
	sha256sum -c nvim.appimage.sha256sum
	rm nvim.appimage.sha256sum
	chmod u+x nvim.appimage
	mv nvim.appimage ~/.local/bin/nvim
	nvim --version
	nvim --headless "+Lazy! sync" +qa

.PHONY: nvim
nvim: .local/bin/nvim

.PHONY: nvim-update
nvim-update:
	rm .local/bin/nvim
	$(MAKE) nvim

.oh-my-zsh: apt
	@figlet oh my zsh
	sh -c $$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)

.nvm:
	@figlet node version manager
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
	nvm install stable


.PHONY: python3.10
python3.10: .pyenv/shims/python3.10

.PHONY: thefuck
thefuck: .local/bin/thefuck

.local/bin/thefuck: python3.10
	pip3 install thefuck --user

.pyenv/shims/python3.10:
	pyenv install 3.10.13




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

.PHONY: apt
apt:
	@[ -n "$$(command -v figlet)" ] && figlet apt || true
	sudo add-apt-repository -y universe
	sudo apt update
	sudo apt install -y curl zip unzip ripgrep shellcheck tmux figlet libfuse2 zsh
	sudo apt autoremove -y


.PHONY: pyenv
pyenv:
	@figlet pyenv
	# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
	sudo apt update
	sudo apt install -y build-essential libssl-dev zlib1g-dev \
		libbz2-dev libreadline-dev libsqlite3-dev curl \
		libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
	sudo apt autoremove -y

.local/bin/fd:
	@figlet fzf
	~/.fzf/install
	sudo apt install fd-find
	ln -s $$(command -v fdfind) ~/.local/bin/fd

.PHONY: fzf
fzf: .local/bin/fd


/usr/bin/bat:
	@figlet bat
	wget "https://github.com/sharkdp/bat/releases/download/v0.23.0/$(bat_pkg)"
	sudo dpkg -i "$(bat_pkg)"

.PHONY: bat
bat: /usr/bin/bat


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

	sudo apt autoremove
