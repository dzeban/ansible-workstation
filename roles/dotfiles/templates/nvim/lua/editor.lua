local opt = vim.o
local cmd = vim.cmd
local g = vim.g

HOME = os.getenv("HOME")

opt.termguicolors = true
cmd([[
if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    " Make comments yellow to easily see them
    autocmd ColorScheme * call onedark#set_highlight("Comment", {"fg": { "gui": "gold", "cterm": "11" }})
    autocmd ColorScheme * call onedark#set_highlight("Normal", {"fg": { "gui": "lightgrey", "cterm": "white" }})
    autocmd ColorScheme * call onedark#set_highlight("String", {"fg": { "gui": "pink1", "cterm": "lightred" }})
  augroup END
endif
]])
cmd("colorscheme onedark")

-- Put .swp files into single dir to avoid files pollution
opt.directory = HOME .. "/.vim/swapfiles/"

-- Override filetypes for tricky cases
cmd([[
    autocmd BufRead,BufNewFile *.conf setfiletype config
    autocmd BufRead,BufNewFile *.pp setfiletype ruby
    autocmd BufRead,BufNewFile alert.rules setfiletype yaml "prometheus alert rules are yaml
    autocmd BufRead,BufNewFile *.tpl setfiletype yaml "Helm templates
    autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 foldmethod=indent foldlevelstart=20 cursorcolumn
    autocmd FileType go setlocal noexpandtab
]])

opt.inccommand = "nosplit"

-- Hide buffer instead of unloading it.
-- This fixes nagging 'No write since last change' when switching buffers
opt.hidden = true

-- Configure persistent undo
-- Vim will save undo in file stored in .vim/undodir
opt.undodir = HOME .. "/.vim/undodir"
opt.undofile = true

-- Enable mouse support in all modes
opt.mouse = "a"

-- I don't need to see the current mode,
-- I know what it is
opt.showmode = false

-- Complete command line on longest substring,
-- then list alternatives
opt.wildmode = "list:full"

-- opt.completeopt = "menuone,preview,longest"
opt.completeopt = "menuone,noselect"

-- Always use the clipboard for all operations
opt.clipboard = "unnamedplus"

-- Search continues over end of file
opt.wrapscan = true

-- Show line numbers
opt.number = true

-- Don't show spaces.
-- Trailing whitespace is handled by sensible plugin.
opt.list = false

opt.cursorline = true

-- Indentation settings
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- New splits will be at the bottom or to the right side of the screen
opt.splitbelow = true
opt.splitright = true

-- Default text width is 80
opt.textwidth = 80

-- Show matching bracket
opt.showmatch = true

opt.ignorecase = true -- searches are case insensitive...
opt.smartcase = true -- ... unless they contain at least one capital letter

g.mapleader = " "

local function map(mode, shortcut, command)
    return function(shortcut, command)
        vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
    end
end

local nmap = map("n")
local imap = map("i")
local vmap = map("v")
local cmap = map("c")

-- Correct next line jump within wrapped lines
nmap("j", "gj")
nmap("k", "gk")

-- Center view on search result
-- nmap("n", "nzz")
-- nmap("N", "Nzz")
-- nmap("*", "*zz")
-- nmap("#", "#zz")
-- nmap("g*", "g*zz")
-- nmap("g#", "g#zz")

-- Keep context during search, replace and other scroll commands
opt.scrolloff = 5

-- Stay in visual mode when indenting
vmap("<", "<gv")
vmap(">", ">gv")


-- Map BOL/EOL to 9/0 respectively
nmap("0", "$")
nmap("9", "^")

--save file with sudo
cmap("w!!", "%!sudo tee > /dev/null %")

-- Copy buffer path
cmap("cp", 'let @+ = expand("%")')

-- C-c and C-v - Copy/Paste to global clipboard
vmap("<C-c>", '"+y')
imap("<C-v>", '<ESC>"+pa')

-- Windows resizing
nmap("<C-W>=", "<C-W>3+")
nmap("<C-W>-", "<C-W>3-")
nmap("<C-W>.", "<C-W>5>")
nmap("<C-W>,", "<C-W>5<")

-- Make :cnext, :cprev, :lnext, :lprev cycle
-- to avoid stupid 'No more items' error
cmd([[
command! Cnext try | cnext | catch | cfirst | catch | endtry
command! Cprev try | cprev | catch | clast | catch | endtry
command! Lnext try | lnext | catch | lfirst | catch | endtry
command! Lprev try | lprev | catch | llast | catch | endtry
]])

nmap("<F3>", ":copen<CR>")
nmap("<F4>", ":cclose<CR>")
nmap("<F5>", ":lopen<CR>")
nmap("<F6>", ":lclose<CR>")
nmap("<F7>", ":Lprev<CR>")
nmap("<F8>", ":Lnext<CR>")
nmap("<F9>", ":Cprev<CR>")
nmap("<F10>", ":Cnext<CR>")

-- Quick tab actions
-- Don't override <tab> because in Vim it's the same as <c-i> which is jump
-- forward (opposite to <c-o>). So remapping <tab> breaks jump forward.
nmap("<S-tab>", ":tabnext<CR>")

