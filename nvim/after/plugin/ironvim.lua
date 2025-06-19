local iron = require("iron.core")

iron.setup {
  config = {
    repl_definition = {
      python = {
        command = {"ipython"}
      }
    },
    repl_open_cmd = "vertical botright 60 split"
  },
  keymaps = {
    send_motion = "<leader>sc",
    visual_send = "<leader>sc",
    send_file = "<leader>sf",
    send_line = "<leader>sl",
    send_mark = "<leader>sm",
    mark_motion = "<leader>mc",
    mark_visual = "<leader>mc",
    remove_mark = "<leader>md",
    cr = "<leader>s<cr>",
    interrupt = "<leader>s<space>",
    exit = "<leader>sq",
    clear = "<leader>cl",
    toggle_repl = "<space>rr"
  },
  highlight = {
    italic = true
  },
  ignore_blank_lines = true
}


-- Get the text of the current # %% code cell
local function get_cell()
  local start_line = vim.fn.search("# %%", "bnW")
  if start_line == 0 then start_line = 1 end
  local end_line = vim.fn.search("# %%", "nW")
  if end_line == 0 then end_line = vim.fn.line("$") + 1 end
  end_line = end_line - 1

  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  return lines
end

-- Send the current cell to iron.nvim REPL
local function send_current_cell()
  local lines = get_cell()
  iron.send(nil, lines)
end

-- Create a keybinding (example: <leader>cc)
vim.keymap.set("n", "<leader>cc", send_current_cell, { noremap = true, silent = true })

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("python", {
  s("cell", { t("# %%") })
})

