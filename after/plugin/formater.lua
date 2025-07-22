require("conform").setup({
	format_after_save = {
		lsp_format = "fallback",
	},
	notify_on_error = true,
	notify_no_formatters = true,
	log_level = vim.log.levels.ERROR,
	format_on_save = {
		-- I recommend these options. See :help conform.format for details.
		lsp_format = "fallback",
		quiet = true,
		timeout_ms = 500,
	},
	formatters_by_ft = {
		go = {
			"goformatter",
		},
		lua = {
			"stylua",
		},
		javascript = {
			"prettier",
		},
		typescript = {
			"prettier",
		},
		json = {
			"prettier",
		},
		python = {
			"ruff_format",
		},
		rust = { "rust_fmt" },
	},
	formatters = {
		goformatter = {
			command = "goimports-reviser",
			args = {
				"-format",
				"$FILENAME",
			},
			stdin = false,
		},
	},
})
