-- FH4N HUB | THE DEFINITIVE EDITION (ALL FEATURES)
if game.CoreGui:FindFirstChild("FH4N_ULTIMATE") then 
    game.CoreGui.FH4N_ULTIMATE:Destroy() 
end

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FH4N_ULTIMATE"

-- --- SISTEM DRAG ---
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

-- --- MAIN PANEL ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame)
MakeDraggable(MainFrame)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 50); Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255); Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0); Title.Text = "FH4N HUB | ALL FEATURES"; Title.TextColor3 = Color3.fromRGB(0, 0, 0); Title.Font = "SourceSansBold"; Title.TextSize = 20; Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -70); Container.Position = UDim2.new(0, 10, 0, 60); Container.BackgroundTransparency = 1; Container.CanvasSize = UDim2.new(0, 0, 0, 2600); Container.ScrollBarThickness = 3
local Layout = Instance.new("UIListLayout", Container); Layout.Padding = UDim.new(0, 10)

-- --- LOGO FN (MINIMIZE) ---
local MinimizeBtn = Instance.new("TextButton", ScreenGui)
MinimizeBtn.Size = UDim2.new(0, 65, 0, 65); MinimizeBtn.Position = UDim2.new(0.05, 0, 0.2, 0); MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255); MinimizeBtn.Text = "FN"; MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0); MinimizeBtn.Font = "SourceSansBold"; MinimizeBtn.TextSize = 22
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0)
MakeDraggable(MinimizeBtn)
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- --- UI CONSTRUCTORS ---
local function CreateDropdown(name)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(1, 0, 0, 45); Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Frame.ClipsDescendants = true; Instance.new("UICorner", Frame)
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(1, 0, 0, 45); Button.BackgroundColor3 = Color3.fromRGB(0, 100, 255); Button.Text = "   [+] " .. name; Button.TextColor3 = Color3.fromRGB(0, 0, 0); Button.Font = "SourceSansBold"; Button.TextSize = 16; Button.TextXAlignment = "Left"; Instance.new("UICorner", Button)
    local Content = Instance.new("Frame", Frame); Content.Position = UDim2.new(0, 0, 0, 50); Content.Size = UDim2.new(1, 0, 0, 0); Content.BackgroundTransparency = 1
    local CL = Instance.new("UIListLayout", Content); CL.Padding = UDim.new(0, 8); CL.HorizontalAlignment = "Center"
    local isOpen = false
    Button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Frame.Size = isOpen and UDim2.new(1, 0, 0, CL.AbsoluteContentSize.Y + 80) or UDim2.new(1, 0, 0, 45)
        Button.Text = isOpen and "   [-] " .. name or "   [+] " .. name
    end)
    return Content
end

local function CreateToggle(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = "SourceSansBold"; Instance.new("UICorner", btn)
    local s = false
    btn.MouseButton1Click:Connect(function() s = not s; btn.Text = name .. ": " .. (s and "ON" or "OFF"); btn.BackgroundColor3 = s and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 40); callback(s) end)
end

-- ==========================================
-- 1. PLAYER FEATURES
-- ==========================================
local PlayerGrp = CreateDropdown("PLAYER FEATURES")

CreateToggle("Unlock FPS", PlayerGrp, function(s) if s then setfpscap(999) else setfpscap(60) end end)

local SpeedInp = Instance.new("TextBox", PlayerGrp)
SpeedInp.Size = UDim2.new(0.95, 0, 0, 40); SpeedInp.PlaceholderText = "WalkSpeed (Enter)"; SpeedInp.BackgroundColor3 = Color3.fromRGB(45,45,45); SpeedInp.TextColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", SpeedInp)
SpeedInp.FocusLost:Connect(function(e) if e then _G.WalkSpeed = tonumber(SpeedInp.Text) or 16 end end)

local ZoomInp = Instance.new("TextBox", PlayerGrp)
ZoomInp.Size = UDim2.new(0.95, 0, 0, 40); ZoomInp.PlaceholderText = "Max Zoom (e.g 500)"; ZoomInp.BackgroundColor3 = Color3.fromRGB(45,45,45); ZoomInp.TextColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", ZoomInp)
ZoomInp.FocusLost:Connect(function(e) if e then LPlayer.CameraMaxZoomDistance = tonumber(ZoomInp.Text) or 128 end end)

