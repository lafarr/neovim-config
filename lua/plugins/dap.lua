return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		{
			"mfussenegger/nvim-dap",
			lazy = false,
			config = function()
				local dap = require('dap')
				dap.adapters.codelldb = {
					type = 'server',
					port = 13000,
					executable = {
						command = '/home/james/Downloads/codelldb-x86_64-linux/extension/adapter/codelldb',
						args = { "--port", 13000 }
					}
				}

				dap.adapters.python = function(cb, config)
					if config.request == 'attach' then
						---@diagnostic disable-next-line: undefined-field
						local port = (config.connect or config).port
						---@diagnostic disable-next-line: undefined-field
						local host = (config.connect or config).host or '127.0.0.1'
						cb({
							type = 'server',
							port = assert(port, '`connect.port` is required for a python `attach` configuration'),
							host = host,
							options = {
								source_filetype = 'python',
							},
						})
					else
						cb({
							type = 'executable',
							command = '/home/james/.virtualenvs/debugpy/bin/python',
							args = { '-m', 'debugpy.adapter' },
							options = {
								source_filetype = 'python',
							},
						})
					end
				end


				dap.adapters.coreclr = {
					type = 'executable',
					command = '/usr/local/netcoredbg',
					args = { '--interpreter=vscode' }
				}


				dap.configurations.cpp = {
					{
						name = "Launch file",
						type = "codelldb",
						request = "launch",
						program = function()
							return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
						end,
						cwd = '${workspaceFolder}',
						stopOnEntry = false,
					},
				}

				dap.configurations.c = {
					{
						name = "Launch file",
						type = "codelldb",
						request = "launch",
						program = function()
							return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
						end,
						cwd = '${workspaceFolder}',
						stopOnEntry = false,
					},
				}

				dap.configurations.python = {
					{
						-- The first three options are required by nvim-dap
						type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
						request = 'launch',
						name = "Launch file",

						-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

						program = "${file}", -- This configuration will launch the current file if used.
						pythonPath = function()
							-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
							-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
							-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
							local cwd = vim.fn.getcwd()
							if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
								return cwd .. '/venv/bin/python'
							elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
								return cwd .. '/.venv/bin/python'
							else
								return '/usr/bin/python3'
							end
						end,
					},
				}

				dap.configurations.cs = {
					{
						type = "coreclr",
						name = "launch - netcoredbg",
						request = "launch",
						program = function()
							-- Prevent debugger on previous version of file
							vim.cmd('w');
							vim.cmd('!dotnet build')
							return vim.fn.getcwd() .. '/bin/Debug/net8.0/' .. vim.fn.getcwd():match("([^/]+)$") .. '.dll'
						end,
					},
				}
			end
		},
		{ "nvim-neotest/nvim-nio" },
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
		{                                  -- optional completion source for require statements and module annotations
			"hrsh7th/nvim-cmp",
			opts = function(_, opts)
				opts.sources = opts.sources or {}
				table.insert(opts.sources, {
					name = "lazydev",
					group_index = 0, -- set group index to 0 to skip loading LuaLS completions
				})
			end,
		},
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		local dapui_open = false

		-- Call dapui.setup(), so we can just open without calling setup every time we run the debugger
		vim.api.nvim_create_autocmd('VimEnter', {
			desc = 'Setup dap-ui when entering opening vim',
			group = vim.api.nvim_create_augroup('dap-ui-setup', { clear = true }),
			callback = function()
				require('dapui').setup()
			end,
		})

		-- Close dapui automatically when debugging session terminates
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
			dapui_open = false
		end

		vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
		vim.keymap.set('n', '<F1>', function()
			dap.continue()
			if not dapui_open then
				dapui.open()
				dapui_open = true
			end
		end, { desc = 'Dap: Start debugging/continue to next breakpoint' })
		vim.keymap.set('n', '<F2>', dap.step_into, { desc = 'Dap: Step into in debugger' })
		vim.keymap.set('n', '<F3>', dap.step_over, { desc = 'Dap: Step over in debugger' })
		vim.keymap.set('n', '<F4>', dap.step_out, { desc = 'Dap: Step out in debugger' })
		vim.keymap.set('n', '<F5>', dap.step_back, { desc = 'Dap: Step back in debugger' })
		vim.keymap.set('n', '<F12>', function()
			dap.terminate()
		end, { desc = 'Dap: Stop debugging & close ui' })
	end
}
