return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		filesystem = {
			filtered_items = {
				visible = true, -- when true, they will just be displayed differently than normal items
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_hidden = false, -- only works on Windows for hidden files/directories
			},
			hijack_netrw_behavior = "disabled",
		},
	},
	keys = {
		{ '<leader>ft', '<cmd>Neotree toggle<cr>', desc = 'Neotree: [F]ile [T]ree' }
	}
}
