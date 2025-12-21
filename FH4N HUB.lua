-- FH4N HUB (Kavo UI + Minimize FN)
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

-- FUNGSI MINIMIZE (LOGO FN)
local ScreenGui = Instance.new("ScreenGui")
local MinimizeButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
MinimizeButton.Parent = ScreenGui
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Warna Biru
MinimizeButton.Position = UDim2.new(0.1, 0, 0.1, 0)
MinimizeButton.Size = UDim2.new(0, 50, 0, 50)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Text = "FN"
MinimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Tulisan Hitam
MinimizeButton.TextSize = 25
MinimizeButton.Draggable = true -- Bisa digeser

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MinimizeButton

local Toggled = true
MinimizeButton.MouseButton1Click:Connect(function()
    if Toggled then
        game:GetService("CoreGui"):FindFirstChild("FH4N HUB").Enabled = false
        Toggled = false
    else
        game:GetService("CoreGui"):FindFirstChild("FH4N HUB").Enabled = true
        Toggled = true
    end
end)

-- TAB UTAMA
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

ExtraSection:NewToggle("Player ESP", "Name + Highlight", function(state)
    ESP_Enabled = state
end)

-- ESP Logic
task.spawn(function()
    while task.wait(1) do
        if ESP_Enabled then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("Head") then
                    if not p.Character:FindFirstChild("FN_ESP") then
                        local hl = Instance.new("Highlight", p.Character)
                        hl.Name = "FN_ESP"
                        hl.OutlineColor = Color3.fromRGB(0, 0, 255)
                    end
                    if not p.Character.Head:FindFirstChild("FN_NameTag") then
                        local billboard = Instance.new("BillboardGui", p.Character.Head)
                        billboard.Name = "FN_NameTag"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.AlwaysOnTop = true
                        billboard.ExtentsOffset = Vector3.new(0, 3, 0)
                        local label = Instance.new("TextLabel", billboard)
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.Text = p.Name
                        label.Font = Enum.Font.SourceSansBold
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.TextSize = 14
                    end
                end
            end
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character then
                    if p.Character:FindFirstChild("FN_ESP") then p.Character.FN_ESP:Destroy() end
                    if p.Character.Head:FindFirstChild("FN_NameTag") then p.Character.Head.FN_NameTag:Destroy() end
                end
            end
        end
    end
end)

-- Teleport Input
ExtraSection:NewTextBox("Teleport Player", "Ketik nama", function(txt)
    local target = txt:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():find(target) then
            Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
        end
    end
end)

-- Chat Command TP
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

-- Header Biru
task.wait(1)
for _, v in pairs(game:GetService("CoreGui"):GetDescendants()) do
    if v:IsA("Frame") and v.Name == "Header" then
        v.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    end
end
