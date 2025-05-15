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
						"-format",
						util.escape_path(util.get_current_buffer_file_path()),
					},
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
		json = {
			require("formatter.defaults.prettier"),
		},
		python = {
			function()
				return {
					exe = "ruff format",
					args = {
						util.escape_path(util.get_current_buffer_file_path()),
					},
				}
			end,
		},
		rust = {
			function()
				return {
					exe = "rustfmt",
					args = {
						util.escape_path(util.get_current_buffer_file_path()),
					},
				}
			end,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
