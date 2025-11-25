-- perish/src/core/loader.lua   25/11/25
local env = {
	rs  = game:GetService("RunService");
	sg  = game:GetService("StarterGui");
	plr = game:GetService("Players").LocalPlayer;
	uis = game:GetService("UserInputService");
	cam = workspace.CurrentCamera;
	log = (function()
		local lib = loadfile("perish/src/lib/log.lua")()
		return function(m) lib.push(m) end
	end)();
	wait   = task.wait;
	spawn  = task.spawn;
	bus = import("core/bus");
	const  = loadfile("perish/src/core/constants.lua")();
}

local cache = {};
local function import(name)
	if cache[name] then return cache[name] end
	local ok,chunk = pcall(loadfile,"perish/src/"..name..".lua")
	if not ok then error(chunk,2) end
	local mod = chunk(env)
	cache[name] = mod
	return mod
end

local function boot()
	-- core utils
	env.undo   = import("core/undo")
	env.pcall  = import("core/silent_errors")
	env.unload = import("core/unload")
	import("core/hotreload") -- listens for :reload

	-- dispatch table
	local dispatch = import("core/dispatcher").map
	local script_name = dispatch[game.PlaceId] or dispatch.default

	env.log("boot")
	local flags = env.pcall(import("core/recon").scan)
	if flags and #flags>0 then
		env.log("ac -> "..table.concat(flags,", "))
		env.pcall(import("core/ac_bypass").run,flags)
	end

	local ok,mod = env.pcall(import,"scripts/"..script_name)
	if ok then
		env.perish = mod
		env.log("ready")
	else
		env.log("no script")
	end
end

return {start = boot}
