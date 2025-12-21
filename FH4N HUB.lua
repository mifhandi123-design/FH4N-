-- FH4N HUB (Versi Awal - Kavo UI)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FH4N HUB", "DarkTheme")

-- Variabel Utama
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false
local ESP_Enabled = false

-- Kustomisasi Warna Header (Biru)
for _, v in pairs(game:GetService("CoreGui"):GetDescendants()) do
    if v:IsA("Frame") and v.Name == "Header" then
        v.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    end
end

-- Tab Utama
local MainTab = Window:NewTab("FN | Features")
local Section = MainTab:NewSection("FN BIGRONE")

-- FEATURE: SPEED
Section:NewSlider("Walkspeed", "Ubah kecepatan jalan", 500, 16, function(s)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = s
    end
end)

-- FEATURE: FLY (Mobile Friendly)
Section:NewToggle("Fly", "Terbang ke arah kamera", function(state)
    Flying = state
    local Root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if Flying and Root then
        local bv = Instance.new("BodyVelocity", Root)
        bv.Name = "FN_FlyBV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local bg = Instance.new("BodyGyro", Root)
        bg.Name = "FN_FlyBG"
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
end)

Section:NewSlider("Fly Speed", "Atur kecepatan terbang", 300, 10, function(s)
    FlySpeed = s
end)

-- FEATURE: NOCLIP
Section:NewToggle("Noclip", "Menembus tembok", function(state)
    Noclip = state
end)

RunService.Stepped:Connect(function()
    if Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- FEATURE: INF JUMP
Section:NewToggle("Infinite Jump", "Lompat tanpa batas", function(state)
    InfJump = state
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- TAB EXTRA (ESP & TP)
local ExtraTab = Window:NewTab("FN | Extra")
local ExtraSection = ExtraTab:NewSection("Teleport & Visual")

ExtraSection:NewToggle("Player ESP", "Lihat pemain di balik tembok", function(state)
    ESP_Enabled = state
end)

-- ESP Logic (Highlight)
task.spawn(function()
    while task.wait(1) do
        if ESP_Enabled then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and not p.Character:FindFirstChild("FN_ESP") then
                    local hl = Instance.new("Highlight", p.Character)
                    hl.Name = "FN_ESP"
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(0, 0, 255)
                end
            end
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("FN_ESP") then
                    p.Character.FN_ESP:Destroy()
                end
            end
        end
    end
end)

-- Teleport Input
ExtraSection:NewTextBox("Teleport Player", "Masukkan nama player", function(txt)
    local target = txt:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():find(target) or v.DisplayName:lower():find(target) then
            Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
        end
    end
end)

-- Chat Command TP (tp:nama)
Player.Chatted:Connect(function(msg)
    if msg:sub(1,3) == "tp:" then
        local target = msg:sub(4):lower()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Name:lower():find(target) then
                Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- Notifikasi Selesai
Library:Notify("FH4N HUB Loaded", "Logo: FN BIGRONE Aktif", "rbxassetid://6023456806")
