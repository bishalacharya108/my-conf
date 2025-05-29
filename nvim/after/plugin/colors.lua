require('rose-pine').setup({
    disable_background = true,
    disable_float_background = true
})
vim.opt.termguicolors = true
function ColorMyPencils(color)

	color = color or "rose-pine"
    -- color = color or "gruvbox"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
	vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
	vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
	vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" }) -- popup menu
	vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })
end

ColorMyPencils()
