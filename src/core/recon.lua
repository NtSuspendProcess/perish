-- perish/src/core/recon.lua
return function(env)
	local t = {}
	local beat = env.rs.Heartbeat

	for _,c in getconnections(beat) do
		local buf = {}
		for i=1,10 do
			local t0 = os.clock()
			beat:Wait()
			buf[i] = os.clock()-t0
		end
		local avg, var = 0, 0
		for _,v in buf do avg = avg + v end
		avg = avg/#buf
		for _,v in buf do var = var + (v-avg)*(v-avg) end
		if var/#buf < 1e-7 then t["micro_tick"] = true; break end
	end

	local base = #string.split(debug.traceback(),"\n")
	local deep = false
	local conn; conn = beat:Connect(function()
		if #string.split(debug.traceback(),"\n") - base > 3 then
			deep = true; conn:Disconnect()
		end
	end)
	env.wait(0.12); conn:Disconnect()
	if deep then t["deep_frame"] = true end

	for _,c in getconnections(beat) do
		for _,v in debug.getupvalues(c.Function) do
			if type(v)=="table" and #v==64 then
				local old = #v; beat:Wait()
				if #v == old then t["static_ring"] = true; break end
			end
		end
	end

	for _,c in getconnections(beat) do
		if debug.getinstructioncount(c.Function) == debug.getinstructioncount(c.Function) then
			t["tight_loop"] = true; break
		end
	end

	local out = {}
	for k,_ in pairs(t) do table.insert(out,k) end
	return out
end

--[[
micro_tick  ->  timer too perfect (human heartbeat jitters, this one doesn’t)
deep_frame  ->  ac running extra stack frames below normal code
static_ring ->  table never grows/shrinks (ring buffer holding hashes)
tight_loop  ->  same instruction count every frame (small hash loop)
--]]
