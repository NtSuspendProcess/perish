-- perish/src/core/hotreload.lua
return function(env)
	local cache_path = "perish/src/"
	local watched    = {}

	local function fullname(name) return cache_path .. name:gsub("%.", "/") .. ".lua" end

	local function import(name)
		local chunk, err = loadfile(fullname(name))
		if not chunk then env.log("hr > " .. err); return nil end
		return chunk(env)
	end

	local function reload(name)
		local ok, mod = pcall(import, name)
		if ok then
			package.loaded[name] = mod
			env.log("hr > reloaded " .. name)
			return mod
		else
			env.log("hr > fail " .. name)
		end
	end

	-- console cmd :reload <module>
	env.uis.InputBegan:Connect(function(i, g)
		if g then return end
		local txt = i.Text
		if txt and txt:match("^:reload ") then
			local mod = txt:match("^:reload (%S+)")
			if mod then reload(mod) end
		end
	end)

	return { reload = reload }
end
