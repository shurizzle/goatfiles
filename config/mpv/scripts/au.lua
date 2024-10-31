local function is_au_url(url)
	if not url:match("^https://") then
		return false
	end
	url = url:sub(9)
	if url:match("^www%.") then
		url = url:sub(5)
	end
	if not url:match("^animeunity%.to") then
		return false
	end
	url = url:sub(14)
	return #url == 0 or url:sub(1, 1) == "/"
end

mp.add_hook("on_load", 50, function()
	local url = mp.get_property("stream-open-filename")
	if type(url) ~= "string" then
		return
	end
	if not is_au_url(url) then
		return
	end
	local res, _ = mp.command_native({
		name = "subprocess",
		args = { "audown", "--url", url },
		playback_only = false,
		capture_stdout = true,
		stdin_data = "\n",
	})
	if not res or res.error or not res.stdout then
		return
	end
	local url = res.stdout:match("(.-)%s*$")
	if #url ~= 0 then
		mp.set_property("stream-open-filename", url)
	end
end)
