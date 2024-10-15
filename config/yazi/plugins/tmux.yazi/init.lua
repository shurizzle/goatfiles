local DEFAULTS = { policy = "current", session = "yazi" }
local get_state = ya.sync(function(state, name)
	return state[name] or DEFAULTS[name]
end)

local function ne(msg)
	ya.notify({ title = "tmux", content = msg, timeout = 5, level = "error" })
end

local function get_output(cmd)
	local out, err = cmd:output()
	if err then
		ne("Error: " .. tostring(err))
		return 666
	end
	if out == nil or not out.status.success or not out.stdout then
		return nil
	end
	local stdout = out.stdout:match("(.-)%s*$")
	if string.len(stdout) ~= 0 then
		return stdout
	end
end

local function get_session(bin)
	if os.getenv("TMUX") then
		return get_output(Command(bin):arg("display-message"):arg("-p"):arg("#S"))
	end
end

local get_cwd = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

local function run_tmux(cmd)
	local out, err = cmd:arg("-e")
		:arg("YAZI_ID=" .. tostring(os.getenv("YAZI_ID")))
		:arg("-c")
		:arg(get_cwd())
		:arg(os.getenv("SHELL"))
		:stdin(Command.INHERIT)
		:stdout(Command.INHERIT)
		:stderr(Command.PIPED)
		:output()

	if err then
		ne("Error: " .. tostring(err))
		return
	end
	if not out.status.success then
		ne("(" .. out.status.code .. ") " .. out.stderr)
	end
end

local function spawn_session(bin, session)
	local out, err = Command(bin):arg("has-session"):arg("-t"):arg(session):output()
	if err then
		ne("Error: " .. tostring(err))
		return
	end
	local cmd = Command(bin):env("TMUX", "")
	if out.status.success then
		cmd = cmd:arg("attach"):arg("-t"):arg(session):arg(";"):arg("neww")
	else
		cmd = cmd:arg("new"):arg("-s"):arg(session)
	end

	local permit = ya.hide()
	run_tmux(cmd)
	permit:drop()
end

local function spawn_in_session(bin)
	run_tmux(Command(bin):arg("neww"))
end

local function setup(state, opts)
	if opts.policy and type(opts.policy) ~= "string" then
		ne("Invalid policy type " .. type(opts.policy) .. ", using 'current'")
		opts.policy = "current"
	elseif opts.policy and opts.policy ~= "" then
		if opts.policy ~= "nest" and opts.policy ~= "current" and opts.policy ~= "error" then
			ne("Invalid policy '" .. opts.policy .. "', using 'current'")
			opts.policy = "current"
		end
	else
		opts.policy = "current"
	end
	state.policy = opts.policy

	if not opts.session or opts.session == "" then
		opts.session = "yazi"
	elseif type(opts.session) ~= "string" then
		ne("Invalid session type " .. type(opts.session) .. ", using 'yazi'")
		opts.session = "yazi"
	end
	state.session = opts.session
end

local function entry(self, args)
	if ya.target_family() == "windows" then
		ne("Unsupported OS")
		return
	end

	local bin = get_output(Command("which"):arg("tmux"))
	if bin == 666 then
		return
	end
	if not bin then
		ne("Please install tmux first")
		return
	end

	local session = get_session(bin)
	if session == 666 then
		return
	end

	local ns = get_state("session")
	if session then
		local policy = get_state("policy")

		if session == ns then
			spawn_in_session(bin)
		else
			if policy == "error" then
				ne("Already in session " .. session)
			elseif policy == "next" then
				spawn_session(bin, ns)
			else
				spawn_in_session(bin)
			end
		end
	else
		spawn_session(bin, ns)
	end
end

return {
	entry = entry,
	setup = setup,
}
