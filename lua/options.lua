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
vim.keymap.set('v',"<C-d>","<C-d>zzz")
vim.keymap.set('v',"<C-p>","<C-p>zzz")
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"


vim.keymap.set('n','<leader>FF',"<cmd>FormatWrite<CR>")

local autogroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autogroup("__formatter__",{clear=true})
autocmd("BufWritePost",{
	group = "__formatter__",
	command = ":FormatWrite"
})
