require("nvim-treesitter.configs").setup({
	ensure_installed = { "vim", "vimdoc", "lua", "cpp", "python", "jsdoc", "json", "json5", "typescript", "go","rust"},

	auto_install = true,

	highlight = { enable = true },

	indent = { enable = true },
})
