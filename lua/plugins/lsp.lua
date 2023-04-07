local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')

lsp.preset("recommended")

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
  lsp.buffer_autoformat()
end)

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'rust_analyzer',
})

local cmp_mappings = lsp.defaults.cmp_mappings()

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings,
})

-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})

lsp.format_on_save({
  servers = {
    ['lua_ls'] = {'lua'},
    ['rust_analyzer'] = {'rust'},
    ['eslint'] = {'typescript', 'typescriptreact', 'javascript', 'javascriptreact'},
  }
})

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})