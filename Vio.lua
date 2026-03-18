local LMG2L = {}
local TS = game:GetService("TweenService")

local function tw(o, p, t)
	return TS:Create(
		o,
		TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		p
	)
end

-- =======================
-- UI : ScreenGui
-- =======================
LMG2L.ScreenGui = Instance.new("ScreenGui", game.CoreGui)
LMG2L.ScreenGui.IgnoreGuiInset = true
LMG2L.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- =======================
-- UI : Button
-- =======================
LMG2L.MarvenButton = Instance.new("ImageButton", LMG2L.ScreenGui)
LMG2L.MarvenButton.Name = "MarvenButton"
LMG2L.MarvenButton.Size = UDim2.new(0, 100, 0, 30)
LMG2L.MarvenButton.Position = UDim2.new(0.5, 0, 0, 2.5)
LMG2L.MarvenButton.AnchorPoint = Vector2.new(0.5, 0)
LMG2L.MarvenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LMG2L.MarvenButton.BorderSizePixel = 0
LMG2L.MarvenButton.AutoButtonColor = false

-- Corner
LMG2L.Corner = Instance.new("UICorner", LMG2L.MarvenButton)
LMG2L.Corner.CornerRadius = UDim.new(0, 7)

-- Icon
LMG2L.Icon = Instance.new("ImageLabel", LMG2L.MarvenButton)
LMG2L.Icon.Image = "rbxassetid://87526284179554"
LMG2L.Icon.Size = UDim2.new(0, 30, 0, 30)
LMG2L.Icon.Position = UDim2.new(0.35, 0, 0, 0)
LMG2L.Icon.BackgroundTransparency = 1
LMG2L.Icon.BorderSizePixel = 0
LMG2L.Icon.ImageTransparency = 0.05

-- Gradient
LMG2L.Gradient = Instance.new("UIGradient", LMG2L.MarvenButton)
LMG2L.Gradient.Rotation = -90
LMG2L.Gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
})

-- Stroke
LMG2L.Stroke = Instance.new("UIStroke", LMG2L.MarvenButton)
LMG2L.Stroke.Thickness = 0.6
LMG2L.Stroke.Color = Color3.fromRGB(255, 0, 0)
LMG2L.Stroke.Transparency = 0.15

-- Scale
LMG2L.Scale = Instance.new("UIScale", LMG2L.MarvenButton)
LMG2L.Scale.Scale = 1

-- =======================
-- Ripple Effect
-- =======================
local function Ripple(btn)
	local r = Instance.new("Frame", btn)
	r.AnchorPoint = Vector2.new(0.5, 0.5)
	r.Position = UDim2.fromScale(0.5, 0.5)
	r.Size = UDim2.fromScale(0.05, 0.05)
	r.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	r.BackgroundTransparency = 0.85
	r.BorderSizePixel = 0
	r.ZIndex = 10

	Instance.new("UICorner", r).CornerRadius = UDim.new(1, 0)

	tw(r, {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1
	}, 0.35):Play()

	task.delay(0.35, function()
		r:Destroy()
	end)
end

-- =======================
-- Press Effect
-- =======================
local baseScale = 1
local pressScale = 1.06
local baseThick = LMG2L.Stroke.Thickness
local baseTrans = LMG2L.Stroke.Transparency

LMG2L.MarvenButton.MouseButton1Down:Connect(function()
	Ripple(LMG2L.MarvenButton)
	tw(LMG2L.Scale, { Scale = pressScale }, 0.18):Play()
	tw(LMG2L.Stroke, { Thickness = baseThick + 1, Transparency = 0 }, 0.18):Play()
end)

LMG2L.MarvenButton.MouseButton1Up:Connect(function()
	tw(LMG2L.Scale, { Scale = baseScale }, 0.22):Play()
	tw(LMG2L.Stroke, { Thickness = baseThick, Transparency = baseTrans }, 0.22):Play()
end)

-- =======================
-- Player List
-- =======================

local FarmX = {}
for _, v in pairs(workspace.Farm:GetChildren()) do
	if v:IsA("Folder") then
		table.insert(FarmX, v.Name)
	end
