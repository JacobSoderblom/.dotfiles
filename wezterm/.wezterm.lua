local wezterm = require("wezterm")

return {
	-- Use Wayland if available
	enable_wayland = true,

	-- Font settings
	font = wezterm.font("Fira Code Nerd Font"),
	font_size = 11,

	-- Background opacity
	window_background_opacity = 0.75,

	-- Window size & padding
	initial_rows = 35,
	initial_cols = 95,
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},

	-- Disable OS window close confirmation
	window_close_confirmation = "NeverPrompt",

	-- Disable audio bell
	audible_bell = "Disabled",

	-- Colorscheme
	colors = {
		foreground = "#e0e0e0",
		background = "#0f0f0f",
		cursor_bg = "#e0e0e0",
		cursor_border = "#e0e0e0",
		cursor_fg = "#0f0f0f",
		selection_fg = nil,
		selection_bg = nil,

		-- Normal colors
		ansi = {
			"#151720", -- black
			"#dd6777", -- red
			"#90ceaa", -- green
			"#ecd3a0", -- yellow
			"#86aaec", -- blue
			"#c296eb", -- magenta
			"#93cee9", -- cyan
			"#cbced3", -- white
		},

		-- Bright colors
		brights = {
			"#4f5572", -- bright black (gray)
			"#e26c7c", -- bright red
			"#95d3af", -- bright green
			"#f1d8a5", -- bright yellow
			"#8baff1", -- bright blue
			"#c79bf0", -- bright magenta
			"#98d3ee", -- bright cyan
			"#d0d3d8", -- bright white
		},

		-- URL highlight color
		hyperlink_rules = {
			{
				regex = [[\b\w+://[\w.-]+\S*]],
				format = "$0",
				color = "#5de4c7",
			},
		},
	},
}
