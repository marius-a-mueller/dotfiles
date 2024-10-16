return {
    {
        "preservim/nerdtree",
        config = function()
            vim.keymap.set("n", "<leader>n", ':NERDTree<CR>')
            vim.keymap.set("n", '<C-n>', ':NERDTree<CR>')
            vim.keymap.set("n", '<C-t>', ':NERDTreeToggle<CR>')
            vim.keymap.set("n", '<C-f>', ':NERDTreeFind<CR>')
        end
    },
    {
        "ryanoasis/vim-devicons"
    },
    {
        "Xuyuanp/nerdtree-git-plugin"
    }
}
