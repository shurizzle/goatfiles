local window = require("window")

window.add_signal("init", function(w)
	w.win.decorated = false
end)

local fennel = require("fennel").install()
fennel.path = luakit.config_dir .. "/?.fnl;" .. luakit.config_dir .. "/?/init.fnl"
require("browser")
