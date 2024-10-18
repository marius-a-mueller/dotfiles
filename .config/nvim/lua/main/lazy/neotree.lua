return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},

	config = function()
		require("neo-tree").setup({
			window = {
				mappings = {
					["e"] = function()
						vim.api.nvim_exec("Neotree focus filesystem left", true)
					end,
					["b"] = function()
						vim.api.nvim_exec("Neotree focus buffers left", true)
					end,
					["g"] = function()
						vim.api.nvim_exec("Neotree focus git_status left", true)
					end,
				},
			},
			event_handlers = {
				{
					event = "file_open_requested",
					handler = function()
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		})
		vim.keymap.set("n", "<leader>nq", ":Neotree close<cr>")
		vim.keymap.set("n", "<leader>nn", ":Neotree toggle<cr>")
		vim.keymap.set("n", "<leader>ng", ":Neotree toggle git_status<cr>")
		vim.keymap.set("n", "<leader>nb", ":Neotree toggle buffers<cr>")
	end,
}
-- return {
-- 	{
-- 		"preservim/nerdtree",
-- 		config = function()
-- 			vim.keymap.set("n", "<leader>n", ":nerdtree<cr>")
-- 			vim.keymap.set("n", "<c-n>", ":nerdtree<cr>")
-- 			vim.keymap.set("n", "<c-t>", ":nerdtreetoggle<cr>")
-- 			vim.keymap.set("n", "<c-f>", ":nerdtreefind<cr>")
-- 		end,
-- 	},
-- 	{
-- 		"ryanoasis/vim-devicons",
-- 	},
-- 	{
-- 		"Xuyuanp/nerdtree-git-plugin",
-- 	},
-- }
