local wezterm = require("wezterm")

return {
	-- Use Wayland if available
	enable_wayland = true,

	-- Font settings
	font = wezterm.font("Fira Code Nerd Font"),
	font_size = 11,

	-- Background opacity
	-- window_background_opacity = 0.75,

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

        -- Colorscheme: GitHub Dark High Contrast
        colors = {
                foreground = "#f0f6fc",
                background = "#0a0c10",
                cursor_bg = "#f0f6fc",
                cursor_border = "#f0f6fc",
                cursor_fg = "#0a0c10",
                selection_fg = "#0a0c10",
                selection_bg = "#79c0ff",

                -- Normal colors
                ansi = {
                        "#0a0c10", -- black
                        "#ff7b72", -- red
                        "#3fb950", -- green
                        "#d29922", -- yellow
                        "#58a6ff", -- blue
                        "#bc8cff", -- magenta
                        "#39c5cf", -- cyan
                        "#c9d1d9", -- white
                },

                -- Bright colors
                brights = {
                        "#484f58", -- bright black
                        "#ffa198", -- bright red
                        "#56d364", -- bright green
                        "#e3b341", -- bright yellow
                        "#79c0ff", -- bright blue
                        "#d2a8ff", -- bright magenta
                        "#56d4dd", -- bright cyan
                        "#f0f6fc", -- bright white
                },

                -- URL highlight color
                hyperlink_rules = {
                        {
                                regex = [[\b\w+://[\w.-]+\S*]],
                                format = "$0",
                                color = "#79c0ff",
                        },
                },
        },
}
