-- FH4N HUB | CATEGORIZED + FPS FEATURES
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

-- Bersihkan script lama
if PlayerGui:FindFirstChild("FH4N_ULTRA_V3") then PlayerGui.FH4N_ULTRA_V3:Destroy() end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "FH4N_ULTRA_V3"
sg.ResetOnSpawn = false

-- --- PANEL UTAMA ---
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
title.Size = UDim2.new(1, 0, 1, 0); title.Text = "FH4N HUB | V.FINAL"; title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1; title.Font = "SourceSansBold"; title.TextSize = 16

-- --- SCROLLING AREA ---
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -10, 1, -50); scroll.Position = UDim2.new(0, 5, 0, 45); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0, 0, 8, 0); scroll.ScrollBarThickness = 4
local layout = Instance.new("UIListLayout", scroll); layout.Padding = UDim.new(0, 8)

-- --- FUNGSI UI HELPERS ---
local function AddCategory(name)
    local cFrame = Instance.new("Frame", scroll)
    cFrame.Size = UDim2.new(1, 0, 0, 30); cFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); cFrame.BorderSizePixel = 0
    local lab = Instance.new("TextLabel", cFrame)
    lab.Size = UDim2.new(1, 0, 1, 0); lab.Text = "== " .. name .. " =="; lab.TextColor3 = Color3.fromRGB(0, 255, 255); lab.Font = "SourceSansBold"; lab.BackgroundTransparency = 1
end

local function AddButton(txt, cb)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSans"; b.MouseButton1Click:Connect(cb)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local function AddInput(placeholder, cb)
    local t = Instance.new("TextBox", scroll)
    t.Size = UDim2.new(1, 0, 0, 35); t.PlaceholderText = placeholder; t.BackgroundColor3 = Color3.fromRGB(25, 25, 25); t.TextColor3 = Color3.new(1,1,1); t.Font = "SourceSans"
    t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
end

-- ==========================================
-- [ GRUP 1: PLAYER ]
-- ==========================================
AddCategory("PLAYER SETTINGS")

local flyStatus = "OFF"
local fBtn = AddButton("FLY MOBILE: " .. flyStatus, function()
    _G.FlyEnabled = not _G.FlyEnabled
    if _G.FlyEnabled then
        flyStatus = "ON"
        local root = Player.Character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", root); bv.Name = "M_FlyV"; bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        local bg = Instance.new("BodyGyro", root); bg.Name = "M_FlyG"; bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while _G.FlyEnabled do
                bv.Velocity = Camera.CFrame.LookVector * (Player.Character.Humanoid.MoveDirection.Magnitude > 0 and (_G.WS or 50) or 0)
                bg.CFrame = Camera.CFrame; task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    else flyStatus = "OFF" end
end)

AddButton("NOCLIP (ON/OFF)", function() _G.Nc = not _G.Nc end)
AddInput("Input Speed", function(v) _G.WS = tonumber(v) end)
AddInput("Input Jump", function(v) Player.Character.Humanoid.JumpPower = tonumber(v); Player.Character.Humanoid.UseJumpPower = true end)

-- ==========================================
-- [ GRUP 2: VISUAL (DENGAN FITUR FPS) ]
-- ==========================================
AddCategory("VISUAL & FPS")

AddButton("REALISTIC MAX RTX", function()
    local b = Instance.new("BloomEffect", Lighting); b.Intensity = 1
    local c = Instance.new("ColorCorrectionEffect", Lighting); c.Saturation = 0.5; c.Contrast = 0.2
    Lighting.Brightness = 3; Lighting.GlobalShadows = true
end)

AddButton("UNLOCK FPS (999)", function()
    if setfpscap then
        setfpscap(999)
        print("FPS Unlocked!")
    else
        print("Executor tidak support FPS Unlock")
    end
end)

local fpsShow = false
AddButton("SHOW FPS COUNTER", function()
    fpsShow = not fpsShow
    if fpsShow then
        local fpsLabel = Instance.new("TextLabel", sg)
        fpsLabel.Name = "FPSCounter"
        fpsLabel.Size = UDim2.new(0, 100, 0, 30)
        fpsLabel.Position = UDim2.new(0, 10, 0, 10)
        fpsLabel.BackgroundColor3 = Color3.new(0,0,0)
        fpsLabel.TextColor3 = Color3.new(0,1,0)
        fpsLabel.BackgroundTransparency = 0.5
        task.spawn(function()
            while fpsShow do
                local dt = task.wait(1)
                fpsLabel.Text = "FPS: " .. math.floor(1/dt)
            end
            fpsLabel:Destroy()
        end)
    end
end)

AddButton("ESP PLAYER", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local h = Instance.new("Highlight", p.Character); h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end)

-- ==========================================
-- [ GRUP 3: WEATHER ]
-- ==========================================
AddCategory("WEATHER CONTROL")
AddButton("Siang", function() Lighting.ClockTime = 14 end)
AddButton("Malam", function() Lighting.ClockTime = 0 end)
AddButton("Sore Estetik", function() Lighting.ClockTime = 17.5 end)

-- --- SYSTEM LOOP ---
RunService.Stepped:Connect(function()
    fBtn.Text = "FLY MOBILE: " .. flyStatus
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.FlyEnabled then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then
            for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end
end)

-- --- LOGO MINIMIZE ---
local min = Instance.new("TextButton", sg)
min.Size = UDim2.new(0, 50, 0, 50); min.Position = UDim2.new(0, 10, 0.4, 0); min.Text = "FN"; min.BackgroundColor3 = Color3.new(0,0,1); min.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", min).CornerRadius = UDim.new(1,0)
min.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
