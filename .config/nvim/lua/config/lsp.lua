local lspconfig = require 'lspconfig'

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require 'cmp'

cmp.setup {
    snippet = {expand = function(args) vim.fn['vsnip#anonymous'](args.body) end},
    mapping = {
        ['<C-D>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-U>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-E>'] = cmp.mapping({i = cmp.mapping.abort(), c = cmp.mapping.close()}),
        ['<CR>'] = cmp.mapping.confirm({select = true}),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, {"i", "s"})
    },
    sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'vsnip'}}, {{name = 'buffer'}})
}

cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})

cmp.setup.cmdline(':', {sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})})

local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

local capabilities = require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = {"eslint", "jsonls", "cssls", "vimls", "gopls", "bashls", "pylsp", "rnix", "tsserver", "html"}
for _, server in ipairs(servers) do
    lspconfig[server].setup({capabilities = capabilities, flags = {debounce_text_changes = 150}})
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
    settings = {
        Lua = {
            runtime = {version = 'LuaJIT', path = runtime_path},
            diagnostics = {globals = {'vim'}},
            workspace = {library = vim.api.nvim_get_runtime_file("", true)}
        }
    }
})

lspconfig.efm.setup {
    init_options = {documentFormatting = true},
    filetypes = {"lua"},
    settings = {
        rootMarkers = {".git/"},
        languages = {lua = {{formatCommand = "lua-format -i --column-limit=120", formatStdin = true}}}
    }
}

require'rust-tools'.setup {
    tools = {
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {show_parameter_hints = false, parameter_hints_prefix = "", other_hints_prefix = ""}
    },
    server = {capabilities = capabilities, settings = {["rust-analyzer"] = {checkOnSave = {command = "clippy"}}}}
}

