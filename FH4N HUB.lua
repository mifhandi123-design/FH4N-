-- FH4N HUB | MOBILE OPTIMIZED (JOYSTICK FLY)
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

if PlayerGui:FindFirstChild("FH4N_MOBILE_VFINAL") then PlayerGui.FH4N_MOBILE_VFINAL:Destroy() end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "FH4N_MOBILE_VFINAL"
sg.ResetOnSpawn = false

-- --- MAIN PANEL ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 400)
main.Position = UDim2.new(0.5, -130, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- --- HEADER ---
local head = Instance.new("Frame", main)
head.Size = UDim2.new(1, 0, 0, 40)
head.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
local title = Instance.new("TextLabel", head)
title.Size = UDim2.new(1, 0, 1, 0); title.Text = "FH4N HUB MOBILE"; title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1; title.Font = "SourceSansBold"

-- --- SCROLLING AREA ---
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -10, 1, -50); scroll.Position = UDim2.new(0, 5, 0, 45); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 6, 0); scroll.ScrollBarThickness = 3
local layout = Instance.new("UIListLayout", scroll); layout.Padding = UDim.new(0, 5)

-- --- UI HELPERS ---
local function CreateCategory(name)
    local c = Instance.new("TextLabel", scroll)
    c.Size = UDim2.new(1, 0, 0, 30); c.Text = "[ " .. name .. " ]"; c.BackgroundColor3 = Color3.fromRGB(30, 30, 30); c.TextColor3 = Color3.fromRGB(0, 255, 255); c.Font = "SourceSansBold"
end

local function CreateButton(txt, cb)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSans"; b.MouseButton1Click:Connect(cb)
    return b
end

local function CreateInput(placeholder, cb)
    local t = Instance.new("TextBox", scroll)
    t.Size = UDim2.new(1, 0, 0, 35); t.PlaceholderText = placeholder; t.BackgroundColor3 = Color3.fromRGB(35, 35, 35); t.TextColor3 = Color3.new(1,1,1)
    t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
end

-- ==========================================
-- [ 1. KATEGORI PLAYER (MOBILE FLY) ]
-- ==========================================
CreateCategory("PLAYER FEATURES")

local flyBtn = CreateButton("FLY MOBILE: OFF", function()
    _G.FlyEnabled = not _G.FlyEnabled
    local hum = Player.Character:WaitForChild("Humanoid")
    local root = Player.Character:WaitForChild("HumanoidRootPart")
    
    if _G.FlyEnabled then
        _G.FlyBtnText = "FLY MOBILE: ON"
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "MobileFlyV"
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bv.Velocity = Vector3.new(0,0,0)
        
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "MobileFlyG"
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        bg.CFrame = root.CFrame

        task.spawn(function()
            while _G.FlyEnabled do
                bv.Velocity = Camera.CFrame.LookVector * (hum.MoveDirection.Magnitude > 0 and (_G.WS or 50) or 0)
                bg.CFrame = Camera.CFrame
                task.wait()
            end
            bv:Destroy()
            bg:Destroy()
        end)
    else
        _G.FlyBtnText = "FLY MOBILE: OFF"
    end
end)

CreateButton("NOCLIP (ON/OFF)", function() _G.Nc = not _G.Nc end)
CreateButton("INF JUMP (ON)", function() 
    game:GetService("UserInputService").JumpRequest:Connect(function() Player.Character.Humanoid:ChangeState(3) end)
end)

CreateInput("Set Speed", function(v) _G.WS = tonumber(v) end)
CreateInput("Set Jump", function(v) Player.Character.Humanoid.JumpPower = tonumber(v); Player.Character.Humanoid.UseJumpPower = true end)
CreateInput("TP Player Name", function(v) 
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():find(v:lower()) then Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end
    end
end)

-- ==========================================
-- [ 2. KATEGORI VISUAL ]
-- ==========================================
CreateCategory("VISUAL SETTINGS")

CreateButton("REALISTIC LVL MAX", function()
    local b = Instance.new("BloomEffect", Lighting); b.Intensity = 1
    local c = Instance.new("ColorCorrectionEffect", Lighting); c.Saturation = 0.5
    Lighting.Brightness = 3; Lighting.GlobalShadows = true
end)

CreateButton("FULL BRIGHT", function() Lighting.Ambient = Color3.new(1,1,1) end)
CreateButton("ESP PLAYER", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local h = Instance.new("Highlight", p.Character); h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end)

-- ==========================================
-- [ 3. KATEGORI CUACA ]
-- ==========================================
CreateCategory("WEATHER SETTINGS")
CreateButton("Siang", function() Lighting.ClockTime = 14 end)
CreateButton("Malam", function() Lighting.ClockTime = 0 end)
CreateButton("Sore", function() Lighting.ClockTime = 17.5 end)

-- --- RUNTIME LOOP ---
RunService.Stepped:Connect(function()
    flyBtn.Text = _G.FlyBtnText or "FLY MOBILE: OFF"
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.FlyEnabled then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then
            for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- LOGO FN
local min = Instance.new("TextButton", sg)
min.Size = UDim2.new(0, 45, 0, 45); min.Position = UDim2.new(0, 10, 0.4, 0); min.Text = "FN"; min.BackgroundColor3 = Color3.new(0,0,1); min.TextColor3 = Color3.new(1,1,1)
min.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
