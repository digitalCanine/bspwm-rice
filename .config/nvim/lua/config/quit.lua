local function close_neotree_if_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    if ft == "neo-tree" then
      vim.cmd("Neotree close")
      return
    end
  end
end

-- Override :q
vim.api.nvim_create_user_command("Q", function()
  close_neotree_if_open()
  vim.cmd("q")
end, {})

vim.cmd("cnoreabbrev q Q")

-- Override :wq
vim.api.nvim_create_user_command("WQ", function()
  close_neotree_if_open()
  vim.cmd("wq")
end, {})

vim.cmd("cnoreabbrev wq WQ")
