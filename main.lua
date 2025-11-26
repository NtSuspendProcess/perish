-- main.lua
local BASE = "https://raw.githubusercontent.com/NtSuspendProcess/perish/main/src/"

local function httpget(path)
	return game:HttpGet(BASE .. path:gsub("%.", "/") .. ".lua")
end

local env = loadstring(httpget("core/loader"))()(httpget)
env().start()
