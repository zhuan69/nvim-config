vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.clipboard = "unnamedplus"
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.mouse = "a"

vim.keymap.set("n", "<leader>fe", ":Ex<CR>:set nu rnu<CR>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<C-d>", "<C-d>zzz")
vim.keymap.set("v", "<C-p>", "<C-p>zzz")
vim.keymap.set("v", "<leader>yy", '"+y')
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.keymap.set("n", "<leader>FF", "<cmd>FormatWrite<CR>")

local autogroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function preserve_user_marks(callback)
	-- Get current user-defined marks (a-z)
	local user_marks = {}
	for _, mark in ipairs(vim.fn.getmarklist()) do
		local name = mark.mark:sub(2, 2) -- e.g. "'a" -> "a"
		if name:match("[a-z]") then
			user_marks[name] = vim.fn.getpos("'" .. name)
		end
	end

	-- Run the formatting or command
	callback()

	-- Restore marks
	for name, pos in pairs(user_marks) do
		vim.fn.setpos("'" .. name, pos)
	end
end

autogroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	callback = function()
		preserve_user_marks(function()
			vim.cmd("FormatWrite")
		end)
	end,
})

-- @param input string
-- @param sep string
-- @return string[]
local function split(input, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(input, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local function matched_keyword(keywords, input)
	local set = {}
	for formated_word in input:gmatch("[^,%s]+") do
		set[formated_word] = true
	end
	for _, value in ipairs(keywords) do
		if set[value] then
			return true
		end
		return false
	end
end

vim.api.nvim_create_user_command("GoAddTags", function(opts)
	local args = opts.args or ""
	local file_path = vim.api.nvim_buf_get_name(0)
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local line_content = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
	local struct_name = line_content:match("^%s*type%s+([%w_]+)%s+struct%s*{?")
	local tags, style = unpack(split(args, "%s"))
	local tag_keywords = { "json", "db", "bson", "form" }
	if struct_name then
		local base_cmd = {
			"gomodifytags",
			"-file",
			file_path,
			"-struct",
			struct_name,
		}
		if matched_keyword(tag_keywords, tags) then
			table.insert(base_cmd, "-add-tags")
			table.insert(base_cmd, tags)
		end
		if style == nil then
			style = "camelcase"
		end
		table.insert(base_cmd, "-transform")
		table.insert(base_cmd, style)
		local output = vim.fn.systemlist(table.concat(base_cmd, " "))
		vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
	end
end, { nargs = "*", complete = "file" })
