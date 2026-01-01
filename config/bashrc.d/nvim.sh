update-nvim() {
	cd ~
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
	tar xzvf nvim-linux-x86_64.tar.gz
	sudo mv nvim-linux-x86_64 /usr/local/neovim
	sudo ln -s /usr/local/neovim/bin/nvim /usr/local/bin/nvim
	nvim --version
}
