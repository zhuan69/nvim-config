local util = require("formatter.util")
require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.INFO,
	filetype = {
		go = {
			function()
				return {
					exe = "goimports-reviser",
					args = {
						"-rm-unused",
						"-set-alias",
						"-format",
						util.escape_path(util.get_current_buffer_file_path()),
					},
					stdin = true,
				}
			end,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		javascript = {
			require("formatter.defaults.prettier"),
		},
		typescript = {
			require("formatter.defaults.prettier"),
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
