return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")

		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		-- Extensible UI for Neovim notifications and LSP progress messages.
		require("fidget").setup({})

		-- Defaults for every LSP server
		vim.lsp.config("*", { capabilities = capabilities })

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					format = {
						enable = true,
						-- NOTE: the value should be STRING!!
						defaultConfig = {
							indent_style = "space",
							indent_size = "2",
						},
					},
				},
			},
		})

		vim.lsp.config("tailwindcss", {
			filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "heex" },
		})

		-- Keep lspconfig's default on_attach: it creates the :LspEslintFixAll command
		local eslint_base_on_attach = vim.lsp.config.eslint.on_attach
		vim.lsp.config("eslint", {
			on_attach = function(client, bufnr)
				if eslint_base_on_attach then
					eslint_base_on_attach(client, bufnr)
				end
				vim.keymap.set("n", "<leader>l", "<cmd>LspEslintFixAll<CR>", { buffer = bufnr })
			end,
		})

		-- TypeScript: TS 7 (native, Go) has no tsserver.js and ships its own LSP (`tsc --lsp`).
		-- Use lspconfig's `tsc` server for TS 7+ projects and `ts_ls` for older ones.
		local function project_ts_major(bufnr)
			local file = vim.api.nvim_buf_get_name(bufnr)
			-- @typescript/native = TS 7 installed next to TS 6 (kept as `typescript` for typescript-eslint)
			for dir in vim.fs.parents(file) do
				local found, major = false, nil
				for _, name in ipairs({ "@typescript/native", "typescript" }) do
					local pkg = vim.fs.joinpath(dir, "node_modules", name, "package.json")
					if vim.uv.fs_stat(pkg) then
						found = true
						local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg), "\n"))
						local v = ok and data.version and vim.version.parse(data.version)
						if v and (not major or v.major > major) then
							major = v.major
						end
					end
				end
				if found then
					return major
				end
			end
		end

		local ts_ls_root_dir = vim.lsp.config.ts_ls.root_dir
		vim.lsp.config("ts_ls", {
			root_dir = function(bufnr, on_dir)
				local major = project_ts_major(bufnr)
				if major and major >= 7 then
					return
				end
				ts_ls_root_dir(bufnr, on_dir)
			end,
		})

		vim.lsp.config("tsc", {
			root_dir = function(bufnr, on_dir)
				local major = project_ts_major(bufnr)
				if not major or major < 7 then
					return
				end
				on_dir(vim.fs.root(bufnr, {
					{ "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" },
					".git",
				}) or vim.fn.getcwd())
			end,
			-- run the project's own TS 7 compiler in LSP mode
			cmd = function(dispatchers, config)
				local bin = vim.fs.joinpath(config.root_dir, "node_modules/.bin/tsc")
				return vim.lsp.rpc.start({ bin, "--lsp", "--stdio" }, dispatchers)
			end,
		})
		-- not a Mason package, so mason-lspconfig does not enable it
		vim.lsp.enable("tsc")

		-- Tools (prettierd, stylua, cspell): install once via :MasonInstall
		require("mason").setup()

		-- Installs servers and calls vim.lsp.enable() for them (automatic_enable)
		require("mason-lspconfig").setup({
			ensure_installed = {
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"eslint",
			},
			-- stylua is used only as a formatter (conform), not as an LSP
			automatic_enable = { exclude = { "stylua" } },
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
				{ name = "path" },
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
		})
	end,
}
