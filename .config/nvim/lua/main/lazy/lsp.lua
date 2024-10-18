local Path = require('plenary.path')

return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v4.x",
        lazy = true,
        config = false,
    },
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = true,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
            })
        end,
    },

    -- Formatter
    {
        "mhartington/formatter.nvim",
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local prettierConfig = function(ext)
                return function()
                    local prettier = Path:new('.')
                        :find_upwards('node_modules')
                        :find_upwards('.bin')
                        :find_upwards('prettier')
                        :absolute()

                    if not prettier then
                        return null
                    end

                    return {
                        exe = prettier,
                        args = {
                            '--stdin-filepath',
                            vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
                        },
                        stdin = true,
                    }
                end
            end
            -- Utilities for creating configurations
            local util = require("formatter.util")

            -- Format on save
            local augroup = vim.api.nvim_create_augroup
            local autocmd = vim.api.nvim_create_autocmd
            augroup("__formatter__", { clear = true })
            autocmd("BufWritePost", {
                group = "__formatter__",
                command = ":FormatWrite",
            })

            vim.keymap.set('n', '<leader>f', ':LspZeroFormat<CR>')

            -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
            require("formatter").setup({
                -- Enable or disable logging
                logging = true,
                -- Set the log level
                log_level = vim.log.levels.WARN,
                -- All formatter configurations are opt-in
                filetype = {
                    typescript = { prettierConfig('ts') },
                    -- Formatter configurations for filetype "lua" go here
                    -- and will be executed in order
                    lua = {
                        -- "formatter.filetypes.lua" defines default configurations for the
                        -- "lua" filetype
                        require("formatter.filetypes.lua").stylua,

                        -- You can also define your own configuration
                        function()
                            -- Supports conditional formatting
                            if util.get_current_buffer_file_name() == "special.lua" then
                                return nil
                            end

                            -- Full specification of configurations is down below and in Vim help
                            -- files
                            return {
                                exe = "stylua",
                                args = {
                                    "--search-parent-directories",
                                    "--stdin-filepath",
                                    util.escape_path(util.get_current_buffer_file_path()),
                                    "--",
                                    "-",
                                },
                                stdin = true,
                            }
                        end,
                    },

                    -- Use the special "*" filetype for defining formatter configurations on
                    -- any filetype
                    ["*"] = {
                        -- "formatter.filetypes.any" defines default configurations for any
                        -- filetype
                        require("formatter.filetypes.any").remove_trailing_whitespace,

                        -- Remove trailing whitespace without 'sed'
                        -- require("formatter.filetypes.any").substitute_trailing_whitespace,
                    },
                },
            })
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
        },
        config = function()
            local lsp_zero = require("lsp-zero")

            -- lsp_attach is where you enable features that only work
            -- if there is a language server active in the file
            local lsp_attach = function(client, bufnr)
                local opts = { buffer = bufnr }

                vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
                vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
                vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
                vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
                vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
                vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
                vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
                vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
            end

            lsp_zero.extend_lspconfig({
                sign_text = true,
                lsp_attach = lsp_attach,
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            require("mason-lspconfig").setup({
                ensure_installed = { "jsonnet_ls" },
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        require("lspconfig")[server_name].setup({})
                    end,
                    jsonnet_ls = function()
                        require("lspconfig").jsonnet_ls.setup({
                            settings = {
                                ext_vars = {},
                                formatting = {
                                    -- default values
                                    Indent = 2,
                                    MaxBlankLines = 2,
                                    StringStyle = "single",
                                    CommentStyle = "slash",
                                    PrettyFieldNames = true,
                                    PadArrays = false,
                                    PadObjects = true,
                                    SortImports = true,
                                    UseImplicitPlus = true,
                                    StripEverything = false,
                                    StripComments = false,
                                    StripAllButComments = false,
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },
}
