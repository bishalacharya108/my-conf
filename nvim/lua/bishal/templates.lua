vim.api.nvim_create_user_command('HTML', function()
  local template = {
    '<!DOCTYPE html>',
    '<html lang="en">',
    '<head>',
    '  <meta charset="UTF-8">',
    '  <meta name="viewport" content="width=device-width, initial-scale=1.0">',
    '  <title>Document</title>',
    '</head>',
    '<body>',
    '',
    '</body>',
    '</html>'
  }
  vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
end, {})
