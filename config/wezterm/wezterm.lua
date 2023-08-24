local wezterm = require("wezterm")
local hostname = wezterm.hostname()

local arch, os_name = (function()
	local i1 = string.find(wezterm.target_triple, "-")
	local arch = string.sub(wezterm.target_triple, 1, i1 - 1)
	local i2 = string.find(wezterm.target_triple, "-", i1 + 1)
	local i3 = string.find(wezterm.target_triple, "-", i2 + 1)
	local os
	if i3 then
		os = string.sub(wezterm.target_triple, i2 + 1, i3 - 1)
	else
		os = string.sub(wezterm.target_triple, i2 + 1)
	end

	return arch, os
end)()
_ = arch
_ = os_name

wezterm.GLOBAL.bells = {}

local BELL = "🔔"

local function tab_title(tab, max_width)
	local bell = wezterm.GLOBAL.bells[tostring(tab.tab_id)] == tab.tab_id and BELL or ""
	return wezterm.truncate_right(bell .. string.gsub(tab.active_pane.title, "(.*: )(.*)", "%2"), max_width - 2)
end

wezterm.on("format-tab-title", function(
	tab,
	_, --[[ tabs ]]
	_, --[[ panes ]]
	_, --[[ config ]]
	_, --[[ hover ]]
	max_width
)
	wezterm.GLOBAL.bells[tostring(wezterm.mux.get_window(tab.window_id):active_tab():tab_id())] = nil
	return " " .. tab_title(tab, max_width) .. " "
end)

wezterm.on("bell", function(window, pane)
	local tab = pane:tab():tab_id()
	if window:active_tab():tab_id() ~= tab then
		wezterm.GLOBAL.bells[tostring(tab)] = tab
	end
end)

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.term = "xterm-kitty"

config.ssh_domains = wezterm.default_ssh_domains()
for _, dom in ipairs(config.ssh_domains) do
	dom.assume_shell = "Posix"
end

if hostname ~= "vercingetorige" then
	table.insert(config.ssh_domains, {
		name = "vercingetorige",
		remote_address = "vercingetorige.local",
		multiplexing = "WezTerm",
		assume_shell = "Posix",
	})
end

if hostname ~= "DomPerignon" then
	table.insert(config.ssh_domains, {
		name = "DomPerignon",
		remote_address = "DomPerignon.local",
		multiplexing = "WezTerm",
		assume_shell = "Posix",
	})
end

if hostname ~= "filottete" then
	table.insert(config.ssh_domains, {
		name = "filottete",
		remote_address = "filottete.local",
		multiplexing = "None",
		assume_shell = "Posix",
	})
end

config.mux_env_remove = {}

config.front_end = "WebGpu"

config.window_decorations = os_name == "linux" and "NONE" or "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.use_ime = true

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true

config.audible_bell = "SystemBeep"
config.enable_wayland = true

config.allow_square_glyphs_to_overflow_width = "Always"
config.harfbuzz_features = {
	"ss01",
	"ss02",
	"ss03",
	"ss04",
	"ss05",
	"ss06",
	"zero",
	"onum",
}
config.font = wezterm.font_with_fallback({
	"CommitMono",
	"Hack Nerd Font Mono",
	"JetBrains Mono",
	"Noto Color Emoji",
	"Symbols Nerd Font Mono",
})
config.font_size = os_name == "linux" and 10 or 11

config.default_cursor_style = "SteadyBar"

-- config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = true

config.colors = {
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
}

local cpmods = os_name == "darwin" and "CMD" or "CTRL|SHIFT"

config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
local keys = {
	{
		key = "q",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "h",
		mods = "CTRL|LEADER",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "l",
		mods = "CTRL|LEADER",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "|",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "|",
		mods = "SHIFT|LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = " ",
		mods = "LEADER",
		action = wezterm.action.ShowLauncher,
	},
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendString("\x01"),
	},
	{
		key = ":",
		mods = "SHIFT|LEADER",
		action = wezterm.action.ShowDebugOverlay,
	},
	{
		key = ":",
		mods = "LEADER",
		action = wezterm.action.ShowDebugOverlay,
	},
	{
		key = "v",
		mods = cpmods,
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "c",
		mods = cpmods,
		action = wezterm.action.CopyTo("Clipboard"),
	},
}
if os_name == "darwin" then
	table.insert(keys, {
		key = ",",
		mods = "CTRL",
		action = wezterm.action.SendString("\27[44;5u"),
	})
	table.insert(keys, {
		key = ",",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SendString("\27[44;6u"),
	})
end
config.keys = keys

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
