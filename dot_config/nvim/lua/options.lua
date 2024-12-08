vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

-- Search case insensitive, except when explicitly using upper case.
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true

vim.opt.inccommand = "split"

vim.opt.scrolloff = 8

-- Display column for signs left of line numbers.
vim.opt.signcolumn = "yes"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.undofile = true

-- Time till write to swap file and till CursorHoldEvent gets triggered.
vim.opt.updatetime = 250

-- Time to wait for completion of a keymap.
vim.opt.timeoutlen = 300

vim.opt.wrap = false

--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
