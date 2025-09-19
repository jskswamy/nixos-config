return {
	-- Configure blink.cmp for IntelliJ-style Tab completion
	{
		"saghen/blink.cmp",
		opts = {
			keymap = {
				-- IntelliJ-style Tab to accept completion
				["<Tab>"] = { "accept", "fallback" },
				
				-- Arrow keys for navigation
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				
				-- Additional navigation
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				
				-- Manual completion trigger
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				
				-- Documentation scrolling
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				
				-- Hide completion
				["<C-e>"] = { "hide", "fallback" },
				
				-- Enter only confirms if explicitly selected
				["<CR>"] = { "accept", "fallback" },
			},
			
			-- Trigger completion automatically
			trigger = {
				completion = {
					-- Show completion menu automatically
					show_on_insert_on_trigger_character = true,
				},
			},
			
			-- Accept configuration
			accept = {
				-- Auto-select first item for Tab completion
				auto_brackets = {
					enabled = true,
				},
			},
			
			-- Menu appearance
			menu = {
				-- Show completion menu
				auto_show = true,
				draw = {
					-- Show completion details
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				},
			},
			
			-- Documentation window
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
		},
	},
}