CreateToggle("Fly Mode", PlayerGrp, function(s)
    _G.Flying = s
    if s and LPlayer.Character then
        local root = LPlayer.Character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6); bv.Name = "F1"
        local bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1e6,1e6,1e6); bg.Name = "G1"
        task.spawn(function()
            while _G.Flying do
                bv.Velocity = Camera.CFrame.LookVector * (LPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 and (_G.WalkSpeed or 16) or 0)
                bg.CFrame = Camera.CFrame; task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)

CreateToggle("Freecam (Smooth)", PlayerGrp, function(s)
    _G.Freecam = s
    if s then
        local p = Instance.new("Part", workspace); p.Anchored = true; p.Transparency = 1; p.CFrame = Camera.CFrame; Camera.CameraSubject = p
        task.spawn(function()
            while _G.Freecam do
                p.CFrame = p.CFrame * CFrame.new(LPlayer.Character.Humanoid.MoveDirection * 1.5)
                Camera.CFrame = p.CFrame; task.wait()
            end
            Camera.CameraSubject = LPlayer.Character.Humanoid; p:Destroy()
        end)
    end
end)

local TPInp = Instance.new("TextBox", PlayerGrp)
TPInp.Size = UDim2.new(0.95, 0, 0, 40); TPInp.PlaceholderText = "TP to Name (Enter)"; TPInp.BackgroundColor3 = Color3.fromRGB(45,45,45); TPInp.TextColor3 = Color3.fromRGB(255,255,255); Instance.new("UICorner", TPInp)
TPInp.FocusLost:Connect(function(e) if e then for _,v in pairs(Players:GetPlayers()) do if v.Name:lower():find(TPInp.Text:lower()) or v.DisplayName:lower():find(TPInp.Text:lower()) then LPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame break end end end end)

CreateToggle("Noclip", PlayerGrp, function(s) _G.Noclip = s end)
CreateToggle("Infinite Jump", PlayerGrp, function(s) _G.InfJump = s end)

-- ==========================================
-- 2. VISUAL FEATURES
-- ==========================================
local VisualGrp = CreateDropdown("VISUAL SETTINGS")

CreateToggle("REALISTIC LVL MAX", VisualGrp, function(s)
    if s then
        local b = Instance.new("BloomEffect", Lighting); b.Name = "R1"; b.Intensity = 1
        local c = Instance.new("ColorCorrectionEffect", Lighting); c.Name = "R2"; c.Saturation = 0.3; c.Contrast = 0.1
        Lighting.Brightness = 2.5
    else
        if Lighting:FindFirstChild("R1") then Lighting.R1:Destroy() end
        if Lighting:FindFirstChild("R2") then Lighting.R2:Destroy() end
        Lighting.Brightness = 1
    end
end)

CreateToggle("Full Bright", VisualGrp, function(s) Lighting.Ambient = s and Color3.new(1,1,1) or Color3.new(0.5,0.5,0.5) end)

CreateToggle("Anti-Lag (Low GFX)", VisualGrp, function(s)
    if s then for _,v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = "SmoothPlastic" end end; Lighting.GlobalShadows = false
    else Lighting.GlobalShadows = true end
end)

CreateToggle("ESP Player Names", VisualGrp, function(s) _G.ESP = s end)

-- ==========================================
-- 3. WEATHER SETTINGS
-- ==========================================
local WeatherGrp = CreateDropdown("WEATHER SETTINGS")
local function SetW(t, d)
    Lighting.ClockTime = t
    if Lighting:FindFirstChild("Atm") then Lighting.Atm:Destroy() end
    local a = Instance.new("Atmosphere", Lighting); a.Name = "Atm"; a.Density = d
end
local wb1 = Instance.new("TextButton", WeatherGrp); wb1.Size = UDim2.new(0.95,0,0,35); wb1.Text = "☀️ Siang Realistis"; wb1.MouseButton1Click:Connect(function() SetW(14, 0.2) end)
local wb2 = Instance.new("TextButton", WeatherGrp); wb2.Size = UDim2.new(0.95,0,0,35); wb2.Text = "🌙 Malam Cinematic"; wb2.MouseButton1Click:Connect(function() SetW(0, 0.1) end)
local wb3 = Instance.new("TextButton", WeatherGrp); wb3.Size = UDim2.new(0.95,0,0,35); wb3.Text = "❄️ Salju / Fog"; wb3.MouseButton1Click:Connect(function() SetW(12, 0.5) end)

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
