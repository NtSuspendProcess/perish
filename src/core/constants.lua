-- perish/src/core/constants.lua
local svc = setmetatable({},{__index = function(_,s) return cloneref(game:GetService(s)) end})

return {
	-- services
	players = svc.Players,
	rs      = svc.RunService,
	sg      = svc.StarterGui,
	uis     = svc.UserInputService,
	ts      = svc.TweenService,
	hps     = svc.HttpService,
	cg      = svc.CoreGui,
	ls      = svc.Lighting,
	ss      = svc.Stats,
	ws      = workspace,

	-- math
	inf  = math.huge,
	pi   = math.pi,
	tau  = 2*math.pi,
	rad  = math.rad,
	deg  = math.deg,
	abs  = math.abs,
	floor= math.floor,
	ceil = math.ceil,
	sqrt = math.sqrt,
	sin  = math.sin,
	cos  = math.cos,
	tan  = math.tan,
	asin = math.asin,
	acos = math.acos,
	atan = math.atan,
	atan2= math.atan2,

	-- vectors / cframe
	v3   = Vector3.new,
	v2   = Vector2.new,
	ud2  = UDim2.new,
	ud   = UDim.new,
	c3   = Color3.new,
	cf   = CFrame.new,
	ang  = CFrame.Angles,
	look = CFrame.lookAt,
	from = CFrame.fromMatrix,

	-- crypto / ids
	rng  = Random.new(tick()),
	hash = function() return hps:GenerateGUID(false) end,
	uid  = function() return tostring(tick()*10000):sub(1,8) end,

	-- task
	wait   = task.wait,
	spawn  = task.spawn,
	defer  = task.defer,
	sync   = task.synchronize,
	desync = task.desynchronize,

	-- drawing
	new_drw = function(t) return Drawing.new(t) end,

	-- tween
	tween = function(obj,props,time,easing,dir)
		return ts:Create(obj,TweenInfo.new(time,easing or Enum.EasingStyle.Linear,dir or Enum.EasingDirection.Out),props)
	end,

	-- ray
	ray      = Ray.new,
	cast_ray = function(org,dir,ignore)
		return workspace:FindPartOnRayWithIgnoreList(Ray.new(org,dir),ignore or {})
	end,
}
