-- perish/src/core/bus.lua
return function(env)
	local handlers = {}

	local function fire(event, ...)
		local list = handlers[event] or {}
		for _,fn in list do
			env.pcall(fn, ...)
		end
	end

	local function on(event, fn)
		handlers[event] = handlers[event] or {}
		table.insert(handlers[event], fn)
	end

	local function off(event, fn)
		local list = handlers[event] or {}
		for i = #list, 1, -1 do
			if list[i] == fn then table.remove(list, i) end
		end
	end

	-- auto-clean on unload
	env.undo.push(function() table.clear(handlers) end)

	return { fire = fire, on = on, off = off }
end
