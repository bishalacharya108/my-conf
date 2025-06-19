-- Set your database connections with password
vim.g.dbs = {
	default = "mysql://root:bishal123@localhost",
}

-- Toggle DBUI
vim.keymap.set("n", "<leader>du", ":DBUIToggle<CR>", { silent = true, desc = "Toggle DB UI" })

-- Execute current line or selection query
vim.keymap.set("n", "<leader>dq", ":DB<CR>", { silent = true, desc = "Execute SQL query" })
vim.keymap.set("v", "<leader>dq", ":DB<CR>", { silent = true, desc = "Execute SQL selection" })

-- UI customization
vim.g.db_ui_show_icons = true
vim.g.db_ui_win_position = "right"
vim.g.db_ui_winwidth = 40

-- Command to create new database
vim.api.nvim_create_user_command('NewDB', function(opts)
  local db_name = opts.args
  if not db_name or db_name == '' then
    print("Usage: :NewDB database_name")
    return
  end

  local query = "CREATE DATABASE IF NOT EXISTS " .. db_name .. ";"

  local cmd = {
    "mysql",
    "-u", "root",
    "-p" .. "bishal123",
    "-e", query
  }

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        print(table.concat(data, "\n"))
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_err_writeln("Error: " .. table.concat(data, "\n"))
      end
    end,
    on_exit = function(_, code)
      if code == 0 then
        print("✅ Created Database: " .. db_name)
      else
        print("❌ Failed to create database")
      end
    end
  })
end, { nargs = 1 })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql" },
  callback = function()
    vim.g.dadbod_completion_mark = ''
    vim.g.dadbod_completion_enable = 1
  end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*dbui-query-*",
  callback = function()
    vim.bo.filetype = "sql"
  end,
})





-- Function to create a MySQL table
local function create_mysql_table(db_name, table_name)
	local query = string.format(
		[[
    USE %s;
    CREATE TABLE IF NOT EXISTS %s (
      id INT AUTO_INCREMENT PRIMARY KEY,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB;
  ]],
		db_name,
		table_name
	)

	vim.cmd("DB default -e " .. vim.fn.shellescape(query))
end

-- Example usage:
-- create_mysql_table('my_db', 'users')
