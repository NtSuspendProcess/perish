-- perish/src/lib/log.lua
local log = {}
local msgs = {}
local pad, y0, step, life = 10, 30, 18, 3
local cam = workspace.CurrentCamera

local function draw(idx, txt)
	local lbl = Drawing.new("Text")
	lbl.Text = txt
	lbl.Size = 16
	lbl.Color = Color3.new(1, 1, 1)
	lbl.Font = 0
	lbl.Outline = true
	lbl.OutlineColor = Color3.new(0, 0, 0)
	lbl.Position = Vector2.new(cam.ViewportSize.X - lbl.TextBounds.X - pad, y0 + (idx - 1) * step)
	lbl.Visible = true
	msgs[idx] = lbl
end

function log.push(str)
	local idx = #msgs + 1
	draw(idx, "perish | " .. str)
	task.delay(life, function()
		local lbl = msgs[idx]
		if lbl then lbl:Remove(); msgs[idx] = nil end
	end)
end

function log.clear()
	for _, lbl in pairs(msgs) do lbl:Remove() end
	table.clear(msgs)
end

return log
