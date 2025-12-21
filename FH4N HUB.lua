local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "FH4N HUB", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "FH4N_Config",
    IntroText = "FN BIGRONE" -- Logo saat loading
})

-- Variabel Global
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false

-- FUNGSI TELEPORT
local function teleportToPlayer(targetName)
    targetName = targetName:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():sub(1, #targetName) == targetName or v.DisplayName:lower():sub(1, #targetName) == targetName then
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                return
            end
        end
    end
end

-- CHAT COMMAND (tp:nama)
Player.Chatted:Connect(function(msg)
    local split = msg:split(":")
    if split[1]:lower() == "tp" and split[2] then
        teleportToPlayer(split[2])
    end
end)

-- TAB UTAMA (Logo FN)
local MainTab = Window:MakeTab({
	Name = "FN | Main",
	Icon = "rbxassetid://4483345998"
})

MainTab:AddSlider({
	Name = "Walkspeed",
	Min = 16, Max = 500, Default = 16, Color = Color3.fromRGB(0,0,255), Increment = 1,
	Callback = function(Value)
		if Player.Character and Player.Character:FindFirstChild("Humanoid") then
			Player.Character.Humanoid.WalkSpeed = Value
		end
	end    
})

MainTab:AddToggle({
	Name = "Fly (Mobile)",
	Default = false,
	Callback = function(Value)
		Flying = Value
		local Root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
		if Flying and Root then
			local bv = Instance.new("BodyVelocity", Root)
			bv.Name = "FN_Fly"
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			local bg = Instance.new("BodyGyro", Root)
			bg.Name = "FN_Gyro"
			bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			task.spawn(function()
				while Flying and Root.Parent do
					bv.Velocity = Camera.CFrame.LookVector * FlySpeed
					bg.CFrame = Camera.CFrame
					RunService.RenderStepped:Wait()
				end
				if bv then bv:Destroy() end
				if bg then bg:Destroy() end
			end)
		end
	end
})

MainTab:AddSlider({
	Name = "Fly Speed",
	Min = 10, Max = 300, Default = 50, Color = Color3.fromRGB(0,0,255), Increment = 1,
	Callback = function(Value) FlySpeed = Value end    
})

MainTab:AddToggle({
	Name = "Noclip",
	Default = false,
	Callback = function(Value) Noclip = Value end
})

MainTab:AddToggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(Value) InfJump = Value end
})

-- TAB EXTRA
local ExtraTab = Window:MakeTab({
	Name = "FN | Extra",
	Icon = "rbxassetid://4483345998"
})

ExtraTab:AddInput({
	Name = "TP ke Player",
	PlaceholderText = "Username...",
	Callback = function(Text) teleportToPlayer(Text) end
})

-- LOOP LOGIC
RunService.Stepped:Connect(function()
	if Noclip and Player.Character then
		for _, v in pairs(Player.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
	if InfJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
		Player.Character.Humanoid:ChangeState("Jumping")
	end
end)

OrionLib:Init()
