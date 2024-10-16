local DEFAULTS = {policy = "current", session = "yazi"}
local get_state
local function _1_(state, name)
  return (state[name] or DEFAULTS[name])
end
get_state = ya.sync(_1_)
local function ne(msg)
  ya.notify({title = "tmux", content = msg, timeout = 5, level = "error"})
  return nil
end
local function get_output(cmd)
  local out, err = cmd:output()
  if err then
    ne(("Error: " .. tostring(err)))
    return 666
  elseif ((nil ~= out) and out.status.success and out.stdout) then
    local stdout = out.stdout:match("(.-)%s*$")
    if (0 ~= string.len(stdout)) then
      return stdout
    else
      return nil
    end
  else
    return nil
  end
end
local function get_session(bin)
  if os.getenv("TMUX") then
    return get_output(Command(bin):arg("display-message"):arg("-p"):arg("#S"))
  else
    return nil
  end
end
local get_cwd
local function _5_()
  return tostring(cx.active.current.cwd)
end
get_cwd = ya.sync(_5_)
local function run_tmux(cmd)
  local out, err = cmd:arg("-e"):arg(("YAZI_ID=" .. tostring(os.getenv("YAZI_ID")))):arg("-e"):arg(("YAZI_LEVEL=" .. tostring(os.getenv("YAZI_LEVEL")))):arg("-c"):arg(get_cwd()):arg((get_state("shell") or os.getenv("SHELL"))):stdin(Command.INHERIT):stdout(Command.INHERIT):stderr(Command.PIPED):output()
  if err then
    return ne(("Error: " .. tostring(err)))
  elseif not out.status.success then
    return ne(("(" .. out.status.code .. ") " .. out.stderr))
  else
    return nil
  end
end
local function spawn_session(bin, session)
  local out, err = Command(bin):arg("has-session"):arg("-t"):arg(session):output()
  if err then
    return ne(("Error: " .. tostring(err)))
  else
    local cmd
    do
      local cmd0 = Command(bin):env("TMUX", "")
      if out.status.success then
        cmd = cmd0:arg("attach"):arg("-t"):arg(session):arg(";"):arg("neww")
      else
        cmd = cmd0:arg("new"):arg("-s"):arg(session)
      end
    end
    local permit = ya.hide()
    run_tmux(cmd)
    permit:drop()
    return nil
  end
end
local function spawn_in_session(bin)
  return run_tmux(Command(bin):arg("neww"))
end
local function entry()
  if ("windows" == ya.target_family()) then
    ne("Unsupported OS")
    return
  else
  end
  local bin = get_output(Command("which"):arg("tmux"))
  if (666 == bin) then
    return
  else
  end
  if not bin then
    ne("Please install tmux first")
    return
  else
  end
  local session = get_session(bin)
  if (666 == session) then
    return
  else
  end
  local ns = get_state("session")
  if session then
    local policy = get_state("policy")
    if (session == ns) then
      return spawn_in_session(bin)
    elseif (policy == "error") then
      return ne(("Already in session " .. session))
    elseif (policy == "nest") then
      return spawn_session(bin, ns)
    else
      return spawn_in_session(bin)
    end
  else
    return spawn_session(bin, ns)
  end
end
local function setup(state, opts)
  if (not opts.policy or ("" == opts.policy)) then
    state.policy = "current"
  elseif (opts.policy and (type(opts.policy) ~= "string")) then
    ne(("Invalid policy type " .. type(opts.policy) .. ", using 'current'"))
    state.policy = "current"
  elseif (("nest" == opts.policy) or ("current" == opts.policy) or ("error" == opts.policy)) then
    state.policy = opts.policy
  else
    ne(("Invalid policy '" .. opts.policy .. "', using 'current'"))
    state.policy = "current"
  end
  if (not opts.session or ("" == opts.session)) then
    state.session = "yazi"
  elseif (type(opts.session) ~= "string") then
    ne(("Invalid session type " .. type(opts.session) .. ", using 'yazi'"))
    state.session = "yazi"
  else
    state.session = opts.session
  end
  if (not opts.shell or ("" == opts.shell)) then
    state.shell = nil
  elseif (type(opts.shell) ~= "string") then
    ne(("Invalid shell type " .. type(opts.shell) .. ", using the system one"))
    state.shell = nil
  else
    state.shell = opts.shell
  end
  return nil
end
return {entry = entry, setup = setup}
