-- perish/src/scripts/universal.lua
return function(env)
	env.log("universal loaded")

	local esp = import("lib/esp")()
	esp.toggle(true)

	env.undo.push(function() esp.toggle(false) end)
end
)