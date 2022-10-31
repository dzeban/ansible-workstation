local luasnip = require "luasnip"
local cmp = require "cmp"
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },

    -- Don't preselect item to make selection with tab or arrows work
    preselect = cmp.PreselectMode.None,

    mapping = {
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),

        ["<PageUp>"] = cmp.mapping.scroll_docs(-4),
        ["<PageDown>"] = cmp.mapping.scroll_docs(4),
        ["<ESC>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping(
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }
        -- { "c" }
        ),

        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end,
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "buffer", keyword_length = 3 },
        { name = "path" },
        { name = "luasnip" },
        { name = "nvim_lua" },
    },
})

-- cmp.setup.cmdline('/', {
--     sources = {
--         { name = 'buffer' }
--     }
-- })
--
-- cmp.setup.cmdline(':', {
--     sources = {
--         { name = 'buffer' },
--         { name = 'path' },
--         { name = 'cmdline' },
--     }
-- })
