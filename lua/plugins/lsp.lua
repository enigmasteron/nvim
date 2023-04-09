local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")

lsp.preset("recommended")

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({ buffer = bufnr })
end)

lsp.ensure_installed({
	"tsserver",
	"eslint",
	"rust_analyzer",
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings["<Tab>"] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
	mapping = cmp_mappings,
})

lsp.format_on_save({
	servers = {
		["null-ls"] = { "javascript", "typescript", "lua" },
	},
})

lsp.setup()

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.eslint_d.with({
			condition = function(utils)
				return utils.root_has_file(".eslintrc.json")
			end,
		}),
	},
})

require("mason-null-ls").setup({
	ensure_installed = {
		"stylua",
		"prettier",
		"eslint_d",
	},
	automatic_installation = true,
	automatic_setup = false,
})
