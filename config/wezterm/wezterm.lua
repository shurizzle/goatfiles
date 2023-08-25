local wezterm = require("wezterm")
local hostname = wezterm.hostname()
local arc, os = nil, nil
do
  local hostname0 = wezterm.hostname()
  local i1 = string.find(wezterm.target_triple, "-")
  local arch = string.sub(wezterm.target_triple, 1, (i1 - 1))
  local i2 = string.find(wezterm.target_triple, "-", (i1 + 1))
  local i3 = string.find(wezterm.target_triple, "-", (i2 + 1))
  local os0
  if i3 then
    os0 = string.sub(wezterm.target_triple, (i2 + 1), (i3 - 1))
  else
    os0 = string.sub(wezterm.target_triple, (i2 + 1))
  end
  arc, os = arch, os0
end
wezterm.GLOBAL.bells = {}
local _2abell_2a = "\240\159\148\148"
local function tab_title(tab, max_width)
  local function _2_()
    if (wezterm.GLOBAL.bells[tostring(tab.tab_id)] == tab.tab_id) then
      return _2abell_2a
    else
      return ""
    end
  end
  return wezterm.truncate_right((_2_() .. string.gsub(tab.active_pane.title, "(.*: )(.*)", "%2")), (max_width - 2))
end
local function _3_(tab, _, _0, _1, _2, max_width)
  wezterm.GLOBAL.bells[tostring(wezterm.mux.get_window(tab.window_id):active_tab():tab_id())] = nil
  return (" " .. tab_title(tab, max_width) .. " ")
end
wezterm.on("format-tab-title", _3_)
local function _4_(window, pane)
  local tab = pane:tab():tab_id()
  if (window:active_tab():tab_id() ~= tab) then
    wezterm.GLOBAL.bells[tostring(tab)] = tab
    return nil
  else
    return nil
  end
end
wezterm.on("bell", _4_)
local config
if wezterm.config_builder then
  config = wezterm.config_builder()
else
  config = {}
end
config.term = "xterm-kitty"
local function ssh_domains()
  local ds = wezterm.default_ssh_domains()
  for _, dom in ipairs(ds) do
    dom.assume_shell = "Posix"
  end
  for _, name in ipairs({"vercingetorige", "DomPerignon", "filottete"}) do
    if (name ~= hostname) then
      local _7_
      if (name == "filottete") then
        _7_ = "None"
      else
        _7_ = "WezTerm"
      end
      table.insert(ds, {name = name, remote_address = (name .. ".local"), multiplexing = _7_, assume_shell = "Posix"})
    else
    end
  end
  return ds
end
config.ssh_domains = ssh_domains()
config.mux_env_remove = {}
config.front_end = "WebGpu"
if (os == "linux") then
  config.window_decorations = "NONE"
else
  config.window_decorations = "RESIZE"
end
config.window_padding = {left = 0, right = 0, top = 0, bottom = 0}
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
config.harfbuzz_features = {"ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "zero", "onum"}
config.font = wezterm.font_with_fallback({"CommitMono", "Hack Nerd Font Mono", "JetBrains Mono", "Noto Color Emoji", "Symbols Nerd Font Mono"})
if (os == "linux") then
  config.font_size = 10
else
  config.font_size = 11
end
config.default_cursor_style = "SteadyBar"
config.enable_csi_u_key_encoding = true
config.colors = {background = "#282828", foreground = "#eeeeee", cursor_bg = "#ffffff", cursor_fg = "#000000", cursor_border = "#ffffff", ansi = {"#282828", "#c8213d", "#169C51", "#DAAF19", "#2F90FE", "#C14ABE", "#48C6DB", "#CBCBCB"}, brights = {"#505050", "#C7213D", "#1ef15f", "#FFE300", "#00aeff", "#FF40BE", "#48FFFF", "#ffffff"}}
local cpmods
if (os == "darwin") then
  cpmods = "CMD"
else
  cpmods = "CTRL|SHIFT"
end
config.disable_default_key_bindings = true
config.leader = {key = "a", mods = "CTRL", timeout_milliseconds = 1000}
local function common_keys()
  return {{key = "q", mods = "LEADER", action = wezterm.action.CloseCurrentPane({confirm = true})}, {key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain")}, {key = "h", mods = "CTRL|LEADER", action = wezterm.action.ActivateTabRelative(-1)}, {key = "l", mods = "CTRL|LEADER", action = wezterm.action.ActivateTabRelative(1)}, {key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left")}, {key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down")}, {key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up")}, {key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right")}, {key = "|", mods = "LEADER", action = wezterm.action.SplitHorizontal({domain = "CurrentPaneDomain"})}, {key = "|", mods = "SHIFT|LEADER", action = wezterm.action.SplitHorizontal({domain = "CurrentPaneDomain"})}, {key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({domain = "CurrentPaneDomain"})}, {key = " ", mods = "LEADER", action = wezterm.action.ShowLauncher}, {key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendString("\1")}, {key = ":", mods = "SHIFT|LEADER", action = wezterm.action.ShowDebugOverlay}, {key = ":", mods = "LEADER", action = wezterm.action.ShowDebugOverlay}, {key = "v", mods = cpmods, action = wezterm.action.PasteFrom("Clipboard")}, {key = "c", mods = cpmods, action = wezterm.action.CopyTo("Clipboard")}}
end
local function macos_keys()
  if (os == "darwin") then
    return {{key = ",", mods = "CTRL", action = wezterm.action.SendString("\27[44;5u")}, {key = ",", mods = "CTRL|SHIFT", action = wezterm.action.SendString("\27[44;6u")}}
  else
    return {}
  end
end
do
  local keys = common_keys()
  for _, k in ipairs(macos_keys()) do
    table.insert(keys, k)
  end
  config.keys = keys
end
config.mouse_bindings = {{event = {Up = {streak = 1, button = "Left"}}, mods = "CTRL", action = wezterm.action.OpenLinkAtMouseCursor}}
return config
