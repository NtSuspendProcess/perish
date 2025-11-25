-- perish/src/core/ac_bypass.lua
return function(env)
	local beat = game:GetService("RunService").Heartbeat
	local rng = Random.new()

	local function match(fn,flag)
		if flag=="micro_tick" then
			local n = debug.info(fn,"n") or ""; return n:lower():find("heartbeat")
		end
		if flag=="deep_frame" then return true end
		if flag=="static_ring" then
			for _,v in debug.getupvalues(fn) do if type(v)=="table" and #v==64 then return true end end
		end
		if flag=="tight_loop" then return debug.getinstructioncount(fn)==debug.getinstructioncount(fn) end
		return false
	end

	local kill = {
		micro_tick = function()
			for _,c in getconnections(beat) do if match(c.Function,"micro_tick") then c:Disable() end end
			env.log("dropped micro_tick")
		end,
		deep_frame = function()
			for _,c in getconnections(beat) do if match(c.Function,"deep_frame") then
				local old; old = hookfunction(c.Function,newcclosure(function(...) return old(...) end))
			end end
			env.log("cloaked deep_frame")
		end,
		static_ring = function()
			for _,c in getconnections(beat) do if match(c.Function,"static_ring") then
				for i,v in debug.getupvalues(c.Function) do if type(v)=="table" and #v==64 then
					local s = setmetatable({},{__len=function() return #v end})
					debug.setupvalue(c.Function,i,s)
				end end
			end end
			env.log("spoofed static_ring")
		end,
		tight_loop = function()
			for _,c in getconnections(beat) do if match(c.Function,"tight_loop") then
				local old; old = hookfunction(c.Function,newcclosure(function(...)
					for _=1,rng:NextInteger(1,5) do end return old(...)
				end))
			end end
			env.log("jittered tight_loop")
		end,
	}

	return {run = function(flags) for _,f in flags do if kill[f] then kill[f]() end end end}
	
end
--[[
for anyone reading this 
micro_tick  - timer too clean, drop the conn
deep_frame  - stack too deep, cloak it
static_ring - fixed tbl len 64, spoof len
tight_loop  - same ic every frame, add jitter
--]]
