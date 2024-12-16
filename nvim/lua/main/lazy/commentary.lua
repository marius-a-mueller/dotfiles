return {
	"tpope/vim-commentary",
	config = function()
		-- set comment string for alloy files
		vim.cmd([[
          autocmd FileType alloy setlocal commentstring=//\ %s
        ]])
	end,
}
