local pkgs = {
    "savq/paq-nvim";

    -- "alexdzyoba/vim-tile";
    "joshdick/onedark.vim";

    -- Utils for some Lua plugins like telescope, gitsigns.
    "nvim-lua/plenary.nvim";

    -- "nvim-telescope/telescope.nvim";
    "junegunn/fzf";
    "junegunn/fzf.vim";
    -- "jremmen/vim-ripgrep";

    "scrooloose/nerdtree";
    "mhinz/vim-startify";
    "troydm/zoomwintab.vim";
    "qpkorr/vim-bufkill";
    -- "airblade/vim-gitgutter";
    -- "jreybert/vimagit";
    "rhysd/git-messenger.vim";
    "lewis6991/gitsigns.nvim";
    "majutsushi/tagbar";
    "tpope/vim-surround";
    "thaerkh/vim-workspace";
    "godlygeek/tabular";
    "numToStr/Comment.nvim";
    "blueyed/vim-qf_resize";

    "ray-x/go.nvim";
    "ray-x/guihua.lua";

    "pedrohdz/vim-yaml-folds";

    -- "dense-analysis/ale";
    "hashivim/vim-terraform";
    "towolf/vim-helm";
    
    "vmware-archive/salt-vim";
    "Glench/Vim-Jinja2-Syntax";

    { "nvim-treesitter/nvim-treesitter", build = vim.fn[":TSUpdate"] };
    "nvim-treesitter/nvim-treesitter-textobjects";
    "romgrk/nvim-treesitter-context";
    "JoosepAlviste/nvim-ts-context-commentstring";

    "neovim/nvim-lspconfig";

    "hrsh7th/nvim-cmp";
    "hrsh7th/cmp-buffer";
    "hrsh7th/cmp-path";
    "hrsh7th/cmp-cmdline";
    "hrsh7th/cmp-nvim-lua";
    "hrsh7th/cmp-nvim-lsp";

    "L3MON4D3/LuaSnip";
    "saadparwaiz1/cmp_luasnip";
    "rafamadriz/friendly-snippets";
}

local function bootstrap_paq()
    local path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
    if vim.fn.empty(vim.fn.glob(path)) > 0 then
        vim.fn.system {
            'git',
            'clone',
            '--depth=1',
            'https://github.com/savq/paq-nvim.git',
            path
        }

        -- Load Paq
        vim.cmd('packadd paq-nvim')
        local paq = require('paq')

        -- Read and install packages
        paq(pkgs)
        paq.install()
    end
end

bootstrap_paq()

require("paq")(pkgs)
