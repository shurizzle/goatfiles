local wezterm = require("wezterm")

return {
	window_decorations = "RESIZE",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	use_ime = true,
	enable_tab_bar = false,
	audible_bell = "Disabled",
	enable_wayland = false,
	font = wezterm.font_with_fallback({
		{ family = "Hack FC Ligatured", harfbuzz_features = { "calt=1", "clig=1", "liga=1" } },
		"JetBrains Mono",
		{ family = "Noto Color Emoji", harfbuzz_features = { "calt=1", "clig=1", "liga=1" } },
		"Symbols Nerd Font Mono",
		"Last Resort High-Efficiency",
	}),
	font_size = wezterm.target_triple == "x86_64-unknown-linux-gnu" and 9 or 11,

	colors = {
		background = "#282828",
		foreground = "#eeeeee",

		cursor_bg = "#ffffff",
		cursor_fg = "#000000",

		cursor_border = "#ffffff",

		ansi = {
			"#282828",
			"#c8213d",
			"#169C51",
			"#DAAF19",
			"#2F90FE",
			"#C14ABE",
			"#48C6DB",
			"#CBCBCB",
		},
		brights = {
			"#505050",
			"#C7213D",
			"#1ef15f",
			"#FFE300",
			"#00aeff",
			"#FF40BE",
			"#48FFFF",
			"#ffffff",
		},
	},
	keys = {
		{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
	},
	mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
}
