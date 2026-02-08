--==================================================
-- PolariaX (Version: Beta 1.0)
--==================================================

--========== ADAPTERS ==========
getgenv().PolariaX_Execute = getgenv().PolariaX_Execute or function(code)
	local f, err = loadstring(code)
	if not f then warn(err) return end
	f()
end

getgenv().PolariaX_InfiniteYield = getgenv().PolariaX_InfiniteYield or function()
	loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua'))()
end

--========== SERVICES ==========
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

--========== GUI ==========
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PolariaX"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(540, 360)
main.Position = UDim2.fromScale(0.5,0.5) - UDim2.fromOffset(270,180)
main.BackgroundColor3 = Color3.fromRGB(12,12,12)
main.BorderColor3 = Color3.fromRGB(180,0,255)
main.BorderSizePixel = 2

--========== TOP ==========
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,32)
top.BackgroundColor3 = Color3.fromRGB(18,18,18)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.fromOffset(10,0)
title.Text = "PolariaX (Version: Beta 1.0)"
title.TextColor3 = Color3.fromRGB(200,0,255)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local btnClose = Instance.new("TextButton", top)
btnClose.Size = UDim2.fromOffset(30,32)
btnClose.Position = UDim2.new(1,-30,0,0)
btnClose.Text = "X"
btnClose.BackgroundColor3 = Color3.fromRGB(140,40,40)

local btnMin = Instance.new("TextButton", top)
btnMin.Size = UDim2.fromOffset(30,32)
btnMin.Position = UDim2.new(1,-60,0,0)
btnMin.Text = "_"
btnMin.BackgroundColor3 = Color3.fromRGB(60,60,60)

--========== DRAG ==========
local dragging, dragStart, startPos
top.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = main.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local d = i.Position - dragStart
		main.Position = startPos + UDim2.fromOffset(d.X,d.Y)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

--========== TAB BAR ==========
local tabBar = Instance.new("Frame", main)
tabBar.Position = UDim2.new(0,0,0,32)
tabBar.Size = UDim2.new(1,0,0,36)
tabBar.BackgroundColor3 = Color3.fromRGB(20,20,20)

local tabs = {"Home","Local Scripts","FE Bypass Scripts","LUA Executor"}
local pages = {}
local buttons = {}

local function switch(tab)
	for k,v in pairs(pages) do
		v.Visible = (k == tab)
	end
end

for i,name in ipairs(tabs) do
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.fromOffset(135,36)
	b.Position = UDim2.fromOffset((i-1)*135,0)
	b.Text = name
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.fromRGB(200,0,255)
	buttons[name] = b
end

for _,name in ipairs(tabs) do
	local page = Instance.new("Frame", main)
	page.Position = UDim2.new(0,0,0,68)
	page.Size = UDim2.new(1,0,1,-68)
	page.Visible = false
	page.BackgroundTransparency = 1
	pages[name] = page
	buttons[name].MouseButton1Click:Connect(function()
		switch(name)
	end)
end

switch("Home")

--========== HOME ==========
local home = pages["Home"]

local avatar = Instance.new("ImageLabel", home)
avatar.Size = UDim2.fromOffset(110,110)
avatar.Position = UDim2.fromOffset(20,20)
avatar.BackgroundTransparency = 1
avatar.Image = Players:GetUserThumbnailAsync(
	player.UserId,
	Enum.ThumbnailType.HeadShot,
	Enum.ThumbnailSize.Size420x420
)

local info = Instance.new("TextLabel", home)
info.Position = UDim2.fromOffset(150,20)
info.Size = UDim2.new(1,-170,0,200)
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.BackgroundTransparency = 1
info.TextColor3 = Color3.new(1,1,1)
info.Text =
	"Username: "..player.Name..
	"\nAccount Age: "..player.AccountAge.." days"..
	"\nPlaceId: "..game.PlaceId..
	"\nJobId: "..game.JobId..
	"\nFE: Enabled"

