local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
  'lua_ls',
  'rust_analyzer',
  'pyright'
})

-- disable pyright
-- lsp.skip_server_setup("pyright")
lsp.configure("pyright", {
  settings = {
    python = {
      analysis = {
        autoImportCompletions = true,
        useLibraryCodeForTypes = true
      }
    }
  }
})

-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
lsp.skip_server_setup("pylsp")
-- lsp.configure("pylsp", {
--   settings = {
--     pylsp = {
--       plugins = {
--         pycodestyle = {
--           maxLineLength = 110
--         }
--       }
--     }
--   }
-- })
--

lsp.skip_server_setup("efm")

-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

-- Initialize rust_analyzer with rust-tools
lsp.skip_server_setup({ "rust_analyzer" })
require("rust-tools").setup({ server = lsp.build_options("rust_analyzer", {}) })

lsp.set_preferences({
  suggest_lsp_servers = false,
})

local mappings = require("config.mappings")

lsp.setup_nvim_cmp({
  mappings = lsp.defaults.cmp_mappings(mappings.cmp_mappings),
  sources = {
    { name = "path"},
    { name = "nvim_lsp"},
    {name="buffer", keyword_length=3},
    {name="luasnip", keyword_length=2},
    {name="copilot"}
  }
})

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()


lsp.on_attach(mappings.on_attach)

lsp.setup()

local cmp = require("cmp")

-- disabel copilot suggestion when completion menu is opened
-- cmp.event:on("menu_opened", function()
--   vim.b.copilot_suggestion_hidden = true
-- end)
-- cmp.event:on("menu_closed", function()
--   vim.b.copilot_suggestion_hidden = false
-- end)

-- insert `(` after select function or method item
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done",
  cmp_autopairs.on_confirm_done()
)

vim.diagnostic.config({
  virtual_text = true
})
