lsp_shared_setup = function(client, bufnr)
    -- if client.resolved_capabilities.document_formatting then
    --     vim.cmd("autocmd BufWritePre * lua vim.lsp.buf.formatting()")
    -- end

    -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-f>", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-d>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>i", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wl",
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>d", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>r", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

-----------------------
-- Setup LSP servers --
-----------------------
local lspconfig = require "lspconfig"

-- clangd for C and C++
lspconfig.clangd.setup({
    on_attach = lsp_shared_setup,
    capabilities = capabilities,
})

-- gopls for Go
lspconfig.gopls.setup({
    cmd = { "gopls", "serve" },
    capabilities = capabilities,
    on_attach = lsp_shared_setup,
    settings = {
        gopls = {
            usePlaceholders = true, -- to make completion awesome
            gofumpt = false, -- more strict formatting
            analyses = { -- enable all formatters disabled by default
                unusedparams = true,
                fieldalignment = true,
                nilness = true,
                shadow = true,
                unusedwrite = true,
            },
            staticcheck = true,
            codelenses = {
                generate = true,
                gc_details = true,
                regenerate_cgo = true,
                tidy = true,
                upgrade_depdendency = true,
                vendor = true,
            },
            linksInHover = false,
        },
    },
})

vim.cmd([[
augroup my-go-nvim-coverage
    autocmd!
    autocmd Syntax go hi goCoverageCovered guibg=green
    autocmd Syntax go hi goCoverageUncover guibg=brown
augroup end
]])

-- python-lsp-server for python
lspconfig.pylsp.setup({
    capabilities = capabilities,
    on_attach = lsp_shared_setup,
})

-- sumneko_lua for Lua tailored for Neovim

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

-- lspconfig.sumneko_lua.setup({
--     capabilities = capabilities,
--     on_attach = lsp_shared_setup,
--     settings = {
--         Lua = {
--             runtime = {
--                 -- Tell the language server which version of Lua you're using
--                 -- (most likely LuaJIT in the case of Neovim)
--                 version = 'LuaJIT',
--                 -- Setup your lua path
--                 path = runtime_path,
--             },
--             diagnostics = {
--                 -- Get the language server to recognize the `vim` global
--                 globals = { 'vim' },
--             },
--             workspace = {
--                 -- Make the server aware of Neovim runtime files
--                 library = vim.api.nvim_get_runtime_file('', true),
--             },
--             -- Do not send telemetry data containing a randomized but unique
--             -- identifier
--             telemetry = {
--                 enable = false,
--             },
--         },
--     },
-- })
