return {
	"nvim-telescope/telescope.nvim",

	tag = "0.1.5",

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		require("telescope").setup({})
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>fp", builtin.git_files, { desc = "Telescope find git files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope find keymaps" })
	end,
}