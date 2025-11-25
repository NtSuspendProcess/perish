-- perish/src/lib/esp.lua
return function(env)
	local const = env.const
	local draw  = const.new_drw
	local cam   = const.ws.CurrentCamera
	local players = const.players
	local undo  = env.undo

	local cache = {}
	local conns = {}

	local function new_esplabel()
		local lbl = draw("Text")
		lbl.Size  = 14
		lbl.Center = true
		lbl.Outline = true
		lbl.Color = const.c3(1,1,1)
		lbl.Visible = true
		return lbl
	end

	local function update()
		for _,p in players:GetPlayers() do
			if p == env.plr then continue end
			local char = p.Character
			local head = char and char:FindFirstChild("Head")
			if head then
				if not cache[p] then cache[p] = new_esplabel() end
				local pos,on = cam:WorldToViewportPoint(head.Position)
				local lbl = cache[p]
				if on then
					lbl.Position = const.v2(pos.X,pos.Y)
					lbl.Text = p.Name
				else
					lbl.Visible = false
				end
			elseif cache[p] then
				cache[p]:Remove(); cache[p] = nil
			end
		end
	end

	local function clear()
		for _,lbl in cache do lbl:Remove() end
		table.clear(cache)
		for _,c in conns do c:Disconnect() end
		table.clear(conns)
	end

	-- wire
	table.insert(conns, players.PlayerAdded:Connect(function(p) cache[p] = nil end))
	table.insert(conns, players.PlayerRemoving:Connect(function(p) if cache[p] then cache[p]:Remove(); cache[p] = nil end end))
	table.insert(conns, const.rs.RenderStepped:Connect(update))

	-- register cleanup
	env.undo.push(clear)

	return {toggle = function(on) for _,lbl in cache do lbl.Visible = on end end}
end
