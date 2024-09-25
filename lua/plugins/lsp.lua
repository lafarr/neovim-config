-- Force the background color for floating windows
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local normal_bg = vim.api.nvim_get_hl_by_name("Normal", true).background
		if normal_bg then
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = string.format("#%06x", normal_bg) })
			vim.api.nvim_set_hl(0, "FloatBorder", { fg = "white", bg = string.format("#%06x", normal_bg) })
		end
	end,
})

vim.diagnostic.config {     
    float = { border = "rounded" },
}

return {
	'VonHeikemen/lsp-zero.nvim',
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/nvim-cmp',
		'neovim/nvim-lspconfig',
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-buffer"
	},
	lazy = false,
	config = function()
		local cmp = require 'cmp'
		cmp.setup({
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
				['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
				['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),
			sources = cmp.config.sources({
				{ name = 'luasnip' }
			}, {
				{ name = 'buffer' },
			}, { { name = 'nvim_lsp' } })
		})

		cmp.setup.cmdline({ '/', '?' }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = 'buffer' }
			}
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'path' }
			}, {
				{ name = 'cmdline' }
			}),
			matching = { disallow_symbol_nonprefix_matching = false }
		})

		local lsp_zero = require('lsp-zero')

		-- lsp_attach is where you enable features that only work
		-- if there is a language server active in the file
		local lsp_attach = function(client, bufnr)
			local opts = { buffer = bufnr }
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
			vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
			vim.keymap.set('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
			vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
			vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
			vim.keymap.set({ 'n', 'x' }, '<leader>fd', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
			vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
		end

		lsp_zero.extend_lspconfig({
			sign_text = true,
			lsp_attach = lsp_attach,
			capabilities = require('cmp_nvim_lsp').default_capabilities(),
		})

		require('mason').setup({})
		require('mason-lspconfig').setup({
			ensure_installed = {
				'lua_ls',
				'clangd',
				'omnisharp',
				'ts_ls',
				'pyright',
				'sqls',
				'bashls',
				'asm_lsp',
				'cssls',
				'tailwindcss',
				'cssmodules_ls',
				'jinja_lsp',
				'gopls',
				'html',
				'jsonls'
			},
			handlers = {
				function(server_name)
					local settings = nil
					if server_name == 'lua_ls' then
						settings = {
							Lua = {
								runtime = { version = 'JuaJIT' },
								workspace = {
									checkThirdParty = false,
									library = vim.api.nvim_get_runtime_file('lua', true)
								},
								diagnostics = {
									globals = {
										"vim"
									}
								}
							}
						}
					end
					require('lspconfig')[server_name].setup({
						settings,
						handlers = {
							["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
								border = "rounded",
							}),
							["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
								border = "rounded",
							}),
						}
					})
				end,
			},
		})
	end
}