end
local MiniMap = {}
for _, v in pairs(game:GetService("ReplicatedStorage").MinimapPoints:GetChildren()) do
	if v:IsA("MeshPart") then
	table.insert(MiniMap, v.Name)
	end
end
if getconnections then 
    for _, v in next, getconnections(game.Players.LocalPlayer.Idled) do
        v:Disable()
    end
end
-- =======================
-- WindUI Setup
-- =======================
local NameMap = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
	Title = "MarvenRiz X Hub",
	Icon = "rbxassetid://87526284179554",
	Author = "Map : " .. NameMap,
	Folder = "MarvenRizX",
	Size = UDim2.fromOffset(360, 410),
	Transparent = false,
	Theme = "Dark",
	Resizable = true,
	IconSize = 60,
	NewElements = true,
	BackgroundImageTransparency = 0.40,
	HideSearchBar = true,
	ScrollBarEnabled = false,
	Topbar = {
		Height = 45,
		ButtonsType = "Default",
	},
})

Window:EditOpenButton({ Enabled = false })

LMG2L.MarvenButton.MouseButton1Click:Connect(function()
	Window:Toggle()
end)

-- =======================
-- Tabs workspace.Farm.Grapes.FarmItem
-- =======================
local Tab1 = Window:Tab({ Title = "General", Border = true })
local Tab2 = Window:Tab({Title = "Teleport", Border = true })

local Section1 = Tab1:Section({ Title = "| General" })
local Group1 = Tab1:Group({})

local Section1 = Tab2:Section({ Title = "| Server Vip" })
local Group1 = Tab2:Group({})

local SelectFarm = Tab1:Dropdown({
	Title = "Select Farm",
	Values = FarmX,
	Value = "...",
	Multi = false,
	AllowNone = true,
	Callback = function(Noc)
		_G.SelectFarm = Noc
	end
})


Tab1:Toggle({
	Title = "Auto Farm Select",
	Type = "Checkbox",
	Value = false,
	Callback = function(state)
		_G.Farm = state
	end
})


local Section1 = Tab1:Section({ Title = "| Process" })
local SelectFarm = Tab1:Dropdown({
	Title = "Select Process",
	Values = {"Ore","Wood Plank"},
	Value = "...",
	Multi = false,
	AllowNone = true,
	Callback = function(Niioqm)
		_G.SelectProcess = Niioqm
	end
})
Tab1:Toggle({
	Title = "Fast Process",
	Type = "Checkbox",
	Value = false,
	Callback = function(sidi)
		_G.Posss = sidi
	end
})

local Section1 = Tab1:Section({ Title = "| EXP Farm" })
Tab1:Toggle({
	Title = "Auto Farm EXP",
	Type = "Checkbox",
	Value = false,
	Callback = function(ex)
		_G.ExpFarm = ex
	end
})
local Section1 = Tab1:Section({ Title = "| Cemen Auto" })
Tab1:Toggle({
	Title = "Auto Farm Cemen",
	Type = "Checkbox",
	Value = false,
	Callback = function(mokq)
		_G.Cemen = mokq
	end
})

Tab2:Button({
	Title = "Join Server ViP",
	Callback = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
	end
})
local Section1 = Tab2:Section({ Title = "| Teleport" })
local SelectFarm = Tab2:Dropdown({
	Title = "Select Position",
	Values = MiniMap,
	Value = "...",
	Multi = false,
	AllowNone = true,
	Callback = function(diwo)
		_G.MiniMap = diwo
	end
})

Tab2:Button({
	Title = "Teleport To Select",
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("ReplicatedStorage").MinimapPoints[_G.MiniMap].CFrame
	end
})
local lastSell = 0

