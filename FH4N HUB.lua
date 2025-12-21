local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "FH4N HUB", HidePremium = false, SaveConfig = true, ConfigFolder = "FH4NHubConfig"})

-- Variabel
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Flying = false
local FlySpeed = 50
local NoclipEnabled = false
local InfiniteJumpEnabled = false

-- Tab Utama
local MainTab = Window:MakeTab({
	Name = "Features",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Fitur Speed
MainTab:AddSlider({
	Name = "Walkspeed",
	Min = 16,
	Max = 300,
	Default = 16,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		if Player.Character and Player.Character:FindFirstChild("Humanoid") then
			Player.Character.Humanoid.WalkSpeed = Value
		end
	end    
})

-- Fitur Infinite Jump
MainTab:AddToggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(Value)
		InfiniteJumpEnabled = Value
	end    
})

game:GetService("UserInputService").JumpRequest:Connect(function()
	if InfiniteJumpEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
		Player.Character.Humanoid:ChangeState("Jumping")
	end
end)

-- Fitur Noclip
MainTab:AddToggle({
	Name = "Noclip",
	Default = false,
	Callback = function(Value)
		NoclipEnabled = Value
	end    
})

RunService.Stepped:Connect(function()
	if NoclipEnabled and Player.Character then
		for _, v in pairs(Player.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- Fitur Fly (Mobile Friendly)
MainTab:AddToggle({
	Name = "Fly (Arah Kamera)",
	Default = false,
	Callback = function(Value)
		Flying = Value
		local Char = Player.Character
		if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
		local Root = Char.HumanoidRootPart

		if Flying then
			local bv = Instance.new("BodyVelocity")
			bv.Name = "FH4N_Fly"
			bv.Parent = Root
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bv.Velocity = Vector3.new(0,0,0)

			local bg = Instance.new("BodyGyro")
			bg.Name = "FH4N_Gyro"
			bg.Parent = Root
			bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			bg.CFrame = Root.CFrame

			task.spawn(function()
				while Flying and Char:FindFirstChild("HumanoidRootPart") do
					bv.Velocity = Camera.CFrame.LookVector * FlySpeed
					bg.CFrame = Camera.CFrame
					RunService.RenderStepped:Wait()
				end
				bv:Destroy()
				bg:Destroy()
			end)
		end
	end    
})

MainTab:AddSlider({
	Name = "Fly Speed",
	Min = 10,
	Max = 300,
	Default = 50,
	Color = Color3.fromRGB(0,255,0),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		FlySpeed = Value
	end    
})

OrionLib:Init()        local bv = Instance.new("BodyVelocity")
        bv.Name = "FH4N_Fly"
        bv.Parent = Root
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0,0,0)
        
        local bg = Instance.new("BodyGyro")
        bg.Name = "FH4N_Gyro"
        bg.Parent = Root
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = Root.CFrame

        task.spawn(function()
            while Flying and Char:FindFirstChild("HumanoidRootPart") do
                -- Di mobile, karakter akan terbang ke arah kamera menunjuk
                bv.Velocity = Camera.CFrame.LookVector * FlySpeed
                bg.CFrame = Camera.CFrame
                RunService.RenderStepped:Wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    else
        if Root:FindFirstChild("FH4N_Fly") then Root.FH4N_Fly:Destroy() end
        if Root:FindFirstChild("FH4N_Gyro") then Root.FH4N_Gyro:Destroy() end
    end
end)

Library:Notify("FH4N HUB Loaded!", "Gunakan Slider Fly untuk kontrol.", "rbxassetid://6023456806")
