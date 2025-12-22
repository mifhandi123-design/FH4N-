-- FH4N HUB | V5 DEFINITIVE MODERN UI
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Bersihkan Sisa Script
if PlayerGui:FindFirstChild("FH4N_V5") then PlayerGui.FH4N_V5:Destroy() end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "FH4N_V5"
sg.ResetOnSpawn = false

-- --- MAIN PANEL ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 280, 0, 420)
main.Position = UDim2.new(0.5, -140, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

-- --- HEADER ---
local head = Instance.new("Frame", main)
head.Size = UDim2.new(1, 0, 0, 45)
head.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
head.BorderSizePixel = 0
local hCorner = Instance.new("UICorner", head)
hCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", head)
title.Size = UDim2.new(1, 0, 1, 0); title.Text = "FH4N HUB V5"; title.TextColor3 = Color3.new(1, 1, 1); title.BackgroundTransparency = 1; title.Font = "GothamBold"; title.TextSize = 18

-- --- SCROLLING BODY ---
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -15, 1, -55); scroll.Position = UDim2.new(0, 7, 0, 50); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 0, 1000); scroll.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", scroll); layout.Padding = UDim.new(0, 10); layout.HorizontalAlignment = "Center"

-- --- UI COMPONENT HELPERS ---
local function CreateCategory(name)
    local lab = Instance.new("TextLabel", scroll)
    lab.Size = UDim2.new(0.95, 0, 0, 30); lab.Text = name; lab.TextColor3 = Color3.fromRGB(150, 150, 255); lab.Font = "GothamBold"; lab.BackgroundTransparency = 1; lab.TextSize = 13; lab.TextXAlignment = "Left"
end

local function CreateToggle(txt, cb)
    local state = false
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.95, 0, 0, 38); b.BackgroundColor3 = Color3.fromRGB(35, 35, 45); b.Text = txt .. " : OFF"; b.TextColor3 = Color3.new(0.7, 0.7, 0.7); b.Font = "GothamSemibold"; b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(50, 80, 255) or Color3.fromRGB(35, 35, 45)
        b.TextColor3 = state and Color3.new(1, 1, 1) or Color3.new(0.7, 0.7, 0.7)
        b.Text = txt .. " : " .. (state and "ON" or "OFF")
        cb(state)
    end)
end

local function CreateInput(placeholder, cb)
    local t = Instance.new("TextBox", scroll)
    t.Size = UDim2.new(0.95, 0, 0, 38); t.PlaceholderText = placeholder; t.BackgroundColor3 = Color3.fromRGB(25, 25, 30); t.TextColor3 = Color3.new(1, 1, 1); t.Font = "Gotham"
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 8)
    t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
end

-- ==========================================
-- [ 1. CATEGORY: PLAYER ]
-- ==========================================
CreateCategory("PLAYER SETTINGS")

CreateToggle("Mobile Fly", function(s)
    _G.Fly = s
    if s then
        local root = Player.Character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", root); bv.Name = "V5Fly"; bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        local bg = Instance.new("BodyGyro", root); bg.Name = "V5Gyro"; bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while _G.Fly do
                bv.Velocity = Camera.CFrame.LookVector * (Player.Character.Humanoid.MoveDirection.Magnitude > 0 and (_G.WS or 50) or 0)
                bg.CFrame = Camera.CFrame; task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)

CreateToggle("Noclip", function(s) _G.Nc = s end)
CreateToggle("Infinite Jump", function(s) _G.InfJ = s end)
UIS.JumpRequest:Connect(function() if _G.InfJ then Player.Character.Humanoid:ChangeState(3) end end)

CreateInput("Set WalkSpeed", function(v) _G.WS = tonumber(v) end)
CreateInput("Set JumpPower", function(v) Player.Character.Humanoid.JumpPower = tonumber(v); Player.Character.Humanoid.UseJumpPower = true end)

-- ==========================================
-- [ 2. CATEGORY: VISUAL & FPS ]
-- ==========================================
CreateCategory("VISUAL & FPS")

CreateToggle("Show FPS Counter", function(s)
    _G.FPS = s
    if s then
        local fL = Instance.new("TextLabel", sg); fL.Size = UDim2.new(0, 80, 0, 25); fL.Position = UDim2.new(0, 10, 0, 10); fL.BackgroundColor3 = Color3.new(0,0,0); fL.TextColor3 = Color3.new(0,1,0); fL.BackgroundTransparency = 0.4; Instance.new("UICorner", fL)
        task.spawn(function() while _G.FPS do local dt = task.wait(1) fL.Text = "FPS: " .. math.floor(1/dt) end fL:Destroy() end)
    end
end)

CreateToggle("Unlock FPS (999)", function(s)
    if setfpscap then setfpscap(s and 999 or 60) end
end)

CreateToggle("Player ESP + Name", function(s)
    _G.ESP = s
    while _G.ESP do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not p.Character:FindFirstChild("V5_ESP") then
                    local h = Instance.new("Highlight", p.Character); h.Name = "V5_ESP"; h.FillColor = Color3.new(1,0,0)
                    local bg = Instance.new("BillboardGui", p.Character.HumanoidRootPart); bg.Name = "V5_Name"; bg.Size = UDim2.new(0,100,0,20); bg.AlwaysOnTop = true; bg.ExtentsOffset = Vector3.new(0,3,0)
                    local tl = Instance.new("TextLabel", bg); tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1; tl.Text = p.Name; tl.TextColor3 = Color3.new(1,1,1); tl.Font = "GothamBold"; tl.TextSize = 12
                end
            end
        end
        task.wait(1)
    end
    -- Clean Up
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character then 
            if p.Character:FindFirstChild("V5_ESP") then p.Character.V5_ESP:Destroy() end
            if p.Character.HumanoidRootPart:FindFirstChild("V5_Name") then p.Character.HumanoidRootPart.V5_Name:Destroy() end
        end
    end
end)

CreateToggle("Realistic Graphics", function(s)
    Lighting.Brightness = s and 3 or 1
    if s then local b = Instance.new("BloomEffect", Lighting); b.Name = "V5B" else if Lighting:FindFirstChild("V5B") then Lighting.V5B:Destroy() end end
end)

-- ==========================================
-- [ 3. CATEGORY: WORLD ]
-- ==========================================
CreateCategory("ENVIRONMENT")
local bDay = Instance.new("TextButton", scroll)
bDay.Size = UDim2.new(0.95, 0, 0, 38); bDay.Text = "Set Day"; bDay.BackgroundColor3 = Color3.fromRGB(35,35,45); bDay.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", bDay)
bDay.MouseButton1Click:Connect(function() Lighting.ClockTime = 14 end)

-- --- SYSTEM ---
RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
end)

-- MINIMIZE
local min = Instance.new("TextButton", sg)
min.Size = UDim2.new(0, 45, 0, 45); min.Position = UDim2.new(0, 10, 0.4, 0); min.Text = "FN"; min.BackgroundColor3 = Color3.fromRGB(50, 80, 255); min.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", min).CornerRadius = UDim.new(1,0)
min.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
