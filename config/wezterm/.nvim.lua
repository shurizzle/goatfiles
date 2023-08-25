local _2adir_sep_2a = (package.config):sub(1, 1)
local _2aproject_2a = assert(vim.loop.fs_realpath("."), "invalid directory")
local function path_join(...)
  return table.concat({...}, _2adir_sep_2a)
end
local unpack = (table.unpack or _G.unpack)
local _2alua_exrc_2a = path_join(_2aproject_2a, ".nvim.lua")
local _2afnl_exrc_2a = path_join(_2aproject_2a, ".nvim.fnl")
local _2ain_2a = path_join(_2aproject_2a, "wezterm.fnl")
local _2aout_2a = path_join(_2aproject_2a, "wezterm.lua")
local function load_fennel()
  pcall(require, "hotpot.fennel")
  local ok, fennel = pcall(require, "fennel")
  if ok then
    return fennel
  else
    local function _1_(...)
      local args = {...}
      local path = assert(vim.loop.fs_realpath(path_join(_2aproject_2a, "..", "..", "fennel.lua")), "cannot find fennel compiler")
      local code = assert(loadfile(path))
      package.preload.fennel = code
      local fennel0 = code(unpack(args))
      local function _2_()
        return fennel0
      end
      package.preload.fennel = _2_
      return fennel0
    end
    package.preload.fennel = _1_
    return require("fennel")
  end
end
local fennel = load_fennel()
local uv = vim.loop
local function debounce(f, time)
  local timer = nil
  local function _4_(...)
    local args = {...}
    if timer then
      uv.timer_stop(timer)
      timer = nil
    else
    end
    local function run()
      timer = nil
      return f(unpack(args))
    end
    timer = vim.defer_fn(run, time)
    return nil
  end
  return _4_
end
local function slurp(path)
  local f = assert(io.open(path, "rb"))
  local function close_handlers_10_auto(ok_11_auto, ...)
    f:close()
    if ok_11_auto then
      return ...
    else
      return error(..., 0)
    end
  end
  local function _7_()
    return f:read("*all")
  end
  return close_handlers_10_auto(_G.xpcall(_7_, (package.loaded.fennel or debug).traceback))
end
local function spit(content, path)
  local f = assert(io.open(path, "wb"))
  local function close_handlers_10_auto(ok_11_auto, ...)
    f:close()
    if ok_11_auto then
      return ...
    else
      return error(..., 0)
    end
  end
  local function _9_()
    return f:write(content)
  end
  return close_handlers_10_auto(_G.xpcall(_9_, (package.loaded.fennel or debug).traceback))
end
local compile_exrc
local function _10_()
  return spit(fennel["compile-string"](slurp(_2afnl_exrc_2a), {filename = _2afnl_exrc_2a, globals = {"vim"}, ["use-bit-lib"] = true}), _2alua_exrc_2a)
end
compile_exrc = debounce(_10_, 250)
local compile_wezterm
local function _11_()
  return spit(fennel["compile-string"](slurp(_2ain_2a), {filename = _2ain_2a, requireAsInclude = true, skipInclude = {"wezterm"}}), _2aout_2a)
end
compile_wezterm = debounce(_11_, 250)
local function file_changed(err, filename)
  if err then
    local _12_
    if ("string" == type(err)) then
      _12_ = err
    else
      _12_ = tostring(err)
    end
    return vim.api.nvim_echo({{_12_, "ErrorMsg"}}, true, {})
  elseif (filename == ".nvim.fnl") then
    return compile_exrc()
  elseif ((filename ~= ".nvim.lua") and (filename ~= "compile.lua") and (filename:sub(-4) == ".fnl")) then
    return compile_wezterm()
  else
    return nil
  end
end
do
  local handle = uv.new_fs_event()
  uv.fs_event_start(handle, _2aproject_2a, {recursive = true, watch_entry = true, stat = true}, file_changed)
  local function _15_()
    return uv.close(handle)
  end
  vim.api.nvim_create_autocmd("VimLeavePre", {callback = _15_})
end
return nil