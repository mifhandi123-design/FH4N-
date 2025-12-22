-- FH4N HUB | ALL-IN-ONE FINAL STABLE
local LPlayer = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Bersihkan script lama agar tidak tumpang tindih
if game.CoreGui:FindFirstChild("FH4N_FINAL") then game.CoreGui.FH4N_FINAL:Destroy() end

-- --- UI DASAR (Sangat Ringan) ---
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "FH4N_FINAL"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 220, 0, 350)
frame.Position = UDim2.new(0.5, -110, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true -- Fitur drag paling stabil

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "FH4N HUB | ULTIMATE"
title.BackgroundColor3 = Color3.fromRGB(0, 0, 200)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 2.5, 0)
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

-- --- FUNGSI PEMBUAT FITUR ---
local function AddButton(txt, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSans
    b.MouseButton1Click:Connect(callback)
    return b
end

-- ==========================================
-- 1. FITUR PLAYER (FLY, SPEED, JUMP, NOCLIP)
-- ==========================================

AddButton("FLY (ON/OFF)", function()
    _G.Fly = not _G.Fly
    if _G.Fly then
        local bv = Instance.new("BodyVelocity", LPlayer.Character.HumanoidRootPart)
        bv.Name = "FlyV"; bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while _G.Fly do
                bv.Velocity = Camera.CFrame.LookVector * (_G.Speed or 50)
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

AddButton("NOCLIP (ON/OFF)", function()
    _G.Noclip = not _G.Noclip
    RunService.Stepped:Connect(function()
        if _G.Noclip and LPlayer.Character then
            for _, v in pairs(LPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

AddButton("INF JUMP (ON)", function()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        LPlayer.Character.Humanoid:ChangeState(3)
    end)
end)

local speedBox = Instance.new("TextBox", scroll)
speedBox.Size = UDim2.new(1, 0, 0, 35); speedBox.PlaceholderText = "Set Speed (Enter)"; speedBox.Text = ""; speedBox.FocusLost:Connect(function() _G.Speed = tonumber(speedBox.Text); LPlayer.Character.Humanoid.WalkSpeed = _G.Speed end)

-- ==========================================
-- 2. FITUR VISUAL (REALISTIC, BRIGHT, ESP)
-- ==========================================

AddButton("REALISTIC MAX", function()
    local b = Instance.new("BloomEffect", game.Lighting); b.Intensity = 1
    local c = Instance.new("ColorCorrectionEffect", game.Lighting); c.Saturation = 0.5; c.Contrast = 0.2
    local s = Instance.new("SunRaysEffect", game.Lighting); s.Intensity = 0.1
    game.Lighting.Brightness = 2
end)

AddButton("FULL BRIGHT", function()
    game.Lighting.Ambient = Color3.new(1, 1, 1)
    game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
end)

AddButton("ESP PLAYER", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LPlayer and p.Character then
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end)

-- ==========================================
-- 3. TELEPORT & FREECAM
-- ==========================================

local tpBox = Instance.new("TextBox", scroll)
tpBox.Size = UDim2.new(1, 0, 0, 35); tpBox.PlaceholderText = "TP to Player (Name)"; tpBox.FocusLost:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():find(tpBox.Text:lower()) then
            LPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
        end
    end
end)

AddButton("FREECAM", function()
    local p = Instance.new("Part", workspace); p.Anchored = true; p.Transparency = 1; p.CFrame = Camera.CFrame
    Camera.CameraSubject = p
    task.spawn(function()
        while task.wait() do
            p.CFrame = p.CFrame * CFrame.new(LPlayer.Character.Humanoid.MoveDirection * 2)
            Camera.CFrame = p.CFrame
        end
    end)
end)

-- --- TOMBOL CLOSE & MINIMIZE ---
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -30, 0, 0); close.Text = "X"; close.BackgroundColor3 = Color3.new(1, 0, 0); close.MouseButton1Click:Connect(function() sg:Destroy() end)

local min = Instance.new("TextButton", sg)
min.Size = UDim2.new(0, 50, 0, 50); min.Position = UDim2.new(0, 10, 0.5, 0); min.Text = "FN"; min.BackgroundColor3 = Color3.new(0, 0, 1); min.TextColor3 = Color3.new(1,1,1); min.Draggable = true; min.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)) end)

