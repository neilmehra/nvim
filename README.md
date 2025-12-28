# nvim

A minimal neovim config curated for my workflow.

![](https://i.imgur.com/AbwVbZz.png)

![](https://i.imgur.com/5rHVL4e.png)

## Requirements
I use neovim v0.10.3, other versions may/may not work.

- npm for LSP installation
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- a [nerd font](https://github.com/ryanoasis/nerd-fonts)
- [rust-analyzer](https://rust-analyzer.github.io/)
- sqlite3 for [time-tracker.nvim](https://github.com/3rd/time-tracker.nvim)
- pandoc
- texlive

- turtle lsp
- sparql lsp
- oxigraph


## Install
Clone this under your ~/.config/nvim directory

```
git clone https://github.com/neilmehra/nvim.git ~/.config/nvim
```


For my notes setup

```

sudo npm i -g turtle-language-server sparql-language-server
cargo install oxigraph-cli --locked
mkdir -p kb/{.oxigraph,assets,bin,build,kg,notes,queries,templates,update,kg/assets,kg/notes}

```

Start the oxigraph server
```
oxigraph serve --location kb/.oxigraph --bind 127.0.0.1:7878
```
