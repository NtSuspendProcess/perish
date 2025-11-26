-- main.lua  (no-cache edition)
local ts = tostring(os.time())   -- unix epoch busts github cache
local BASE = "https://raw.githubusercontent.com/NtSuspendProcess/perish/main/src/?t="..ts

local function httpget(path)
	return game:HttpGet(BASE .. path:gsub("%.", "/") .. ".lua", true)
end

local env = loadstring(httpget("core/loader"))()
env(httpget)
env().start()

