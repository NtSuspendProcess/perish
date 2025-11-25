-- perish/src/core/silent_errors.lua
return function(env)
	return function(fn, ...)
		local ok, res = pcall(fn, ...)
		if not ok then
			env.log("err | "..tostring(res):gsub("\n"," "))
		end
		return ok, res
	end
end
