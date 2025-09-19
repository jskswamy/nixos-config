return {
	-- Claude Code integration for Neovim
	{
		"greggh/claude-code.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeVerbose" },
		keys = {
			-- Use <leader>ai prefix to avoid conflicts with LazyVim's <leader>c (code) prefix
			{ "<leader>ait", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code Terminal" },
			{ "<leader>aic", "<cmd>ClaudeCodeContinue<cr>", desc = "Continue Claude Conversation" },
			{ "<leader>aiv", "<cmd>ClaudeCodeVerbose<cr>", desc = "Claude Code Verbose Mode" },

			-- Alternative quick access with Ctrl+Alt combination (less likely to conflict)
			{ "<C-A-c>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code Terminal", mode = { "n", "t" } },
		},
		opts = {
			window = {
				-- Right vertical split taking 25% width, full height
				split_ratio = 0.25,
				position = "vertical",
				enter_insert = true,
				hide_numbers = true,
				hide_signcolumn = true,
			},
			command = "claude",
			-- Disable default keymaps to avoid conflicts
			keymaps = {
				toggle = {
					normal = false, -- Disable default <C-,>
					terminal = false,
				},
			},
		},
		config = function(_, opts)
			require("claude-code").setup(opts)

			-- Add which-key descriptions for better UX
			local wk = require("which-key")
			wk.add({
				{ "<leader>ai", group = "AI/Claude" },
				{ "<leader>ait", desc = "Toggle Claude Terminal" },
				{ "<leader>aic", desc = "Continue Conversation" },
				{ "<leader>aiv", desc = "Verbose Mode" },
			})

			-- Terminal mode keybindings for better navigation
			vim.api.nvim_create_autocmd("TermOpen", {
				pattern = "*",
				callback = function()
					local buf = vim.api.nvim_get_current_buf()
					local bufname = vim.api.nvim_buf_get_name(buf)

					-- Only apply to Claude terminal buffers
					if string.find(bufname, "claude") then
						-- Alt+n for normal mode (Option key configured as Alt in Alacritty)
						vim.keymap.set("t", "<A-n>", "<C-\\><C-n>", {
							buffer = buf,
							desc = "Exit to Normal Mode (for scrolling)",
						})

						-- Alt+t for quick toggle
						vim.keymap.set("t", "<A-t>", "<C-\\><C-n><cmd>ClaudeCode<cr>", {
							buffer = buf,
							desc = "Toggle Claude terminal",
						})
					end
				end,
			})

			-- Normal mode mappings for Claude terminal buffers
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function()
					local buf = vim.api.nvim_get_current_buf()
					local bufname = vim.api.nvim_buf_get_name(buf)

					-- Only apply to Claude terminal buffers in normal mode
					if string.find(bufname, "claude") and vim.bo[buf].buftype == "terminal" then
						-- Enter insert mode mappings
						vim.keymap.set("n", "i", "i", { buffer = buf, desc = "Enter Terminal Mode" })
						vim.keymap.set("n", "a", "a", { buffer = buf, desc = "Enter Terminal Mode" })
						vim.keymap.set("n", "I", "I", { buffer = buf, desc = "Enter Terminal Mode" })
						vim.keymap.set("n", "A", "A", { buffer = buf, desc = "Enter Terminal Mode" })

						-- Leader mappings work in normal mode
						vim.keymap.set("n", "<leader>ait", "<cmd>ClaudeCode<cr>", {
							buffer = buf,
							desc = "Toggle Claude Terminal",
						})
					end
				end,
			})
		end,
	},
}

