-- main.lua
local screen = Instance.new("ScreenGui", game:GetService("CoreGui"))
local lbl = Instance.new("TextLabel", screen)
lbl.Size = UDim2.new(1,0,0,50)
lbl.Text = "perish boot start"
lbl.TextScaled = true
lbl.BackgroundTransparency = 1
lbl.TextColor3 = Color3.new(1,1,1)

local ok, err = pcall(function()
	local src = game:HttpGet("https://raw.githubusercontent.com/NtSuspendProcess/perish/main/src/core/loader.lua")
	local boot = loadstring(src)
	boot()
end)

if not ok then
	lbl.TextColor3 = Color3.new(1,0,0)
	lbl.Text = "boot fail: "..tostring(err)
else
	lbl.Text = "perish boot ok"
	game:GetService("TweenService"):Create(lbl, TweenInfo.new(2), {TextTransparency = 1}):Play()
	task.wait(2)
	screen:Destroy()
end

