local on_attach = function(_, bufnr)
	local bufmap = function(keys, func)
		vim.keymap.set('n', keys, func, { buffer = bufnr })
	end

	bufmap('<leader>r', vim.lsp.buf.rename)
	bufmap('<leader>a', vim.lsp.buf.code_action)

	bufmap('gd', vim.lsp.buf.definition)
	bufmap('gD', vim.lsp.buf.declaration)
	bufmap('gI', vim.lsp.buf.implementation)
	bufmap('<leader>D', vim.lsp.buf.type_definition)

	bufmap('gr', require('telescope.builtin').lsp_references)
	bufmap('<leader>s', require('telescope.builtin').lsp_document_symbols)
	bufmap('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols)
	bufmap('<leader>ff', require('telescope.builtin').find_files)

	bufmap('K', vim.lsp.buf.hover)

	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, {})
	bufmap('<leader>FF', vim.lsp.buf.format)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- mason
require("mason").setup({
	ensure_installed = {
		"lua-language-server",
		"stylua",
		"css-lsp",
		"typescript-language-server",
		"prettier",
		"black",
		"isor",
		"pyright",
		"python-lsp-server"
	},
	handlers = {}
})
require("mason-lspconfig").setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup {
			on_attach = on_attach,
			capabilities = capabilities
		}
	end,
	["lua_ls"] = function()
		require('neodev').setup()
		require('lspconfig').lua_ls.setup {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			}
		}
	end,
	["pylsp"] = function()
		require('lspconfig').pylsp.setup {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				pylsp = {
					plugins = {
						rope_autoimport = {
							completions = {
								enabled = true
							},
							enabled = true,
							memory = true
						}
					}
				}
			},
		}
	end,
	["pyright"] = function()
		require('lspconfig').pyright.setup {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "openFilesOnly",
						useLibraryCodeForTypes = true
					}
				}, cmd = {
				"pyright-langserver", "--stdio"
			},
				filetypes = {
					"python"
				},
				single_file_support = true
			}
		}
	end,
	["tsserver"] = function()
		require("lspconfig").tsserver.setup {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				completions = {
					completeFunctionCalls = true
				}
			}
		}
	end

	-- another example
	-- ["omnisharp"] = function()
	--     require('lspconfig').omnisharp.setup {
	--         filetypes = { "cs", "vb" },
	--         root_dir = require('lspconfig').util.root_pattern("*.csproj", "*.sln"),
	--         on_attach = on_attach,
	--         capabilities = capabilities,
	--         enable_roslyn_analyzers = true,
	--         analyze_open_documents_only = true,
	--         enable_import_completion = true,
	--     }
	-- end,
})

local pylsp = require('mason-registry').get_package('python-lsp-server')
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
		"pyls-memestra"
	}
	require("plenary.job")
		:new({
			command = command,
			args = args,
			cwd = path,
		})
		:start()
end)
