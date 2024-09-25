return {
	"mbbill/undotree",
	config = function()
		vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Undotree: Toggle [u]ndotree'})

		vim.opt.backup = false
		vim.opt.swapfile = false
		vim.opt.undodir = '/home/james/.undodir'
		vim.opt.undofile = true
	end
}
