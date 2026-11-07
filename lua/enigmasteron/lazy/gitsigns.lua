return {
	"lewis6991/gitsigns.nvim",
	opts = {
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

			-- Navigation
      map("n", "]h", function()
        gs.nav_hunk("next")
      end, "Next Hunk")
      map("n", "[h", function()
        gs.nav_hunk("prev")
      end, "Prev Hunk")

			-- Actions
			map("n", "<leader>hd", gs.diffthis, "Diff this")
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, "Diff this ~")
		end,
	},
}

