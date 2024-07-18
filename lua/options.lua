vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.clipboard = 'unnamedplus'
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.mouse = 'a'

vim.keymap.set('n','<leader>fe',vim.cmd.Ex)
vim.keymap.set('v','J',":m '>+1<CR>gv=gv") 
vim.keymap.set('v','K',":m '<-2<CR>gv=gv")
