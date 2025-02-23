local wezterm = require("wezterm")

return {
	use_ime = true,
	color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
	term = "xterm-256color",
	window_background_opacity = 0.6,
	hide_tab_bar_if_only_one_tab = true,
	font = wezterm.font("Fira Code Nerd Font"),
}
