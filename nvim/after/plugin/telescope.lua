local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })

vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope find git files' })
vim.keymap.set('n', '<leader>ps', function()
 	builtin.grep_string({ search = vim.fn.input("Grep > ")});
end)
vim.keymap.set("n", "<leader>gd", "<cmd>Telescope lsp_implementations<cr>", { desc = "LSP Implementations" })

