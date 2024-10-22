return {
	"nvim-telescope/telescope.nvim",

	tag = "0.1.5",

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		require("telescope").setup({})
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>pp", builtin.git_files, { desc = "Telescope find git files" })
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({
				search = vim.fn.input("Grep > "),
				no_ignore = true,
			})
		end)
		vim.keymap.set("n", "<leader>pf", function()
			builtin.find_files({ no_ignore = true })
		end)
	end,
}
