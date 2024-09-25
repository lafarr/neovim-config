return {
	'nvim-telescope/telescope.nvim',
	dependencies = {
		'nvim-telescope/telescope-ui-select.nvim',
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
	},
	lazy = false,
	keys = {
		{ '<leader>km', '<cmd>Telescope keymaps<cr>', desc = 'Telescope: [K]eymaps [S]earch' },
		{ '<leader>pf', function() require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--no-ignore-vcs', '--hidden' } }) end, desc = 'Telescope: Search project files' },
		{ '<leader>ws', function() require('telescope.builtin').live_grep() end,                 desc = 'Telescope: Workspace search' },
		{ '<leader>fs', function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = 'Telescope: File search' },
		{ '/', function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = 'Telescope: File search' },
		{ '<leader>ol', function() require('telescope.builtin').lsp_document_symbols() end,      desc = 'Telescope: Document outline' },
		{ '<leader>wol', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end,     desc = 'Telescope: Workspace outline' },
		{ '<leader>fu', function() require('telescope.builtin').lsp_references() end,            desc = 'Telescope: Find usages' },
		{ '<leader>gd', function() require('telescope.builtin').lsp_definitions() end,           desc = 'Telescope: Go to definition' },
		{ '<leader>gi', function() require('telescope.builtin').lsp_implementations() end,       desc = 'Telescope: Go to implementations' },
		{ '<leader>gt', function() require('telescope.builtin').lsp_type_definitions() end,      desc = 'Telescope: Go to type definitions' },
		{ '<leader>ds', function() require('telescope.builtin').diagnostics() end,               desc = 'Telescope: Diagnostics search' },
		{ '<leader>hp', function() require('telescope.builtin').help_tags() end,               desc = 'Telescope: Search help' },
		{ '<leader>cs', function() require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' } end, desc = 'Telescope: Search config files' }
	},

	config = function()
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({})
				},
				fzf = {
					fuzzy = false,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "ignore_case",
				}
			},
			pickers = {
				find_files = {
					previewer = false,
					theme = 'dropdown'
				}
			}
		})
		require("telescope").load_extension("ui-select")
		require("telescope").load_extension("fzf")
	end
}