task.spawn(function()
	while task.wait() do
		pcall(function()
			if _G.ExpFarm then
				if game.Players.LocalPlayer.Character.CharacterValue.Health.Value < 10 then
					game:GetService("ReplicatedStorage").Remotes.Revive:FireServer("AED")
				end
				if game:GetService("Players").LocalPlayer.Inventory.Apple.Value >= 40 then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("ReplicatedStorage").MinimapPoints.Economy.CFrame
					if tick() - lastSell >= 1 then
						lastSell = tick()
						game:GetService("ReplicatedStorage").Remotes.Economy:FireServer("Sell","Apple","40")
					end
				else
					local Found = false
					for _,v in pairs(workspace.Farm.Apple.FarmItem:GetDescendants()) do
						if v:IsA("Model") then
							Found = true
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:GetPivot() * CFrame.new(0,-5,0)
							for _,d in pairs(v:GetDescendants()) do
								if d:IsA("ProximityPrompt") then
									fireproximityprompt(d)
									break
								end
							end
							break
						end
					end
					if not Found then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("ReplicatedStorage").MinimapPoints["Apple"].CFrame
					end
				end
			end
		end)
	end
end)
task.spawn(function()
	while task.wait() do
		pcall(function()
			if _G.Cemen then
			if game:GetService("Players").LocalPlayer.Inventory["Cement Powder"].Value >= 5 then
				game:GetService("ReplicatedStorage").Remotes.Craft:FireServer("General","Cement",1)
			end
			if game:GetService("Players").LocalPlayer.Inventory["Cement"].Value >= 100 then
				game:GetService("ReplicatedStorage").Remotes.Craft:FireServer("General","Cement Pack",1)
			end
			for _,v in pairs(workspace.Cement:GetChildren()) do
				if v:IsA("Model") then
					if not v:FindFirstChild("CementBag") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:GetPivot()*CFrame.new(0,0,5)
						fireproximityprompt(v.CementBag.Attachment.ProximityPrompt)
						wait(1)
					elseif v.CementBag:FindFirstChild("BillboardGui") and v.CementBag.BillboardGui.Enabled == false then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:GetPivot()*CFrame.new(0,0,5)
							fireproximityprompt(v.CementBag.Attachment.ProximityPrompt)
							wait(1)
							game:GetService("ReplicatedStorage").Remotes.WorkEvents:FireServer("CementSteal")
						end
					end
				end
			end
		end)
	end
end)




task.spawn(function()
	while task.wait() do
		pcall(function()
			if _G.Farm then
				local Found = false
				if game.Players.LocalPlayer.Character.CharacterValue.Health.Value < 10 then
					game:GetService("ReplicatedStorage").Remotes.Revive:FireServer("AED")
				end
				for _,v in pairs(workspace.Farm[_G.SelectFarm].FarmItem:GetChildren()) do
					if v:IsA("Model") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:GetPivot() * CFrame.new(0,-6,0)
						for _,d in pairs(v:GetDescendants()) do
							if d:IsA("ProximityPrompt") then
								Found = true
								fireproximityprompt(d)
								break
							end
							if d:IsA("TouchTransmitter") then
								Found = true
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:GetPivot() * CFrame.new(0,-10,0)
								firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,d.Parent,0)
								firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,d.Parent,1)
							end
						end
						if Found then break end
					end
				end
				if not Found then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("ReplicatedStorage").MinimapPoints[_G.SelectFarm].CFrame
				end
			end
		end)
	end
end)
task.spawn(function()
	while task.wait() do
		pcall(function()
			if _G.Posss then
				if _G.SelectProcess == "Ore" then
					if game:GetService("Players").LocalPlayer.Inventory.Ore.Value >= 80 then
				game:GetService("ReplicatedStorage").Remotes.Process:FireServer("Process",_G.SelectProcess,true)
					end
				else
					if game:GetService("Players").LocalPlayer.Inventory["Wood Log"].Value >= 80 then
					game:GetService("ReplicatedStorage").Remotes.Process:FireServer("Process",_G.SelectProcess,true)
					end
				end
			end
		end)
	end
end)



task.spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Farm or _G.ExpFarm or _G.Cemen then
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not hrp:FindFirstChild("BodyClip") then
                local noclip = Instance.new("BodyVelocity")
                noclip.Name = "BodyClip"
                noclip.Parent = hrp
                noclip.MaxForce = Vector3.new(100000, 100000, 100000)
                noclip.Velocity = Vector3.new(0, 0, 0)
            end
        else
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("BodyClip") then
                hrp.BodyClip:Destroy()
            end
        end
    end)
end)
