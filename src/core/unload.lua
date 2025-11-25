-- perish/src/core/unload.lua
return function(env)
	local log   = env.log
	local draw  = env.const.new_drw
	local conns = {}

	local function add(fn) table.insert(conns, fn) end

	local old_new = draw
	Drawing.new = function(class)
		local obj = old_new(class)
		add(function() if obj then obj:Remove() end end)
		return obj
	end

	local function fire()
		for _,f in conns do pcall(f) end
		table.clear(conns)
		if getgenv().perish then getgenv().perish = nil end
		log("perish unloaded")
	end

	env.uis.InputBegan:Connect(function(i,g)
		if g then return end
		if i.Text and i.Text == ":unload" then fire() end
	end)

	return { push = add, fire = fire }
end
