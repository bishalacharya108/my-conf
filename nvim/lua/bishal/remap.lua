vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv",vim.cmd.Ex)
vim.keymap.set("n", "<leader>y","\"+y")
vim.keymap.set("v", "<leader>y","\"+y")
vim.keymap.set("n", "<leader>Y","\"+Y")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

--delete this if the autocompletions are encountering any problems 
vim.keymap.set("n", "<A-z>", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrap" })

-- vim.keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
-- vim.keymap.set("n", "<S-Tab>", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Fuzzy switch buffer" })

--for moving selected lines up and down in visual mode
vim.keymap.set("v","J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v","K", ":m '<-2<CR>gv=gv")
vim.keymap.set({ "n", "v" }, "<leader>lf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format with Conform" })


--for git preview from gitsigns
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Gitsigns preview as hunk" })
-- emmet remap
-- vim.g.user_emmet_leader_key = '<C-e>'
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Global Code Action" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics in location list" })
vim.keymap.set("n", "<leader>c", ":copen<CR>", { desc = "Open quickfix list" })
vim.keymap.set("n", "<leader>cc", ":cclose<CR>", { desc = "Close quickfix list" })
--for repl command in ironvim
vim.keymap.set('n', '<leader>rp', function()
  require("iron.core").repl_for("python")
end, { noremap = true, silent = true, desc = "Open Python REPL (iron.nvim)" })

--terminal escape remap
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

--python running with keymap
vim.keymap.set("n", "<leader>rp", function ()
    vim.cmd("w")
    vim.cmd("!python %")
end,  {desc = "Run python script"})

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")
-- time
vim.keymap.set("n", "<leader>wt", ":WakaTimeToday<CR>", { desc = "Show WakaTime today" })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
-- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])
