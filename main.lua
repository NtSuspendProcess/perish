local ts = tostring(os.time())
local BASE = "https://raw.githubusercontent.com/NtSuspendProcess/perish/main/src/"

local function httpget(name)
	return game:HttpGet(BASE .. name:gsub("%.", "/") .. ".lua?t=" .. ts, true)
end

local env = loadstring(httpget("core/loader"))()
env(httpget)
env().start()

