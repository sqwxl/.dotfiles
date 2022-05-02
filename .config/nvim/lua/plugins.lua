local packer = nil
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

local function init()
  if packer == nil then
    packer = require "packer"
    packer.init { disable_commands = true }
  end

  local use = packer.use
  packer.reset()

  use { 'wbthomason/packer.nvim' }
  -- Speedup
  use { 'lewis6991/impatient.nvim' }
  use { 'nathom/filetype.nvim' }

  -- Enhancements
  use { 'lbrayner/vim-rzip', disable = true }
  use { 'tpope/vim-surround', event = "InsertEnter" }
  use { 'tpope/vim-repeat', envent = "InsertEnter" }
  use { 'andymass/vim-matchup' }
  use { 'ludovicchabant/vim-gutentags', disable = true }
  use { 'numToStr/Comment.nvim', config = function() require 'Comment'.setup() end }
  use {
    'windwp/nvim-autopairs',
    config = function() require 'nvim-autopairs'.setup { check_ts = true, disable_in_macro = true } end
  }
  use { 'windwp/nvim-ts-autotag' }
  use {
    'ggandor/lightspeed.nvim',
    after = "gruvbox",
  }
  use {
    'akinsho/toggleterm.nvim',
    disable = true,
    config = function()
      require 'toggleterm'.setup {
        open_mapping = '<A-Space>',
        shade_terminals = false
      }
    end
  }
  use {
    'kevinhwang91/nvim-bqf',
    disable = true,
    keys = "<C-q>",
    ft = "qf",
    config = function()
      vim.api.nvim_set_keymap("n", "<C-q>", require "utils".toggle_qf, { silent = true })
    end
  }

  -- Git
  use { 'tpope/vim-fugitive', cmd = "Git" }
  -- use {
  --   'TimUntersberger/neogit',
  --   disable = true,
  --   requires = {'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim'},
  --   keys = "<A-n>",
  --   config = function()
  --     require "neogit".setup {
  --       integrations = { diffview = true }
  --     }
  --     vim.api.nvim_set_keymap("n", "<A-n>", [[<cmd>Neogit<CR>]], {silent = true})
  --   end
  -- }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  use 'folke/lua-dev.nvim'

  -- Look
  use { 'morhetz/gruvbox' }
  use { 'folke/lsp-colors.nvim' }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require 'lualine'.setup {
        -- tabline = {lualine_a = {'buffers'}, lualine_z = {'tabs'}},
        sections = { lualine_c = { { 'filename', path = 1 } }, lualine_x = { 'filetype' } },
        inactive_sections = { lualine_x = {} },
        extensions = { 'quickfix', 'toggleterm', 'nvim-tree' }
      }
    end
  }

  use {
    "akinsho/bufferline.nvim",
    after = "gruvbox",
    config = function()
      require("bufferline").setup {
        options = {
          numbers = function(opts)
            return opts.ordinal
          end,
          tab_size = 18,
          show_buffer_close_icons = false,
          show_close_icon = false,
          separator_style = "thin",
          enforce_regular_tabs = true,
        },
      }
    end,
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.g.indent_blankline_show_current_context = true
      require 'indent_blankline'.setup {
        filetype_exclude = { 'help', 'packer' },
        buftype_exclude = { 'terminal', 'nofile' },
        show_trailing_blankline_indent = false
      }
    end
  }

  -- Tools
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      vim.g.nvim_tree_highlight_opened_files = 1
      require 'nvim-tree'.setup {
        hijack_cursor = true,
        diagnostics = { enable = true },
        view = { signcolumn = "yes" },
        renderer = {
          indent_markers = {
            enable = true
          }
        }
      }
    end
  }

  -- Telescope
  use {
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'telescope-frecency.nvim',
        'telescope-fzf-native.nvim',
      },
      wants = {
        'popup.nvim',
        'plenary.nvim',
        'telescope-frecency.nvim',
        'telescope-fzf-native.nvim',
      },
      setup = function() require 'config.telescope_setup' end,
      config = function() require 'config.telescope' end,
      cmd = 'Telescope',
      module = 'telescope',
    },
    {
      'nvim-telescope/telescope-frecency.nvim',
      after = 'telescope.nvim',
      requires = 'tami5/sqlite.lua',
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
    },
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
    },
    run = ":TSUpdate",
  }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    requires = {
      { 'ray-x/lsp_signature.nvim' },
      {
        'filipdutescu/renamer.nvim',
        branch = 'master',
        requires = { { 'nvim-lua/plenary.nvim' } },
      }
    }
  }

  -- CMP
  use {
    'hrsh7th/nvim-cmp',
    after = "gruvbox",
    requires = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
    },
    config = function() require "config.cmp" end,
    event = 'InsertEnter *',
  }

  use {
    'simrat39/rust-tools.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require "rust-tools".setup() end
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

-- vim.cmd 'source /home/nilueps/.config/nvim/vimscript/rzip.vim'

return plugins
