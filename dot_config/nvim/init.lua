-- Set leader keys.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Import basic settings.
require("options")
require("keymaps")
require("autocommands")

-- Bootstrap lazy plugin manager.
require("lazy-bootstrap")