--========== UTIL ==========
local function makeBtn(parent,text,y,cb)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.fromOffset(240,32)
	b.Position = UDim2.fromOffset(20,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.fromRGB(200,0,255)
	b.MouseButton1Click:Connect(cb)
end

--========== LOCAL SCRIPTS ==========
local localTab = pages["Local Scripts"]

-- Brightness GUI (draggable)
makeBtn(localTab,"Brightness GUI",20,function()
	local originalBrightness = Lighting.Brightness
	local originalExposure = Lighting.ExposureCompensation

	local guiB = Instance.new("ScreenGui", player.PlayerGui)
	guiB.Name = "BrightnessGUI"
	guiB.ResetOnSpawn = false

	local frame = Instance.new("Frame", guiB)
	frame.Size = UDim2.new(0, 320, 0, 150)
	frame.Position = UDim2.new(0.35,0,0.4,0)
	frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
	frame.BorderSizePixel = 0

	local topBar = Instance.new("Frame", frame)
	topBar.Size = UDim2.new(1,0,0,30)
	topBar.BackgroundColor3 = Color3.fromRGB(25,25,25)

	local title = Instance.new("TextLabel", topBar)
	title.Size = UDim2.new(1,-60,1,0)
	title.Position = UDim2.new(0,10,0,0)
	title.Text = "Brightness"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left

	local close = Instance.new("TextButton", topBar)
	close.Size = UDim2.new(0,30,1,0)
	close.Position = UDim2.new(1,-30,0,0)
	close.Text = "X"
	close.BackgroundColor3 = Color3.fromRGB(150,50,50)
	close.TextColor3 = Color3.new(1,1,1)

	local label = Instance.new("TextLabel", frame)
	label.Position = UDim2.new(0,0,0,40)
	label.Size = UDim2.new(1,0,0,30)
	label.Text = "Brightness: 1.0"
	label.TextColor3 = Color3.new(1,1,1)
	label.BackgroundTransparency = 1
	label.TextScaled = true

	local bar = Instance.new("Frame", frame)
	bar.Position = UDim2.new(0.05,0,0.7,0)
	bar.Size = UDim2.new(0.9,0,0.15,0)
	bar.BackgroundColor3 = Color3.fromRGB(20,20,20)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new(0.1,0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(255,255,255)

	local MIN, MAX = 0, 10
	local dragging = false

	local function setBrightness(percent)
		local value = MIN + (MAX - MIN) * percent
		Lighting.Brightness = value
		Lighting.ExposureCompensation = value / 2
		label.Text = "Brightness: " .. string.format("%.1f", value)
		fill.Size = UDim2.new(percent,0,1,0)
	end

	bar:GetPropertyChangedSignal("AbsoluteSize"):Wait()

	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			local p = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			setBrightness(p)
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local p = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			setBrightness(p)
		end
	end)

	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- Draggable frame
	local drag, startPos, startFrame
	topBar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = true
			startPos = i.Position
			startFrame = frame.Position
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - startPos
			frame.Position = UDim2.new(
				startFrame.X.Scale,
				startFrame.X.Offset + delta.X,
				startFrame.Y.Scale,
				startFrame.Y.Offset + delta.Y
			)
		end
	end)

	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = false
		end
	end)

	close.MouseButton1Click:Connect(function()
		Lighting.Brightness = originalBrightness
		Lighting.ExposureCompensation = originalExposure
		guiB:Destroy()
	end)
end)

-- Crosshair
makeBtn(localTab,"Crosshair ON",60,function()
	if gui:FindFirstChild("Crosshair") then return end
	local c = Instance.new("Frame", gui)
	c.Name = "Crosshair"
	c.Size = UDim2.fromOffset(16,16)
	c.Position = UDim2.fromScale(0.5,0.5) - UDim2.fromOffset(8,8)
	c.BackgroundColor3 = Color3.new(1,0,0)
end)

makeBtn(localTab,"Crosshair OFF",100,function()
	if gui:FindFirstChild("Crosshair") then
		gui.Crosshair:Destroy()
	end
end)

--========== FE Bypass Scripts ==========
local fe = pages["FE Bypass Scripts"]
makeBtn(fe,"Infinite Yield",20,function() PolariaX_InfiniteYield() end)
makeBtn(fe,"c00lgui (c00lclan edition)",60,function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/cfsmi2/c00lguiv1/refs/heads/main/Main.lua", true))()
end)

--========== LUA Executor ==========
local exec = pages["LUA Executor"]

local box = Instance.new("TextBox", exec)
box.Size = UDim2.new(1,-40,0,200)
box.Position = UDim2.fromOffset(20,20)
box.MultiLine = true
box.ClearTextOnFocus = false
box.Text = "-- PolariaX Executor"
box.BackgroundColor3 = Color3.fromRGB(20,20,20)
box.TextColor3 = Color3.new(1,1,1)

makeBtn(exec,"Execute",240,function()
	PolariaX_Execute(box.Text)
end)

makeBtn(exec,"Clear",280,function()
	box.Text = ""
end)

--========== WINDOW ==========
local minimized = false
btnMin.MouseButton1Click:Connect(function()
	minimized = not minimized
	tabBar.Visible = not minimized
	for _,p in pairs(pages) do p.Visible = false end
	if not minimized then switch("Home") end
	main.Size = minimized and UDim2.fromOffset(540,32) or UDim2.fromOffset(540,360)
end)

btnClose.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
