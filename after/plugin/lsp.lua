local on_attach = function(_, bufnr)
	local bufmap = function(keys, func)
		vim.keymap.set("n", keys, func, { buffer = bufnr })
	end

	bufmap("<leader>r", vim.lsp.buf.rename)
	bufmap("<leader>a", vim.lsp.buf.code_action)

	bufmap("gd", require("telescope.builtin").lsp_definitions)
	bufmap("gD", vim.lsp.buf.declaration)
	bufmap("gI", require("telescope.builtin").lsp_implementations)
	bufmap("<leader>D", vim.lsp.buf.type_definition)

	bufmap("gr", require("telescope.builtin").lsp_references)
	bufmap("<leader>s", require("telescope.builtin").lsp_document_symbols)
	bufmap("<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols)
	bufmap("<leader>ff", require("telescope.builtin").find_files)
	bufmap("<leader>fp", require("telescope.builtin").oldfiles)

	bufmap("K", vim.lsp.buf.hover)

	-- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
	-- 	vim.lsp.buf.format()
	-- end, {})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- mason
require("mason").setup()
local registry = require("mason-registry")
local installed_lsp = {
	"lua-language-server",
	"stylua",
	"css-lsp",
	"typescript-language-server",
	"prettier",
	"black",
	"isort",
	"pyright",
	"python-lsp-server",
	"json-lsp",
	"bash-language-server",
	"gopls",
	"ruff",
	"rust-analyzer",
	"goimports-reviser",
	"yaml-language-server",
	"gomodifytags",
}
registry.refresh(function()
	for _, name in pairs(installed_lsp) do
		local package = registry.get_package(name)
		if not registry.is_installed(name) then
			package:install()
		else
			package:check_new_version(function(success, result_or_err)
				if success then
					package:install({ version = result_or_err.latest_version })
				end
			end)
		end
	end
end)

local mlsp = require("mason-lspconfig")
mlsp.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
	["lua_ls"] = function()
		require("neodev").setup()
		require("lspconfig").lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		})
	end,
	["yamlls"] = function()
		require("neodev").setup()
		require("lspconfig").yamlls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				yaml = {
					schemas = {
						["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.yaml",
					},
					format = {
						enable = true,
					},
				},
			},
		})
	end,
	-- ["pylsp"] = function()
	-- 	require("lspconfig").pylsp.setup({
	-- 		on_attach = on_attach,
	-- 		capabilities = capabilities,
	-- 		settings = {
	-- 			pylsp = {
	-- 				plugins = {
	-- 					rope_autoimport = {
	-- 						completions = {
	-- 							enabled = true,
	-- 						},
	-- 						enabled = true,
	-- 						memory = true,
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	})
	-- end,
	["ruff"] = function()
		require("lspconfig").ruff.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				pyright = {
					disabledOrganizeImports = true,
				},
				python = {
					analysis = {
						ignore = { "*" },
					},
				},
			},
		})
	end,
	-- ["pyright"] = function()
	-- 	require("lspconfig").pyright.setup({
	-- 		on_attach = on_attach,
	-- 		capabilities = capabilities,
	-- 		settings = {
	-- 			python = {
	-- 				analysis = {
	-- 					autoSearchPaths = true,
	-- 					diagnosticMode = "openFilesOnly",
	-- 					useLibraryCodeForTypes = true,
	-- 				},
	-- 			},
	-- 			cmd = {
	-- 				"pyright-langserver",
	-- 				"--stdio",
	-- 			},
	-- 			filetypes = {
	-- 				"python",
	-- 			},
	-- 			single_file_support = true,
	-- 		},
	-- 	})
	-- end,
	["tsserver"] = function()
		require("lspconfig").tsserver.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				completions = {
					completeFunctionCalls = true,
				},
				implicitProjectConfiguration = {
					checkJs = true,
				},
			},
		})
	end,
	["bashls"] = function()
		require("lspconfig").bashls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			cmd = { "bash-language-server", "start" },
			settings = {
				bashIde = {
					globPattern = "*@(.sh|.bash|.inc|.command|.bashrc)",
				},
			},
			filetypes = { "sh", "bash", ".bashrc" },
		})
	end,
	["gopls"] = function()
		require("lspconfig").gopls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			cmd = { "gopls" },
			filetypes = { "go", "gomod", "gowork", "goTmpl" },
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
				},
			},
		})
	end,
	["rust_analyzer"] = function()
		require("lspconfig").rust_analyzer.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					diagnostics = {
						enable = true,
					},
					imports = {
						granularity = {
							group = "module",
						},
						prefix = "self",
					},
				},
			},
		})
	end,

	-- another example
	-- ['omnisharp'] = function()
	--     require('lspconfig').omnisharp.setup {
	--         filetypes = { 'cs', 'vb' },
	--         root_dir = require('lspconfig').util.root_pattern('*.csproj', '*.sln'),
	--         on_attach = on_attach,
	--         capabilities = capabilities,
	--         enable_roslyn_analyzers = true,
	--         analyze_open_documents_only = true,
	--         enable_import_completion = true,
	--     }
	-- end,
})

local pylsp = require("mason-registry").get_package("python-lsp-server")
pylsp:on("install:success", function()
	local function mason_package_path(package)
		local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
		return path
	end
	local path = mason_package_path("python-lsp-server")
	local command = path .. "/venv/bin/pip"
	local args = {
		"install",
		"-U",
		"pylsp-rope",
		"python-lsp-black",
		"pyflakes",
		"python-lsp-ruff",
		"pyls-flake8",
		"sqlalchemy-stubs",
		"pylsp-mypy",
		"pyls-memestra",
	}
	require("plenary.job")
		:new({
			command = command,
			args = args,
			cwd = path,
		})
		:start()
end)
