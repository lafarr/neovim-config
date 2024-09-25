return {
	"folke/trouble.nvim",
	opts = {}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	keys = {
		{
			"<leader>wd",
			"<cmd>Trouble diagnostics toggle focus=true win.position=bottom<cr>",
			desc = "Trouble: [W]orkspace [D]iagnostics",
		},
		{
			"<leader>dd",
			"<cmd>Trouble diagnostics toggle focus=true filter.buf=0 win.position=bottom<cr>",
			desc = "Trouble: [D]ocument [D]iagnostics",
		},
		{
			"<leader>tol",
			"<cmd>Trouble symbols toggle focus=true win.position=bottom<cr>",
			desc = "Trouble: [T]rouble [O]ut[L]ine",
		},
		{
			"<leader>li",
			"<cmd>Trouble lsp toggle focus=true win.position=bottom<cr>",
			desc = "Trouble: [L]SP [I]nfo",
		},
		{
			"<leader>tt",
			"<cmd>Trouble toggle<cr>",
			desc = "Trouble: [T]oggle [T]rouble",
		},
	},
}
