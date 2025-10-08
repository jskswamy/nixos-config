return {
	-- add gruvbox-material colorscheme (official Material variant)
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			-- Configure gruvbox-material
			vim.g.gruvbox_material_background = "medium" -- 'hard', 'medium'(default), 'soft'
			vim.g.gruvbox_material_foreground = "material" -- 'material', 'mix', 'original'
			vim.g.gruvbox_material_disable_italic_comment = 0
			vim.g.gruvbox_material_enable_italic = 1
			vim.g.gruvbox_material_enable_bold = 1
			vim.g.gruvbox_material_transparent_background = 0
			vim.g.gruvbox_material_visual = "grey background" -- 'grey background', 'green background', 'blue background', 'red background', 'reverse'
			vim.g.gruvbox_material_menu_selection_background = "blue" -- 'grey', 'red', 'orange', 'yellow', 'green', 'aqua', 'blue', 'purple'
			vim.g.gruvbox_material_sign_column_background = "none" -- 'none', 'grey'
			vim.g.gruvbox_material_better_performance = 1

			-- Apply the colorscheme
			vim.cmd.colorscheme("gruvbox-material")

			-- Additional theme customizations for better integration
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "gruvbox-material",
				callback = function()
					-- Ensure terminal colors match Gruvbox Material
					vim.g.terminal_color_0 = "#504945" -- black
					vim.g.terminal_color_1 = "#fb4934" -- red
					vim.g.terminal_color_2 = "#b8bb26" -- green
					vim.g.terminal_color_3 = "#fabd2f" -- yellow
					vim.g.terminal_color_4 = "#83a598" -- blue
					vim.g.terminal_color_5 = "#d3869b" -- magenta
					vim.g.terminal_color_6 = "#8ec07c" -- cyan
					vim.g.terminal_color_7 = "#d5c4a1" -- white
					vim.g.terminal_color_8 = "#7c6f64" -- bright black
					vim.g.terminal_color_9 = "#fb4934" -- bright red
					vim.g.terminal_color_10 = "#b8bb26" -- bright green
					vim.g.terminal_color_11 = "#fabd2f" -- bright yellow
					vim.g.terminal_color_12 = "#83a598" -- bright blue
					vim.g.terminal_color_13 = "#d3869b" -- bright magenta
					vim.g.terminal_color_14 = "#8ec07c" -- bright cyan
					vim.g.terminal_color_15 = "#d5c4a1" -- bright white
				end,
			})
		end,
	},

	-- Configure LazyVim to load gruvbox-material
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "gruvbox-material",
		},
	},
}
