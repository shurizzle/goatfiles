package.preload["stdlib"] = package.preload["stdlib"] or function(...)
  _G.unpack = (unpack or table.unpack)
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
    local tbl_21_ = {}
    local i_22_ = 0
    for k, _ in pairs(t) do
      local val_23_ = k
      if (nil ~= val_23_) then
        i_22_ = (i_22_ + 1)
        tbl_21_[i_22_] = val_23_
      else
      end
    end
    return tbl_21_
  end
  _G.keys = _7_
  local function _9_(t)
    assert(__fnl_global__table_3f(t), ("Expected table, got " .. type(t)))
    local tbl_21_ = {}
    local i_22_ = 0
    for _, v in pairs(t) do
      local val_23_ = v
      if (nil ~= val_23_) then
        i_22_ = (i_22_ + 1)
        tbl_21_[i_22_] = val_23_
      else
      end
    end
    return tbl_21_
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
    local and_22_ = __fnl_global__table_3f(x)
    if and_22_ then
      local function _23_(_241, _242)
        return not __fnl_global__number_3f(_242)
      end
      and_22_ = not some(_23_, x)
    end
    return and_22_
  end
  _G.__fnl_global__list_3f = _21_
  _G["list?"] = _G.__fnl_global__list_3f
  do local _ = {nil, nil} end
  local function _24_(v)
    local function _25_()
      return v
    end
    return _25_
  end
  _G.const = _24_
  local function _26_(s)
    return string.gsub(s, "^%s*(.-)", "%1")
  end
  _G.triml = _26_
  local function _27_(s)
    return string.gsub(s, "(.-)%s*$", "%1")
  end
  _G.trimr = _27_
  local function _28_(s)
    return string.gsub(s, "^%s*(.-)%s*$", "%1")
  end
  _G.trim = _28_
  local function copy_2a(x, cache)
    local _29_ = type(x)
    if (_29_ == "table") then
      if cache[x] then
        return cache[x]
      else
        local copy = {}
        local mt = getmetatable(x)
        cache[x] = copy
        for k, v in pairs(x) do
          copy[copy_2a(k, cache)] = copy_2a(v, cache)
        end
        return setmetatable(copy, mt)
      end
    elseif ((_29_ == "number") or (_29_ == "string") or (_29_ == "nil") or (_29_ == "boolean") or (_29_ == "function")) then
      return x
    elseif (nil ~= _29_) then
      local other = _29_
      return error(("Cannot deepcopy object of type " .. other))
    else
      return nil
    end
  end
  local function _32_(x)
    return copy_2a(x, {})
  end
  _G.copy = _32_
  local function _33_(...)
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
  _G.__fnl_global__concat_21 = _33_
  _G["concat!"] = _G.__fnl_global__concat_21
  do local _ = {nil, nil} end
  local function _36_(...)
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
  _G.concat = _36_
  local function _38_(res, ...)
    local args = {...}
    local _39_
    if __fnl_global__empty_3f(args) then
      _39_ = not __fnl_global__nil_3f(res)
    else
      _39_ = true
    end
    if _39_ then
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
  _G.__fnl_global__merge_21 = _38_
  _G["merge!"] = _G.__fnl_global__merge_21
  do local _ = {nil, nil} end
  local function can_merge(v)
    return (__fnl_global__table_3f(v) and (__fnl_global__empty_3f(v) or not __fnl_global__list_3f(v)))
  end
  local function _43_(...)
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
  _G.__fnl_global__deep_2dmerge = _43_
  _G["deep-merge"] = _G.__fnl_global__deep_2dmerge
  do local _ = {nil, nil} end
  local function _47_(...)
    local args = {...}
    local _48_
    if __fnl_global__empty_3f(args) then
      _48_ = not __fnl_global__nil_3f(res)
    else
      _48_ = true
    end
    if _48_ then
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
  _G.__fnl_global__deep_2dmerge_21 = _47_
  _G["deep-merge!"] = _G.__fnl_global__deep_2dmerge_21
  do local _ = {nil, nil} end
  local function _54_(s, prefix)
    assert(__fnl_global__string_3f(s), ("Expected string, got " .. type(s)))
    assert(__fnl_global__string_3f(prefix), ("Expected string, got " .. type(prefix)))
    return (s:sub(1, #prefix) == prefix)
  end
  _G.__fnl_global__starts_2dwith_3f = _54_
  _G["starts-with?"] = _G.__fnl_global__starts_2dwith_3f
  do local _ = {nil, nil} end
  local function _55_(s, prefix)
    if __fnl_global__starts_2dwith_3f(s, prefix) then
      return string.sub(s, inc(#prefix))
    else
      return nil
    end
  end
  _G.__fnl_global__strip_2dprefix = _55_
  _G["strip-prefix"] = _G.__fnl_global__strip_2dprefix
  do local _ = {nil, nil} end
  local function _57_(s, suffix)
    assert(__fnl_global__string_3f(s), ("Expected string, got " .. type(s)))
    assert(__fnl_global__string_3f(suffix), ("Expected string, got " .. type(suffix)))
    return ((0 == #suffix) or (s:sub(( - #suffix)) == suffix))
  end
  _G.__fnl_global__ends_2dwith_3f = _57_
  _G["ends-with?"] = _G.__fnl_global__ends_2dwith_3f
  do local _ = {nil, nil} end
  local function _58_(s, suffix)
    if __fnl_global__ends_2dwith_3f(s, suffix) then
      return string.sub(s, 1, (#s - #suffix))
    else
      return nil
    end
  end
  _G.__fnl_global__strip_2dsuffix = _58_
  _G["strip-suffix"] = _G.__fnl_global__strip_2dsuffix
  do local _ = {nil, nil} end
  local function _60_(path)
    local _61_, _62_ = io.open(path, "r")
    if ((_61_ == nil) and true) then
      local _msg = _62_
      return nil
    elseif (nil ~= _61_) then
      local f = _61_
      local content = f:read("*all")
      f:close()
      return content
    else
      return nil
    end
  end
  _G.slurp = _60_
  local function _64_(f)
    assert(__fnl_global__function_3f(f), ("Expected function, got " .. type(f)))
    local called = false
    local function _65_(...)
      if not called then
        called = true
        return f(...)
      else
        return nil
      end
    end
    return _65_
  end
  _G.once = _64_
  return nil
end
require("stdlib")
local wezterm = require("wezterm")
package.preload["platform"] = package.preload["platform"] or function(...)
  local wezterm = require("wezterm")
  local getenv = os["getenv"]
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
  _is.bsd = (_is.mac or _is.fbsd or _is.dfbsd or _is.nbsd or _is.obsd)
  local function home()
    if _is.win then
      return (getenv("HOMEDRIVE") .. getenv("HOMEPATH"))
    else
      return getenv("HOME")
    end
  end
  local path
  do
    local p = getenv("PATH")
    if (_is.mac and not string.find((":" .. p .. ":"), ":/opt/homebrew/bin:", 1, true)) then
      path = ("/opt/homebrew/bin:/opt/homebrew/sbin:" .. p)
    else
      path = p
    end
  end
  local function ro(t)
    local function _71_(_241, _242)
      return t[_242]
    end
    local function _72_()
      return nil
    end
    return setmetatable({}, {__index = _71_, __newindex = _72_})
  end
  return ro({os = os0, is = ro(_is), arch = arch, home = home, path = path})
end
local _local_73_ = require("platform")
local is = _local_73_["is"]
local path = _local_73_["path"]
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
if is.mac then
  config.set_environment_variables = {PATH = path}
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
    for _, name in ipairs({"vercingetorige", "wercingetorige", "DomPerignon", "filottete"}) do
      if (name ~= wezterm.hostname()) then
        local _77_
        if (name == "filottete") then
          _77_ = "None"
        else
          _77_ = "WezTerm"
        end
        local _79_
        if (name == "wercingetorige") then
          _79_ = "Unknown"
        else
          _79_ = "Posix"
        end
        table.insert(ds, {name = name, remote_address = (name .. ".local"), multiplexing = _77_, assume_shell = _79_})
      else
      end
    end
    return ds
  end
  return {ssh_domains = ssh_domains()}
end
__fnl_global__merge_21(config, (require("domains")))
package.preload["font"] = package.preload["font"] or function(...)
  local wezterm = require("wezterm")
  local _local_82_ = require("platform")
  local is = _local_82_["is"]
  local hostname = wezterm.hostname()
  local harfbuzz_features = {"ss01", "ss02=0", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08", "calt", "dlig"}
  local _83_
  if (("DomPerignon" == hostname) or ("filottete" == hostname)) then
    _83_ = 9
  elseif is.mac then
    _83_ = 12
  else
    _83_ = 10
  end
  return {allow_square_glyphs_to_overflow_width = "Always", harfbuzz_features = {"ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08", "zero", "onum", "dlig", "calt"}, font = wezterm.font({family = "Monaspace Argon", harfbuzz_features = harfbuzz_features}), font_rules = {{intensity = "Normal", italic = true, font = wezterm.font({family = "Monaspace Radon", weight = "Regular", harfbuzz_features = harfbuzz_features, italic = false})}, {intensity = "Half", font = wezterm.font({family = "Monaspace Radon", weight = "Medium", harfbuzz_features = harfbuzz_features, italic = false}), italic = false}, {intensity = "Bold", font = wezterm.font({family = "Monaspace Radon", weight = "Bold", harfbuzz_features = harfbuzz_features, italic = false}), italic = false}}, font_size = _83_, warn_about_missing_glyphs = false}
end
__fnl_global__merge_21(config, (require("font")))
package.preload["ui"] = package.preload["ui"] or function(...)
  local wezterm = require("wezterm")
  local _local_85_ = require("platform")
  local is = _local_85_["is"]
  local _local_94_ = require("bell")
  local update_bell = _local_94_["update"]
  local bell_3f = _local_94_["bell?"]
  local function tab_title(tab, max_width)
    local _95_
    if bell_3f(tab.window_id, tab.tab_id) then
      _95_ = "\240\159\148\148"
    else
      _95_ = ""
    end
    return wezterm.truncate_right((_95_ .. string.gsub(tab.active_pane.title, "(.*: )(.*)", "%2")), (max_width - 2))
  end
  local function _97_(tab, _, _0, _1, _2, max_width)
    update_bell(tab.window_id)
    return (" " .. tab_title(tab, max_width) .. " ")
  end
  wezterm.on("format-tab-title", _97_)
  local gh_match = {regex = "[\"]?([\\w\\d]{2}[-\\w\\d]+)(/){1}([-\\w\\d\\.]+)[\"]?", format = "https://www.github.com/$1/$3"}
  local function _98_(win, pane)
    local data
    local _99_
    if is.mac then
      _99_ = (" " .. wezterm.strftime("%d/%m/%Y %H:%M:%S"))
    else
      _99_ = ""
    end
    data = (pane:get_domain_name() .. _99_)
    return win:set_right_status(wezterm.format({{Foreground = {AnsiColor = "White"}}, {Text = data}}))
  end
  wezterm.on("update-status", _98_)
  local _101_
  if ("DomPerignon" == wezterm.hostname()) then
    _101_ = "OpenGL"
  else
    _101_ = "WebGpu"
  end
  local _103_
  if is.linux then
    if os.getenv("WAYLAND_DISPLAY") then
      _103_ = "NONE"
    else
      _103_ = "RESIZE"
    end
  else
    _103_ = "RESIZE"
  end
  return {front_end = _101_, window_decorations = _103_, window_padding = {left = 0, right = 0, top = 0, bottom = 0}, use_ime = true, ime_preedit_rendering = "System", enable_tab_bar = true, hide_tab_bar_if_only_one_tab = true, switch_to_last_active_tab_when_closing_tab = true, tab_bar_at_bottom = true, audible_bell = "SystemBeep", enable_wayland = true, default_cursor_style = "SteadyBar", hyperlink_rules = __fnl_global__merge_21(wezterm.default_hyperlink_rules(), {gh_match}), show_new_tab_button_in_tab_bar = false, show_tab_index_in_tab_bar = false, use_fancy_tab_bar = false}
end
package.preload["bell"] = package.preload["bell"] or function(...)
  local wezterm = require("wezterm")
  wezterm.GLOBAL.bells = {}
  local function update(win_id)
    local tmp_3_ = wezterm.GLOBAL.bells[tostring(win_id)]
    if (nil ~= tmp_3_) then
      tmp_3_[tostring(wezterm.mux.get_window(win_id):active_tab():tab_id())] = nil
      return nil
    else
      return nil
    end
  end
  local function _87_(window, pane)
    if os.getenv("WAYLAND_DISPLAY") then
      wezterm.background_child_process({"paplay", "/usr/share/sounds/freedesktop/stereo/bell.oga"})
    else
    end
    local win_id = window:window_id()
    local tab_id = pane:tab():tab_id()
    if (window:active_tab():tab_id() ~= tab_id) then
      wezterm.GLOBAL.bells[tostring(win_id)] = (wezterm.GLOBAL.bells[tostring(win_id)] or {})
      wezterm.GLOBAL.bells[tostring(win_id)][tostring(tab_id)] = tab_id
      return nil
    else
      return nil
    end
  end
  wezterm.on("bell", _87_)
  local function bell_3f(win_id, tab_id)
    local _91_
    do
      local t_90_ = wezterm.GLOBAL.bells
      if (nil ~= t_90_) then
        t_90_ = t_90_[tostring(win_id)]
      else
      end
      if (nil ~= t_90_) then
        t_90_ = t_90_[tostring(tab_id)]
      else
      end
      _91_ = t_90_
    end
    return (_91_ == tab_id)
  end
  return {update = update, ["bell?"] = bell_3f}
end
__fnl_global__merge_21(config, (require("ui")))
package.preload["theme"] = package.preload["theme"] or function(...)
  local _let_125_ = require("themefn")
  local dark = _let_125_["dark"]
  local light = _let_125_["light"]
  local colorscheme = _let_125_["colorscheme"]
  local render_background = _let_125_["render-background"]
  return {color_schemes = {["BlueSky Dark"] = dark, ["BlueSky Light"] = light}, color_scheme = colorscheme(), background = render_background()}
end
package.preload["themefn"] = package.preload["themefn"] or function(...)
  local wezterm = require("wezterm")
  local _local_106_ = require("platform")
  local home = _local_106_["home"]
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
  local function scheme_file_3f(name)
    local f = io.open((wezterm.config_dir .. "/colors" .. "/" .. name .. ".toml"))
    if f then
      f:close()
    else
    end
    return (nil ~= f)
  end
  local function colorscheme(_3fappearance)
    if scheme_file_3f("Noctalia") then
      return "Noctalia"
    else
      if (_3fappearance or get_appearance()):match("Light") then
        return "BlueSky Light"
      else
        return "BlueSky Dark"
      end
    end
  end
  local function ryukomatoi_sailor(light_3f)
    local _111_
    if light_3f then
      _111_ = 0.5
    else
      _111_ = 0.1
    end
    return {source = {File = (home() .. "/Pictures/imgbin_ryuko-matoi-senketsu-manga-anime-mako-mankanshoku-png.png")}, width = ((1024 / 5) .. "px"), height = ((1078 / 5) .. "px"), repeat_x = "NoRepeat", repeat_y = "NoRepeat", vertical_align = "Bottom", horizontal_align = "Right", opacity = _111_}
  end
  local function ryukomatoi_kamui(light_3f)
    local _113_
    if light_3f then
      _113_ = 0.5
    else
      _113_ = 0.1
    end
    return {source = {File = (home() .. "/Pictures/imgbin_ryuko-matoi-senketsu-desktop-png.png")}, width = ((8000 / 40) .. "px"), height = ((7646 / 40) .. "px"), repeat_x = "NoRepeat", repeat_y = "NoRepeat", vertical_align = "Bottom", horizontal_align = "Right", opacity = _113_}
  end
  local function base_background(Color)
    return {source = {Color = Color}, width = "100%", height = "100%"}
  end
  local render_state
  if ("DomPerignon" == wezterm.hostname()) then
    local function _115_()
      return nil
    end
    render_state = _115_
  else
    local function _116_(light_3f, state)
      local function decorate(f)
        local base
        local function _117_()
          if light_3f then
            return white
          else
            return black
          end
        end
        base = {base_background(_117_())}
        if f then
          table.insert(base, f(light_3f))
        else
        end
        return base
      end
      if (state == "kamui") then
        return decorate(ryukomatoi_kamui)
      elseif (state == "sailor") then
        return decorate(ryukomatoi_sailor)
      else
        local _ = state
        return decorate()
      end
    end
    render_state = _116_
  end
  local _2adefault_2a = "none"
  local function render_background(_3fappearance, state)
    local light_3f = (_3fappearance or get_appearance()):match("Light")
    return render_state(light_3f, (state or _2adefault_2a))
  end
  local function rotate_background(window)
    if not wezterm.GLOBAL.backgrounds then
      wezterm.GLOBAL.backgrounds = {}
    else
    end
    local appearance = window:get_appearance()
    local light_3f = appearance:match("Light")
    local id = tostring(window:window_id())
    local state
    do
      local _122_ = (wezterm.GLOBAL.backgrounds[id] or _2adefault_2a)
      if (_122_ == "kamui") then
        state = "sailor"
      elseif (_122_ == "sailor") then
        state = "none"
      elseif (_122_ == "none") then
        state = "kamui"
      else
        state = nil
      end
    end
    local overrides = (window:get_config_overrides() or {})
    wezterm.GLOBAL.backgrounds[id] = state
    overrides.background = render_state(light_3f, wezterm.GLOBAL.backgrounds[id])
    window:set_config_overrides(overrides)
    return nil
  end
  local function _124_(window, _)
    local overrides = (window:get_config_overrides() or {})
    local appearance = window:get_appearance()
    overrides.color_scheme = colorscheme(appearance)
    overrides.background = render_background(appearance, (wezterm.GLOBAL.backgrounds or {})[tostring(window:window_id())])
    return window:set_config_overrides(overrides)
  end
  wezterm.on("window-config-reloaded", _124_)
  return {["rotate-background"] = rotate_background, ["render-background"] = render_background, colorscheme = colorscheme, dark = dark, light = light}
end
__fnl_global__merge_21(config, (require("theme")))
package.preload["keys"] = package.preload["keys"] or function(...)
  local wezterm = require("wezterm")
  local act = wezterm.action
  local _local_126_ = require("platform")
  local is = _local_126_["is"]
  local path = _local_126_["path"]
  local function readable_3f(path0)
    local _127_ = io.open(path0)
    if (nil ~= _127_) then
      local f = _127_
      f:close()
      return true
    else
      local _ = _127_
      return false
    end
  end
  local function in_path_3f(bin)
    if not is.windows then
      return wezterm.run_child_process({"sh", "-c", "PATH=\"$2\" command -v \"$1\"", "sh", bin, path})
    elseif bin:find("[/\\]") then
      return readable_3f(bin)
    else
      return wezterm.run_child_process({"where.exe", "/Q", bin})
    end
  end
  local function spawn_tab_right(...)
    local candidates
    if (0 == select("#", ...)) then
      candidates = {{}}
    else
      candidates = {...}
    end
    local function _131_(win, pane)
      local mux_win = win:mux_window()
      local idx
      do
        local i = 0
        for _, t in ipairs(mux_win:tabs_with_info()) do
          if t.is_active then
            i = t.index
          else
            i = i
          end
        end
        idx = i
      end
      local domain = {DomainName = pane:get_domain_name()}
      local tab, new_pane, err = nil
      err = "no spawn candidate found in PATH"
      for _, opts in ipairs(candidates) do
        if tab then break end
        if (__fnl_global__nil_3f(opts.args) or in_path_3f(opts.args[1])) then
          opts.domain = domain
          local _133_, _134_, _135_ = pcall(mux_win.spawn_tab, mux_win, opts)
          if ((_133_ == true) and (nil ~= _134_) and (nil ~= _135_)) then
            local t = _134_
            local p = _135_
            tab, new_pane = t, p
          elseif ((_133_ == false) and (nil ~= _134_)) then
            local e = _134_
            err = e
          else
          end
        else
        end
      end
      if tab then
        tab:activate()
        return win:perform_action(act.MoveTab((idx + 1)), new_pane)
      else
        return wezterm.log_error(err)
      end
    end
    return wezterm.action_callback(_131_)
  end
  local set_default_domain
  local function _139_(_, _0, id)
    if id then
      return wezterm.mux.set_default_domain(wezterm.mux.get_domain(id))
    else
      return nil
    end
  end
  set_default_domain = wezterm.action_callback(_139_)
  local choose_default_domain
  local function _141_(win, pane)
    local current = wezterm.mux.get_domain():name()
    local _142_
    do
      local tbl_21_ = {}
      local i_22_ = 0
      for _, d in ipairs(wezterm.mux.all_domains()) do
        local val_23_
        if d:is_spawnable() then
          local _143_
          if (d:name() == current) then
            _143_ = (d:name() .. " *")
          else
            _143_ = d:name()
          end
          val_23_ = {id = d:name(), label = _143_}
        else
          val_23_ = nil
        end
        if (nil ~= val_23_) then
          i_22_ = (i_22_ + 1)
          tbl_21_[i_22_] = val_23_
        else
        end
      end
      _142_ = tbl_21_
    end
    return win:perform_action(act.InputSelector({title = "Default domain", fuzzy = true, action = set_default_domain, choices = _142_}), pane)
  end
  choose_default_domain = wezterm.action_callback(_141_)
  local function common_keys()
    local function _147_()
      local tbl_21_ = {}
      local i_22_ = 0
      for _, bin in ipairs({"btm", "htop", "top"}) do
        local val_23_ = {args = {bin}, cwd = wezterm.home_dir}
        if (nil ~= val_23_) then
          i_22_ = (i_22_ + 1)
          tbl_21_[i_22_] = val_23_
        else
        end
      end
      return tbl_21_
    end
    local function _149_()
      local tbl_21_ = {}
      local i_22_ = 0
      for _, bin in ipairs({"claude", "opencode"}) do
        local val_23_ = {args = {bin}, cwd = wezterm.home_dir}
        if (nil ~= val_23_) then
          i_22_ = (i_22_ + 1)
          tbl_21_[i_22_] = val_23_
        else
        end
      end
      return tbl_21_
    end
    return {{key = "q", mods = "LEADER", action = act.CloseCurrentPane({confirm = true})}, {key = "c", mods = "LEADER", action = spawn_tab_right()}, {key = "h", mods = "CTRL|LEADER", action = act.ActivateTabRelative(-1)}, {key = "l", mods = "CTRL|LEADER", action = act.ActivateTabRelative(1)}, {key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left")}, {key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down")}, {key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up")}, {key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right")}, {key = "b", mods = "LEADER", action = wezterm.action_callback(require("themefn")["rotate-background"])}, {key = "|", mods = "LEADER", action = act.SplitHorizontal({domain = "CurrentPaneDomain"})}, {key = "|", mods = "SHIFT|LEADER", action = act.SplitHorizontal({domain = "CurrentPaneDomain"})}, {key = "-", mods = "LEADER", action = act.SplitVertical({domain = "CurrentPaneDomain"})}, {key = " ", mods = "LEADER", action = act.ShowLauncher}, {key = "s", mods = "LEADER", action = act.ShowLauncherArgs({flags = "FUZZY|WORKSPACES"})}, {key = "d", mods = "LEADER", action = choose_default_domain}, {key = "a", mods = "LEADER|CTRL", action = act.SendString("\1")}, {key = ":", mods = "SHIFT|LEADER", action = act.ShowDebugOverlay}, {key = "v", mods = "LEADER", action = act.ActivateCopyMode}, {key = "/", mods = "LEADER", action = act.Search({CaseInSensitiveString = ""})}, {key = ":", mods = "LEADER", action = act.ShowDebugOverlay}, {key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard")}, {key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard")}, {key = "<", mods = "LEADER", action = act.MoveTabRelative(-1)}, {key = ">", mods = "LEADER", action = act.MoveTabRelative(1)}, {key = "<", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1)}, {key = ">", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1)}, {key = "=", mods = "CTRL", action = act.IncreaseFontSize}, {key = "-", mods = "CTRL", action = act.DecreaseFontSize}, {key = "0", mods = "CTRL", action = act.ResetFontSize}, {key = "t", mods = "LEADER", action = spawn_tab_right(unpack(_147_()))}, {key = "i", mods = "LEADER", action = spawn_tab_right(unpack(_149_()))}}
  end
  local function macos_keys()
    if is.macos then
      return {{key = ",", mods = "CTRL", action = act.SendString("\27[44;5u")}, {key = ",", mods = "CTRL|SHIFT", action = act.SendString("\27[44;6u")}, {key = "v", mods = "CMD", action = act.PasteFrom("Clipboard")}, {key = "c", mods = "CMD", action = act.CopyTo("Clipboard")}}
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
__fnl_global__merge_21(config, (require("keys")))
return config