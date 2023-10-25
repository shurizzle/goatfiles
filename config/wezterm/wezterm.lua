package.preload["stdlib"] = package.preload["stdlib"] or function(...)
  local function _1_(x)
    return (nil == x)
  end
  _G.__fnl_global__nil_3f = _1_
  _G["nil?"] = _G.__fnl_global__nil_3f
  do local _ = {nil, nil} end
  local function _2_(x)
    return ("number" == type(x))
  end
  _G.__fnl_global__number_3f = _2_
  _G["number?"] = _G.__fnl_global__number_3f
  do local _ = {nil, nil} end
  local function _3_(x)
    return ("boolean" == type(x))
  end
  _G.__fnl_global__boolean_3f = _3_
  _G["boolean?"] = _G.__fnl_global__boolean_3f
  do local _ = {nil, nil} end
  local function _4_(x)
    return ("string" == type(x))
  end
  _G.__fnl_global__string_3f = _4_
  _G["string?"] = _G.__fnl_global__string_3f
  do local _ = {nil, nil} end
  local function _5_(x)
    return ("table" == type(x))
  end
  _G.__fnl_global__table_3f = _5_
  _G["table?"] = _G.__fnl_global__table_3f
  do local _ = {nil, nil} end
  local function _6_(x)
    return ("function" == type(x))
  end
  _G.__fnl_global__function_3f = _6_
  _G["function?"] = _G.__fnl_global__function_3f
  do local _ = {nil, nil} end
  local function _7_(t)
    assert(__fnl_global__table_3f(t), ("Expected table, got " .. type(t)))
    local tbl_17_auto = {}
    local i_18_auto = #tbl_17_auto
    for k, _ in pairs(t) do
      local val_19_auto = k
      if (nil ~= val_19_auto) then
        i_18_auto = (i_18_auto + 1)
        do end (tbl_17_auto)[i_18_auto] = val_19_auto
      else
      end
    end
    return tbl_17_auto
  end
  _G.keys = _7_
  local function _9_(t)
    assert(__fnl_global__table_3f(t), ("Expected table, got " .. type(t)))
    local tbl_17_auto = {}
    local i_18_auto = #tbl_17_auto
    for _, v in pairs(t) do
      local val_19_auto = v
      if (nil ~= val_19_auto) then
        i_18_auto = (i_18_auto + 1)
        do end (tbl_17_auto)[i_18_auto] = val_19_auto
      else
      end
    end
    return tbl_17_auto
  end
  _G.vals = _9_
  local function _11_(xs)
    if __fnl_global__table_3f(xs) then
      return __fnl_global__nil_3f(next(xs))
    elseif not xs then
      return true
    else
      return (0 == #xs)
    end
  end
  _G.__fnl_global__empty_3f = _11_
  _G["empty?"] = _G.__fnl_global__empty_3f
  do local _ = {nil, nil} end
  local function _13_(n)
    return (n + 1)
  end
  _G.inc = _13_
  local function _14_(n)
    return (n - 1)
  end
  _G.dec = _14_
  local function _15_(xs)
    if __fnl_global__table_3f(xs) then
      local c = 0
      for _, _0 in pairs(xs) do
        c = inc(c)
      end
      return c
    elseif not xs then
      return 0
    else
      return #xs
    end
  end
  _G.count = _15_
  local function _17_(n)
    return ((n % 2) == 0)
  end
  _G.__fnl_global__even_3f = _17_
  _G["even?"] = _G.__fnl_global__even_3f
  do local _ = {nil, nil} end
  local function _18_(n)
    return ((n % 2) ~= 0)
  end
  _G.__fnl_global__odd_3f = _18_
  _G["odd?"] = _G.__fnl_global__odd_3f
  do local _ = {nil, nil} end
  local function _19_(x)
    return x
  end
  _G.identity = _19_
  local function _20_(f, xs)
    for k, x in pairs(xs) do
      local result = f(x, k, xs)
      return result
    end
    return nil
  end
  _G.some = _20_
  local function _21_(x)
    local function _22_(_241, _242)
      return not __fnl_global__number_3f(_242)
    end
    return (__fnl_global__table_3f(x) and not some(_22_, x))
  end
  _G.__fnl_global__list_3f = _21_
  _G["list?"] = _G.__fnl_global__list_3f
  do local _ = {nil, nil} end
  local function _23_(v)
    local function _24_()
      return v
    end
    return _24_
  end
  _G.const = _23_
  local function _25_(s)
    return string.gsub(s, "^%s*(.-)", "%1")
  end
  _G.triml = _25_
  local function _26_(s)
    return string.gsub(s, "(.-)%s*$", "%1")
  end
  _G.trimr = _26_
  local function _27_(s)
    return string.gsub(s, "^%s*(.-)%s*$", "%1")
  end
  _G.trim = _27_
  local function copy_2a(x, cache)
    local _28_ = type(x)
    if (_28_ == "table") then
      if cache[x] then
        return cache[x]
      else
        local copy = {}
        local mt = getmetatable(x)
        do end (cache)[x] = copy
        for k, v in pairs(x) do
          copy[copy_2a(k, cache)] = copy_2a(v, cache)
        end
        return setmetatable(copy, mt)
      end
    elseif ((_28_ == "number") or (_28_ == "string") or (_28_ == "nil") or (_28_ == "boolean") or (_28_ == "function")) then
      return x
    elseif (nil ~= _28_) then
      local other = _28_
      return error(("Cannot deepcopy object of type " .. other))
    else
      return nil
    end
  end
  local function _31_(x)
    return copy_2a(x, {})
  end
  _G.copy = _31_
  local function _32_(...)
    local args = {...}
    local res = nil
    for _, v in pairs(args) do
      if not __fnl_global__nil_3f(v) then
        assert(__fnl_global__table_3f(v), ("Expected table, got " .. type(v)))
        if res then
          for _0, e in pairs(v) do
            table.insert(res, e)
          end
        else
          res = v
        end
      else
      end
    end
    return res
  end
  _G.__fnl_global__concat_21 = _32_
  _G["concat!"] = _G.__fnl_global__concat_21
  do local _ = {nil, nil} end
  local function _35_(...)
    local args = {...}
    local res = nil
    for _, v in pairs(args) do
      if not __fnl_global__nil_3f(v) then
        res = __fnl_global__concat_21((res or {}), v)
      else
      end
    end
    return res
  end
  _G.concat = _35_
  local function _37_(res, ...)
    local args = {...}
    local _38_
    if __fnl_global__empty_3f(args) then
      _38_ = not __fnl_global__nil_3f(res)
    else
      _38_ = true
    end
    if _38_ then
      assert(__fnl_global__table_3f(res), ("Expected table, got " .. type(res)))
    else
    end
    for _, tbl in pairs(args) do
      if not __fnl_global__nil_3f(tbl) then
        assert(__fnl_global__table_3f(tbl), ("Expected table, got " .. type(tbl)))
        for k, v in pairs(tbl) do
          res[k] = v
        end
      else
      end
    end
    return res
  end
  _G.__fnl_global__merge_21 = _37_
  _G["merge!"] = _G.__fnl_global__merge_21
  do local _ = {nil, nil} end
  local function can_merge(v)
    return (__fnl_global__table_3f(v) and (__fnl_global__empty_3f(v) or not __fnl_global__list_3f(v)))
  end
  local function _42_(...)
    local args = {...}
    local res = nil
    for _, tbl in pairs(args) do
      if not __fnl_global__nil_3f(tbl) then
        assert(__fnl_global__table_3f(tbl), ("Expected table, got " .. type(tbl)))
        if not res then
          res = {}
        else
        end
        for k, v in pairs(tbl) do
          if (can_merge(v) and can_merge(res[k])) then
            res[k] = __fnl_global__deep_2dmerge(res[k], v)
          else
            res[k] = v
          end
        end
      else
      end
    end
    return res
  end
  _G.__fnl_global__deep_2dmerge = _42_
  _G["deep-merge"] = _G.__fnl_global__deep_2dmerge
  do local _ = {nil, nil} end
  local function _46_(...)
    local args = {...}
    local _47_
    if __fnl_global__empty_3f(args) then
      _47_ = not __fnl_global__nil_3f(res)
    else
      _47_ = true
    end
    if _47_ then
      assert(__fnl_global__table_3f(res), ("Expected table, got " .. type(res)))
    else
    end
    for _, tbl in pairs(args) do
      if not __fnl_global__nil_3f(tbl) then
        assert(__fnl_global__table_3f(tbl), ("Expected table, got " .. type(tbl)))
        if res then
          for k, v in pairs(tbl) do
            if (can_merge(v) and can_merge(res[k])) then
              res[k] = __fnl_global__deep_2dmerge_21(res[k], v)
            else
              res[k] = copy(v)
            end
          end
        else
          res = tbl
        end
      else
      end
    end
    return res
  end
  _G.__fnl_global__deep_2dmerge_21 = _46_
  _G["deep-merge!"] = _G.__fnl_global__deep_2dmerge_21
  do local _ = {nil, nil} end
  local function _53_(s, prefix)
    assert(__fnl_global__string_3f(s), ("Expected string, got " .. type(s)))
    assert(__fnl_global__string_3f(prefix), ("Expected string, got " .. type(prefix)))
    return (s:sub(1, #prefix) == prefix)
  end
  _G.__fnl_global__starts_2dwith_3f = _53_
  _G["starts-with?"] = _G.__fnl_global__starts_2dwith_3f
  do local _ = {nil, nil} end
  local function _54_(s, prefix)
    if __fnl_global__starts_2dwith_3f(s, prefix) then
      return string.sub(s, inc(#prefix))
    else
      return nil
    end
  end
  _G.__fnl_global__strip_2dprefix = _54_
  _G["strip-prefix"] = _G.__fnl_global__strip_2dprefix
  do local _ = {nil, nil} end
  local function _56_(s, suffix)
    assert(__fnl_global__string_3f(s), ("Expected string, got " .. type(s)))
    assert(__fnl_global__string_3f(suffix), ("Expected string, got " .. type(suffix)))
    return ((0 == #suffix) or (s:sub(( - #suffix)) == suffix))
  end
  _G.__fnl_global__ends_2dwith_3f = _56_
  _G["ends-with?"] = _G.__fnl_global__ends_2dwith_3f
  do local _ = {nil, nil} end
  local function _57_(s, suffix)
    if __fnl_global__ends_2dwith_3f(s, suffix) then
      return string.sub(s, 1, (#s - #suffix))
    else
      return nil
    end
  end
  _G.__fnl_global__strip_2dsuffix = _57_
  _G["strip-suffix"] = _G.__fnl_global__strip_2dsuffix
  do local _ = {nil, nil} end
  local function _59_(path)
    local _60_, _61_ = io.open(path, "r")
    if ((_60_ == nil) and true) then
      local _msg = _61_
      return nil
    elseif (nil ~= _60_) then
      local f = _60_
      local content = f:read("*all")
      f:close()
      return content
    else
      return nil
    end
  end
  _G.slurp = _59_
  local function _63_(f)
    assert(__fnl_global__function_3f(f), ("Expected function, got " .. type(f)))
    local called = false
    local function _64_(...)
      if not called then
        called = true
        return f(...)
      else
        return nil
      end
    end
    return _64_
  end
  _G.once = _63_
  return nil
end
require("stdlib")
local wezterm = require("wezterm")
package.preload["platform"] = package.preload["platform"] or function(...)
  local wezterm = require("wezterm")
  local _local_67_ = os
  local getenv = _local_67_["getenv"]
  local arch, os = nil, nil
  do
    local i1 = string.find(wezterm.target_triple, "-")
    local arch0 = string.sub(wezterm.target_triple, 1, (i1 - 1))
    local i2 = string.find(wezterm.target_triple, "-", (i1 + 1))
    local i3 = string.find(wezterm.target_triple, "-", (i2 + 1))
    local os0
    if i3 then
      os0 = string.sub(wezterm.target_triple, (i2 + 1), (i3 - 1))
    else
      os0 = string.sub(wezterm.target_triple, (i2 + 1))
    end
    arch, os = string.lower(arch0), string.lower(os0)
  end
  local os0
  if ("darwin" == os) then
    os0 = "macos"
  else
    os0 = os
  end
  local _is = {win = (os0 == "windows"), lin = (os0 == "linux"), mac = (os0 == "macos"), fbsd = (os0 == "freebsd"), dfbsd = (os0 == "dragonflybsd"), nbsd = (os0 == "netbsd"), obsd = (os0 == "openbsd"), termux = not __fnl_global__nil_3f(getenv("TERMUX_APP_PID")), unknown = (os0 == "unknown")}
  for k, v in pairs({windows = "win", linux = "lin", macos = "mac", freebsd = "fbsd", dragonflybsd = "dfbsd", netbsd = "nbsd", openbsd = "obsd"}) do
    _is[k] = _is[v]
  end
  _is["bsd"] = (_is.mac or _is.fbsd or _is.dfbsd or _is.nbsd or _is.obsd)
  local function ro(t)
    local function _70_(_241, _242)
      return t[_242]
    end
    local function _71_()
      return nil
    end
    return setmetatable({}, {__index = _70_, __newindex = _71_})
  end
  return ro({os = os0, is = ro(_is), arch = arch})
end
local _local_66_ = require("platform")
local is = _local_66_["is"]
local config
if wezterm.config_builder then
  config = wezterm.config_builder()
else
  config = {}
end
if is.windows then
  config.default_prog = {"pwsh"}
else
end
config.mux_env_remove = {}
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = true
package.preload["domains"] = package.preload["domains"] or function(...)
  local wezterm = require("wezterm")
  local function ssh_domains()
    local ds = wezterm.default_ssh_domains()
    for _, dom in ipairs(ds) do
      dom.assume_shell = "Posix"
    end
    for _, name in ipairs({"vercingetorige", "DomPerignon", "filottete"}) do
      if (name ~= wezterm.hostname()) then
        local _75_
        if (name == "filottete") then
          _75_ = "None"
        else
          _75_ = "WezTerm"
        end
        table.insert(ds, {name = name, remote_address = (name .. ".local"), multiplexing = _75_, assume_shell = "Posix"})
      else
      end
    end
    return ds
  end
  return {ssh_domains = ssh_domains()}
end
local function _78_(...)
  local _74_ = require("domains")
  return _74_
end
__fnl_global__merge_21(config, _78_(...))
package.preload["font"] = package.preload["font"] or function(...)
  local wezterm = require("wezterm")
  local _local_80_ = require("platform")
  local is = _local_80_["is"]
  local _81_
  if (is.lin or is.win) then
    _81_ = 10
  else
    _81_ = 11
  end
  return {allow_square_glyphs_to_overflow_width = "Always", harfbuzz_features = {"ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "zero", "onum"}, font = wezterm.font_with_fallback({"CommitMono", "Hack Nerd Font Mono", "JetBrains Mono", "Noto Color Emoji", "Symbols Nerd Font Mono"}), font_size = _81_, warn_about_missing_glyphs = false}
end
local function _83_(...)
  local _79_ = require("font")
  return _79_
end
__fnl_global__merge_21(config, _83_(...))
package.preload["ui"] = package.preload["ui"] or function(...)
  local wezterm = require("wezterm")
  local _local_85_ = require("platform")
  local is = _local_85_["is"]
  local _local_86_ = require("bell")
  local update_bell = _local_86_["update"]
  local bell_3f = _local_86_["bell?"]
  local function tab_title(tab, max_width)
    local function _95_()
      if bell_3f(tab.window_id, tab.tab_id) then
        return "\240\159\148\148"
      else
        return ""
      end
    end
    return wezterm.truncate_right((_95_() .. string.gsub(tab.active_pane.title, "(.*: )(.*)", "%2")), (max_width - 2))
  end
  local function _96_(tab, _, _0, _1, _2, max_width)
    update_bell(tab.window_id)
    return (" " .. tab_title(tab, max_width) .. " ")
  end
  wezterm.on("format-tab-title", _96_)
  local _97_
  if is.linux then
    _97_ = "NONE"
  else
    _97_ = "RESIZE"
  end
  return {front_end = "WebGpu", window_decorations = _97_, window_padding = {left = 0, right = 0, top = 0, bottom = 0}, use_ime = true, enable_tab_bar = true, hide_tab_bar_if_only_one_tab = true, tab_bar_at_bottom = true, audible_bell = "SystemBeep", enable_wayland = true, default_cursor_style = "SteadyBar", show_new_tab_button_in_tab_bar = false, show_tab_index_in_tab_bar = false, use_fancy_tab_bar = false}
end
package.preload["bell"] = package.preload["bell"] or function(...)
  local wezterm = require("wezterm")
  wezterm.GLOBAL.bells = {}
  local function update(win_id)
    local _87_ = wezterm.GLOBAL.bells[tostring(win_id)]
    if (nil ~= _87_) then
      _87_[tostring(wezterm.mux.get_window(win_id):active_tab():tab_id())] = nil
      return nil
    else
      return _87_
    end
  end
  local function _89_(window, pane)
    local win_id = window:window_id()
    local tab_id = pane:tab():tab_id()
    if (window:active_tab():tab_id() ~= tab_id) then
      wezterm.GLOBAL.bells[tostring(win_id)] = (wezterm.GLOBAL.bells[tostring(win_id)] or {})
      do end (wezterm.GLOBAL.bells[tostring(win_id)])[tostring(tab_id)] = tab_id
      return nil
    else
      return nil
    end
  end
  wezterm.on("bell", _89_)
  local function bell_3f(win_id, tab_id)
    local _92_
    do
      local t_91_ = wezterm.GLOBAL.bells
      if (nil ~= t_91_) then
        t_91_ = (t_91_)[tostring(win_id)]
      else
      end
      if (nil ~= t_91_) then
        t_91_ = (t_91_)[tostring(tab_id)]
      else
      end
      _92_ = t_91_
    end
    return (_92_ == tab_id)
  end
  return {update = update, ["bell?"] = bell_3f}
end
local function _99_(...)
  local _84_ = require("ui")
  return _84_
end
__fnl_global__merge_21(config, _99_(...))
package.preload["theme"] = package.preload["theme"] or function(...)
  local wezterm = require("wezterm")
  local black = "#282828"
  local white = "#eeeeee"
  local ansi = {"#282828", "#c8213d", "#169C51", "#DAAF19", "#2F90FE", "#C14ABE", "#48C6DB", "#CBCBCB"}
  local brights = {"#505050", "#C7213D", "#1ef15f", "#FFE300", "#00aeff", "#FF40BE", "#48FFFF", "#ffffff"}
  local visual_bell = "#FFE300"
  local dark = {background = black, foreground = white, cursor_bg = white, cursor_fg = black, cursor_border = white, ansi = ansi, brights = brights, visual_bell = visual_bell}
  local light = {background = white, foreground = black, cursor_bg = black, cursor_fg = white, cursor_border = black, ansi = ansi, brights = brights, visual_bell = visual_bell}
  local function get_appearance()
    if wezterm.gui then
      return wezterm.gui.get_appearance()
    else
      return "Dark"
    end
  end
  local function colorscheme(appearance)
    if ((appearance or get_appearance())):match("Light") then
      return "BlueSky Light"
    else
      return "BlueSky Dark"
    end
  end
  local function _103_(window, pane)
    local overrides = (window:get_config_overrides() or {})
    local scheme = colorscheme(window:get_appearance())
    if (overrides.color_scheme ~= scheme) then
      overrides.color_scheme = scheme
      return window:set_config_overrides(overrides)
    else
      return nil
    end
  end
  wezterm.on("window-config-reloaded", _103_)
  return {color_scheme = colorscheme(), color_schemes = {["BlueSky Dark"] = dark, ["BlueSky Light"] = light}}
end
local function _105_(...)
  local _100_ = require("theme")
  return _100_
end
__fnl_global__merge_21(config, _105_(...))
package.preload["keys"] = package.preload["keys"] or function(...)
  local wezterm = require("wezterm")
  local act = wezterm.action
  local _local_107_ = require("platform")
  local is = _local_107_["is"]
  local cpmods
  if is.macos then
    cpmods = "CMD"
  else
    cpmods = "CTRL|SHIFT"
  end
  local function common_keys()
    return {{key = "q", mods = "LEADER", action = act.CloseCurrentPane({confirm = true})}, {key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain")}, {key = "h", mods = "CTRL|LEADER", action = act.ActivateTabRelative(-1)}, {key = "l", mods = "CTRL|LEADER", action = act.ActivateTabRelative(1)}, {key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left")}, {key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down")}, {key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up")}, {key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right")}, {key = "|", mods = "LEADER", action = act.SplitHorizontal({domain = "CurrentPaneDomain"})}, {key = "|", mods = "SHIFT|LEADER", action = act.SplitHorizontal({domain = "CurrentPaneDomain"})}, {key = "-", mods = "LEADER", action = act.SplitVertical({domain = "CurrentPaneDomain"})}, {key = " ", mods = "LEADER", action = act.ShowLauncher}, {key = "a", mods = "LEADER|CTRL", action = act.SendString("\1")}, {key = ":", mods = "SHIFT|LEADER", action = act.ShowDebugOverlay}, {key = ":", mods = "LEADER", action = act.ShowDebugOverlay}, {key = "v", mods = cpmods, action = act.PasteFrom("Clipboard")}, {key = "c", mods = cpmods, action = act.CopyTo("Clipboard")}}
  end
  local function macos_keys()
    if is.macos then
      return {{key = ",", mods = "CTRL", action = act.SendString("\27[44;5u")}, {key = ",", mods = "CTRL|SHIFT", action = act.SendString("\27[44;6u")}}
    else
      return {}
    end
  end
  local single_left_down = {Down = {streak = 1, button = "Left"}}
  local single_left_up = {Up = {streak = 1, button = "Left"}}
  local double_left_down = {Down = {streak = 2, button = "Left"}}
  local double_left_up = {Up = {streak = 2, button = "Left"}}
  local triple_left_down = {Down = {streak = 3, button = "Left"}}
  local triple_left_up = {Up = {streak = 3, button = "Left"}}
  local single_left_drag = {Drag = {streak = 1, button = "Left"}}
  local double_left_drag = {Drag = {streak = 2, button = "Left"}}
  local triple_left_drag = {Drag = {streak = 3, button = "Left"}}
  local function mouse()
    return {{event = triple_left_down, mods = "NONE", action = act.SelectTextAtMouseCursor("Line")}, {event = double_left_down, mods = "NONE", action = act.SelectTextAtMouseCursor("Word")}, {event = single_left_down, mods = "NONE", action = act.SelectTextAtMouseCursor("Cell")}, {event = single_left_down, mods = "SHIFT", action = act.ExtendSelectionToMouseCursor("Cell")}, {event = single_left_down, mods = "ALT", action = act.SelectTextAtMouseCursor("Block")}, {event = single_left_up, mods = "SHIFT", action = act.CompleteSelection("ClipboardAndPrimarySelection")}, {event = single_left_up, mods = "NONE", action = act.CompleteSelection("ClipboardAndPrimarySelection")}, {event = single_left_up, mods = "ALT", action = act.CompleteSelection("ClipboardAndPrimarySelection")}, {event = double_left_up, mods = "NONE", action = act.CompleteSelection("ClipboardAndPrimarySelection")}, {event = triple_left_up, mods = "NONE", action = act.CompleteSelection("ClipboardAndPrimarySelection")}, {event = single_left_drag, mods = "NONE", action = act.ExtendSelectionToMouseCursor("Cell")}, {event = single_left_drag, mods = "ALT", action = act.ExtendSelectionToMouseCursor("Block")}, {event = single_left_down, mods = "ALT|SHIFT", action = act.ExtendSelectionToMouseCursor("Block")}, {event = single_left_up, mods = "ALT|SHIFT", action = act.CompleteSelection("ClipboardAndPrimarySelection")}, {event = double_left_drag, mods = "NONE", action = act.ExtendSelectionToMouseCursor("Word")}, {event = triple_left_drag, mods = "NONE", action = act.ExtendSelectionToMouseCursor("Line")}, {event = {Down = {streak = 1, button = "Middle"}}, mods = "NONE", action = act.PasteFrom("PrimarySelection")}, {event = single_left_up, mods = "CTRL", action = act.OpenLinkAtMouseCursor}, {event = {Down = {streak = 1, button = {WheelUp = 1}}}, mods = "NONE", action = act.ScrollByCurrentEventWheelDelta, alt_screen = false}, {event = {Down = {streak = 1, button = {WheelDown = 1}}}, mods = "NONE", action = act.ScrollByCurrentEventWheelDelta, alt_screen = false}}
  end
  return {disable_default_key_bindings = true, disable_default_mouse_bindings = true, leader = {key = "a", mods = "CTRL", timeout_milliseconds = 1000}, keys = __fnl_global__concat_21(common_keys(), macos_keys()), mouse_bindings = mouse()}
end
local function _110_(...)
  local _106_ = require("keys")
  return _106_
end
__fnl_global__merge_21(config, _110_(...))
return config