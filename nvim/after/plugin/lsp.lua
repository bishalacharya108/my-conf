local lspconfig = require("lspconfig")
local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")

-- Capabilities for completion
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)

-- On Attach Function: keymaps + diagnostics config
local on_attach = function(client, bufnr)
    -- Verify leader key is set (critical!)
    if not vim.g.mapleader then
        vim.notify("Warning: vim.g.mapleader was nil! Defaulting to space", vim.log.levels.WARN)
        vim.g.mapleader = " "
    end

    -- Debugging output
    print(string.format(
        "LSP Attach: buffer=%d, filetype=%s, leader='%s', client=%s",
        bufnr,
        vim.bo[bufnr].filetype,
        vim.g.mapleader,
        client.name
    ))

    -- Improved buf_map function with validation
    local function buf_map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        opts.desc = opts.desc or ("LSP: " .. tostring(rhs))

        -- Verify the RHS is callable
        if type(rhs) == "string" then
            vim.notify("Warning: RHS should be a function for LSP mappings", vim.log.levels.WARN)
            return
        end

        -- Actually set the mapping
        local success, err = pcall(vim.keymap.set, mode, lhs, rhs, opts)
        if not success then
            vim.notify(string.format("Failed to set mapping %s: %s", lhs, err), vim.log.levels.ERROR)
        else
            print("Set mapping:", mode, lhs, opts.desc)
        end
    end

    -- LSP keybindings with explicit checks
    buf_map("n", "K", function()
        print("Executing hover()") -- Debug
        vim.lsp.buf.hover()
    end, { desc = "Hover Info" })

    buf_map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
    buf_map("n", "gr", vim.lsp.buf.references, { desc = "Go to References" })
    buf_map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

    -- Diagnostics setup
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

-- Setup mason
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

        -- Custom Lua LS config
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

-- Float window on hover
vim.o.updatetime = 250
vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })]])

