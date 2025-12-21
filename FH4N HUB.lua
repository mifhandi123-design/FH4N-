-- FH4N HUB Script (Mobile Optimized)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FH4N HUB (Mobile)", "DarkTheme")

-- Variabel Utama
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Tab Utama
local MainTab = Window:NewTab("Main Features")
local Section = MainTab:NewSection("Player Cheats")

-- [1] FEATURE: SPEED
Section:NewSlider("Walkspeed", "Ubah kecepatan jalan", 500, 16, function(s)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = s
    end
end)

-- [2] FEATURE: INFINITE JUMP
local InfiniteJumpEnabled = false
game:GetService("UserInputService").JumpRequest:Connect(function()
	if InfiniteJumpEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
		Player.Character.Humanoid:ChangeState("Jumping")
	end
end)

Section:NewToggle("Infinite Jump", "Lompat tanpa batas", function(state)
    InfiniteJumpEnabled = state
end)

-- [3] FEATURE: NOCLIP
local NoclipEnabled = false
RunService.Stepped:Connect(function()
    if NoclipEnabled and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

Section:NewToggle("Noclip", "Menembus tembok", function(state)
    NoclipEnabled = state
end)

-- [4] FEATURE: MOBILE FLY (Arah Kamera)
local Flying = false
local FlySpeed = 50

Section:NewSlider("Fly Speed", "Kecepatan terbang", 200, 10, function(v)
    FlySpeed = v
end)

Section:NewToggle("Fly (Mobile)", "Terbang ke arah kamera", function(state)
    Flying = state
    local Char = Player.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    
    local Root = Char.HumanoidRootPart
    
    if Flying then
        -- Menghilangkan gravitasi sementara
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