-- --- LOOP SISTEM ---
RunService.RenderStepped:Connect(function()
    if LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then
        if _G.WalkSpeed then LPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeed end
        if _G.Noclip then for _,v in pairs(LPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
end)

UIS.JumpRequest:Connect(function()
    if _G.InfJump and LPlayer.Character then LPlayer.Character.Humanoid:ChangeState(3) end
end)

task.spawn(function()
    while task.wait(1) do
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= LPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local tag = p.Character.Head:FindFirstChild("ESP_TAG")
                if _G.ESP and not tag then
                    local b = Instance.new("BillboardGui", p.Character.Head); b.Name = "ESP_TAG"; b.Size = UDim2.new(0,100,0,40); b.AlwaysOnTop = true
                    local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.Text = p.DisplayName; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.Font = "SourceSansBold"
                elseif not _G.ESP and tag then tag:Destroy() end
            end
        end
    end
end)-- ==========================================
-- KATEGORI: WEATHER SETTINGS
-- ==========================================
local WeatherGrp = CreateDropdown("WEATHER SETTINGS")
local function CreateWButton(name, time, dens)
    local btn = Instance.new("TextButton", WeatherGrp); btn.Size = UDim2.new(0.95, 0, 0, 38); btn.BackgroundColor3 = Color3.fromRGB(45,45,45); btn.Text = name; btn.TextColor3 = Color3.fromRGB(255,255,255); btn.Font = "SourceSansBold"; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() Lighting.ClockTime = time; if Lighting:FindFirstChild("W_Atm") then Lighting.W_Atm:Destroy() end; local a = Instance.new("Atmosphere", Lighting); a.Name = "W_Atm"; a.Density = dens end)
end
CreateWButton("☀️ Siang Realistis", 14, 0.2); CreateWButton("🌙 Malam Cinematic", 0, 0.1); CreateWButton("❄️ Musim Salju", 12, 0.45); CreateWButton("🏝️ Musim Pantai", 15, 0.15)

-- --- CORE LOOPS ---
RunService.Stepped:Connect(function() if _G.Noclip and LPlayer.Character then for _,v in pairs(LPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
UIS.JumpRequest:Connect(function() if _G.InfJump and LPlayer.Character then LPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)
task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local tag = p.Character.Head:FindFirstChild("FN_ESP")
                if _G.ESP and not tag then
                    local bb = Instance.new("BillboardGui", p.Character.Head); bb.Name = "FN_ESP"; bb.Size = UDim2.new(0, 100, 0, 40); bb.AlwaysOnTop = true
                    local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Text = p.DisplayName; lbl.Font = "SourceSansBold"
                elseif not _G.ESP and tag then tag:Destroy() end
            end
        end
    end
end)cal function ResetWeather()
    Lighting.ClockTime = 14; Lighting.Brightness = 2; Lighting.FogEnd = 100000
    if Lighting:FindFirstChild("W_Atm") then Lighting.W_Atm:Destroy() end
end

local function CreateWButton(name, time, dens)
    local btn = Instance.new("TextButton", WeatherGrp)
    btn.Size = UDim2.new(0.95, 0, 0, 38); btn.BackgroundColor3 = Color3.fromRGB(45,45,45); btn.Text = name; btn.TextColor3 = Color3.fromRGB(255,255,255); btn.Font = "SourceSansBold"
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        ResetWeather(); Lighting.ClockTime = time
        local a = Instance.new("Atmosphere", Lighting); a.Name = "W_Atm"; a.Density = dens
    end)
end

CreateWButton("☀️ Siang", 14, 0.2)
CreateWButton("🌙 Malam", 0, 0.1)
CreateWButton("❄️ Salju", 12, 0.45)
CreateWButton("🏝️ Pantai", 15, 0.15)

-- --- LOOPING ---
RunService.Stepped:Connect(function()
    if _G.Noclip and LPlayer.Character then
        for _,v in pairs(LPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

UIS.JumpRequest:Connect(function() if _G.InfJump and LPlayer.Character then LPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)

task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local tag = p.Character.Head:FindFirstChild("FN_ESP")
                if _G.ESP and not tag then
                    local bb = Instance.new("BillboardGui", p.Character.Head); bb.Name = "FN_ESP"; bb.Size = UDim2.new(0, 100, 0, 40); bb.AlwaysOnTop = true
                    local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Text = p.DisplayName; lbl.Font = "SourceSansBold"
                elseif not _G.ESP and tag then tag:Destroy() end
            end
        end
    end
end)