--replace the word under cursor
nmap("<leader>*", ":%s/\\<<c-r><c-w>\\>//<left>")

-- Spellcheck toggle
nmap("<F3>", ":setlocal spell! spelllang=en_us<CR>")

-- Statusline format

cmd([[
set statusline=
set statusline+=%#title#\ %{get(b:,'gitsigns_status','')}
set statusline+=%#normal#\ %f\  " filename
set statusline+=%#type#\ %Y\ "filetype
set statusline+=%#structure#%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
"set statusline+=%#warningmsg#\ %{NeomakeStatusLine()}
set statusline+=%#normal#%=      "left/right separator
set statusline+=%P\     "percent through file
set statusline+=[%l:%c]     "cursor column
]])

-- F11 - Tags
g.tagbar_left = 1
nmap("<F11>", ":TagbarToggle<CR>")

-- F12 - Files
nmap("<F12>", ":NERDTreeToggle<cr>")
g.NERDTreeWinPos = "right"

-- Always show sign column for gitsigns
opt.signcolumn = "yes"

require("gitsigns").setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },

    status_formatter = function(status)
        return status.head
    end
}

nmap("<A-]>", ":Gitsigns next_hunk<CR>")
nmap("<A-[>", ":Gitsigns prev_hunk<CR>")

-- F5 - close QuickFix list
nmap("<F5>", ":cclose<cr>")

-- Workspace settings
-- Save triggers neomake, I don't want to constantly run it.
g.workspace_autosave = 0
g.workspace_session_disable_on_args = 1
g.workspace_undodir = HOME .. "/.vim/undodir"

-- Because sessions are long-lived buffers are piled.
-- This command and shortcut is very handy!
nmap("<leader>q", ":CloseHiddenBuffers<CR>")

g.terraform_fmt_on_save = 1 -- This doesn't work in autocmd

-- Surround shortcut to correctly wrap word
nmap("ysw", "ysiW")

-- For some reason this cannot be applied in Lua
cmd("set updatetime=400")

-- g.git_messenger_include_diff = "current"

-- Startify order
cmd([[
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'dir',       'header': ['   Recent files in '. getcwd()] },
      \ { 'type': 'files',     'header': ['   Recent fils']            },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
]])

-- Zoom Vim pane with a binding similar to tmux
nmap("<c-w>z", ":ZoomWinTabToggle<CR>")

require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "dockerfile", "go", "gomod", "gowork", "graphql",
        "hcl", "html", "vimdoc", "http", "json", "lua", "make", "proto", "python",
        "rust", "toml", "vim", "yaml" },

    ignore_install = { "help" },

    textobjects = {
        enable = enable,
        keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["aC"] = "@class.outer",
            ["iC"] = "@class.inner",
            ["ac"] = "@conditional.outer",
            ["ic"] = "@conditional.inner",
            ["ae"] = "@block.outer",
            ["ie"] = "@block.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["is"] = "@statement.inner",
            ["as"] = "@statement.outer",
            ["ad"] = "@comment.outer",
            ["am"] = "@call.outer",
            ["im"] = "@call.inner"
        },

        move = {
            enable = enable,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer"
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer"
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer"
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer"
            }
        },

        select = {
            enable = enable,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            }
        },

        swap = {
            enable = enable,
            swap_next = {
                ["<leader>a"] = "@parameter.inner"
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner"
            }
        }
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
})

require("Comment").setup()

-- vim.diagnostic.config({ virtual_text = false })

-- Show lint errors inline as virtual text
-- g.ale_virtualtext_cursor = 1
-- g.ale_echo_cursor = 0
-- g.ale_go_golangci_lint_package = 1

-- Telescope
-- nmap("<leader>f", "<cmd>Telescope find_files<cr>")
-- nmap("<leader>s", "<cmd>Telescope live_grep<cr>")
-- nmap("<leader>;", "<cmd>Telescope buffers<cr>")
-- nmap("<leader>*", "<cmd>Telescope live_grep default_text=' . expand('<cword>')<cr>")

-- fzf.vim mappings
nmap("<leader>;", ":Buffers<CR>")
nmap("<leader>f", ":Files<CR>")
nmap("<leader>T", ":Tags<CR>")
nmap("<leader>t", ":BTags<CR>")
nmap("<leader>s", ":Ag<CR>")
nmap("<leader>h", ":GitMessenger<CR>")
nmap("<leader>/", ":History/<CR>")
nmap("<leader>:", ":History:<CR>")
nmap("<leader>gc", ":Commits<CR>")
nmap("<leader>gbc", ":BCommits<CR>")
nmap("<leader>gs", ":GFiles?<CR>")

cmd([[
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
]])

-- Go
require("go").setup({
    -- gofmt = "gofmt",
    -- goimport = "goimports",
    -- max_line_len = 200,
})
cmd("autocmd BufWritePre *.go :GoImport")

g.git_messenger_include_diff = 'current'

-- Rust
-- Enable rust-analyzer for ALE
cmd("let g:ale_linters = {'rust': ['analyzer']}")
