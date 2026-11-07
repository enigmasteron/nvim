# nvim settings

Neovim 0.12+ config with [lazy.nvim](https://github.com/folke/lazy.nvim). Leader is `Space`.

## Terminal

macOS Terminal.app, font OperatorMono Medium 18 (see `fonts/`).
For `Alt`/`Option` keymaps enable *Settings → Profiles → Keyboard → Use Option as Meta key*.

## Language servers and tools

Installed by Mason (`:Mason`), nothing global is needed:
html, cssls, tailwindcss, lua_ls, eslint, ts_ls, prettier/prettierd, stylua, cspell.

TypeScript 7 projects (no `tsserver.js`) use the project's own `tsc --lsp`
(lspconfig `tsc` server) instead of `ts_ls`.

## Keys

| Key | Action |
| --- | --- |
| `Space p f` / `Ctrl-p` | find files / git files (Telescope) |
| `gd`, `K` | go to definition, hover |
| `Space r n`, `Space v c a`, `Space v r r` | rename, code action, references |
| `]d` / `[d`, `Space e` | next / prev diagnostic, show diagnostic |
| `Space f` | format (conform, also on save) |
| `Space l` | eslint fix all |
| `]h` / `[h`, `Space h d` | next / prev git hunk, diff |
| `Ctrl-Space`, `Ctrl-n`/`Ctrl-p`, `Ctrl-y` | open completion, select, accept |
| visual `J` / `K` | move selected lines down / up |

## Updating

```
:Lazy sync      plugins
:MasonUpdate    then U in :Mason — servers and formatters
:TSUpdate       treesitter parsers
```
`brew upgrade neovim` for Neovim itself.
