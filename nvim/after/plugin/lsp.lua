local lspconfig = require("lspconfig")
local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")

-- Optional: Try to load navic safely
local navic_ok, navic = pcall(require, "nvim-navic")

-- Load VSCode-style snippets from friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Capabilities
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)

-- ccls
-- Add this after your mason-lspconfig setup
lspconfig.ccls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  init_options = {
    compilationDatabaseDirectory = "build", -- For compile_commands.json
    cache = {
      directory = ".ccls-cache", -- Cache dir (optional)
    },
    clang = {
      extraArgs = { 
        "-isysroot", "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk",
        "-std=c++17"
      },
    },
  },
  filetypes = { "c", "cpp", "objc", "objcpp" },
})

-- On Attach
local on_attach = function(client, bufnr)
    if not vim.g.mapleader then
        vim.g.mapleader = " "
        vim.notify("Leader key defaulted to space", vim.log.levels.WARN)
    end

    local function buf_map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        opts.desc = opts.desc or ("LSP: " .. tostring(rhs))
        if type(rhs) == "string" then return end
        local ok, err = pcall(vim.keymap.set, mode, lhs, rhs, opts)
        if not ok then
            vim.notify("Mapping failed: " .. err, vim.log.levels.ERROR)
        end
    end

    buf_map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
    buf_map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
    buf_map("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
    buf_map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

    -- Attach navic if supported and loaded
    if navic_ok and client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end

    vim.diagnostic.config({
        virtual_text = true,
        underline = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
        },
        severity_sort = true,
    })
end

-- Setup Mason
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "pyright",
        "html",
        "cssls",
        "tsserver",
        "eslint",
        "tailwindcss",
        "golangci_lint_ls",
        "clangd",
    },
    handlers = {
        function(server)
            if server == "clangd" then
                lspconfig.clangd.setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                    cmd = {
                        "clangd",
                        "--compile-commands-dir=" .. vim.fn.getcwd(),
                        "--query-driver=/usr/bin/clang++,/Library/Developer/CommandLineTools/usr/bin/clang++",
                        "--",
                        "-isysroot", "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk",
                        "-I", "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1",
                        "-std=c++17",
                    },
                })
            else
                lspconfig[server].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end
        end,

        ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        format = {
                            enable = true,
                            defaultConfig = {
                                indent_style = "space",
                                indent_size = "2",
                            },
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
        end,
    }
})

-- CMP setup
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-Space>"] = cmp.mapping.complete(),
        ['<C-y>'] = nil,
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "nvim_lsp_signature_help" },
    }, {
        { name = "buffer" },
        { name = "path" },
    }),
})

-- Formatter setup
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        python = { "black" },
        go = { "goimports", "gofmt" },
        rust = { "rustfmt" },
    },
})

-- UI feedback
require("fidget").setup({})

-- Diagnostics float on hover
vim.o.updatetime = 250
vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })]])

