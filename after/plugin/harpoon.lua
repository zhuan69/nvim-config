local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

local confTelescope = require("telescope.config").values
local function ui_telescope(harpoon_files)
	local filePath = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(filePath, item.value)
	end
	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon List File",
			finder = require("telescope.finders").new_table({
				results = filePath,
			}),
			previewer = confTelescope.file_previewer({}),
			sorter = confTelescope.generic_sorter({}),
		})
		:find()
end

vim.keymap.set("n", "<leader>aa", function()
	harpoon:list():add()
end)

vim.keymap.set("n", "<C-e>", function()
	ui_telescope(harpoon:list())
end)

vim.keymap.set("n", "<leader>f1", function()
	harpoon:list():select(1)
end)

vim.keymap.set("n", "<leader>f2", function()
	harpoon:list():select(2)
end)

vim.keymap.set("n", "<leader>f3", function()
	harpoon:list():select(3)
end)

vim.keymap.set("n", "<leader>f4", function()
	harpoon:list():select(4)
end)

vim.keymap.set("n", "<leader>fc", function()
	harpoon:list():clear()
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>f,", function()
	harpoon:list():prev()
end)
vim.keymap.set("n", "<leader>f.", function()
	harpoon:list():next()
end)
