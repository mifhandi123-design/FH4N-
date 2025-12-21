-- FH4N HUB | ULTIMATE V5 (WITH TELEPORT & FREECAM)
if game.CoreGui:FindFirstChild("FH4N_ULTRA") then game.CoreGui.FH4N_ULTRA:Destroy() end

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FH4N_ULTRA"

-- --- SISTEM DRAG ---
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
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
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "FH4N HUB | VERSION 5"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -70)
Container.Position = UDim2.new(0, 10, 0, 60)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 2100)
Container.ScrollBarThickness = 3
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 10)

-- --- LOGO FN ---
local MinimizeBtn = Instance.new("TextButton", ScreenGui)
MinimizeBtn.Size = UDim2.new(0, 65, 0, 65)
MinimizeBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
MinimizeBtn.Text = "FN"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 22
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0)
MakeDraggable(MinimizeBtn)
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- --- UI HELPERS ---
local function CreateDropdown(name)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(1, 0, 0, 45)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame)

    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(1, 0, 0, 45)
    Button.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    Button.Text = "   [+] " .. name
    Button.TextColor3 = Color3.fromRGB(0, 0, 0)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 16
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Button)

    local Content = Instance.new("Frame", Frame)
    Content.Position = UDim2.new(0, 0, 0, 50)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.BackgroundTransparency = 1
    local CL = Instance.new("UIListLayout", Content)
    CL.Padding = UDim.new(0, 8); CL.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local isOpen = false
    Button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Frame.Size = isOpen and UDim2.new(1, 0, 0, CL.AbsoluteContentSize.Y + 75) or UDim2.new(1, 0, 0, 45)
        Button.Text = isOpen and "   [-] " .. name or "   [+] " .. name
    end)
    return Content
end

local function CreateToggle(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn)
    local s = false
    btn.MouseButton1Click:Connect(function()
        s = not s
        btn.Text = name .. ": " .. (s and "ON" or "OFF")
        btn.BackgroundColor3 = s and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 40)
        callback(s)
    end)
end

-- ==========================================
-- KATEGORI: PLAYER FEATURES (SPEED, FREECAM, TP, ETC)
-- ==========================================
local PlayerGrp = CreateDropdown("PLAYER FEATURES")

CreateToggle("Freecam", PlayerGrp, function(s)
    _G.Freecam = s
    if s then
        local camPart = Instance.new("Part", workspace)
        camPart.Name = "FreecamPart"; camPart.Size = Vector3.new(1,1,1); camPart.Transparency = 1; camPart.CanCollide = false
        camPart.CFrame = Camera.CFrame
        Camera.CameraSubject = camPart
        task.spawn(function()
            while _G.Freecam do
                local char = LPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    camPart.CFrame = camPart.CFrame * CFrame.new(hum.MoveDirection * 2)
                end
                task.wait()
            end
            if char then Camera.CameraSubject = char:FindFirstChildOfClass("Humanoid") end
            camPart:Destroy()
        end)
    end
end)

local TPInput = Instance.new("TextBox", PlayerGrp)
TPInput.Size = UDim2.new(0.95, 0, 0, 40); TPInput.PlaceholderText = "TP to Player Name"; TPInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TPInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TPInput)
TPInput.FocusLost:Connect(function(e)
    if e and TPInput.Text ~= "" then
        local target = TPInput.Text:lower()
        for _, v in pairs(Players:GetPlayers()) do
            if v.Name:lower():find(target) or v.DisplayName:lower():find(target) then
                LPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
end)

CreateToggle("Unlock FPS", PlayerGrp, function(s) if s then setfpscap(999) else setfpscap(60) end end)

local SpeedInput = Instance.new("TextBox", PlayerGrp)
SpeedInput.Size = UDim2.new(0.95, 0, 0, 40); SpeedInput.PlaceholderText = "WalkSpeed (Enter)"; SpeedInput.BackgroundColor3 = Color3.fromRGB(45,45,45); SpeedInput.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", SpeedInput)
SpeedInput.FocusLost:Connect(function(e) if e then _G.CurSpeed = tonumber(SpeedInput.Text) or 16; if LPlayer.Character then LPlayer.Character.Humanoid.WalkSpeed = _G.CurSpeed end end end)

CreateToggle("Fly Analog", PlayerGrp, function(s)
    _G.Flying = s
    local char = LPlayer.Character
    if _G.Flying and char then
        local root = char.HumanoidRootPart
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while _G.Flying do
                local cam = workspace.CurrentCamera
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum.MoveDirection.Magnitude > 0 then
                    bv.Velocity = (cam.CFrame.LookVector * hum.MoveDirection.Magnitude) * (_G.CurSpeed or 16)
                else bv.Velocity = Vector3.new(0,0.1,0) end
                bg.CFrame = cam.CFrame
                task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)

CreateToggle("Infinite Jump", PlayerGrp, function(s) _G.InfJump = s end)
CreateToggle("Noclip", PlayerGrp, function(s) _G.Noclip = s end)

-- ==========================================
-- KATEGORI: VISUAL SETTINGS (LENGKAP)
-- ==========================================
local VisualGrp = CreateDropdown("VISUAL SETTINGS")

CreateToggle("Full Bright", VisualGrp, function(s)
    if s then Lighting.Ambient = Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
    else Lighting.Ambient = Color3.fromRGB(127,127,127); Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127) end
end)

CreateToggle("Anti-Lag (Low GFX)", VisualGrp, function(s)
    if s then
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
            if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
        end
        Lighting.GlobalShadows = false
    else Lighting.GlobalShadows = true end
end)

CreateToggle("RTX Shader", VisualGrp, function(s)
    if s then
        local b = Instance.new("BloomEffect", Lighting); b.Name = "FB"; b.Intensity = 0.5
        local c = Instance.new("ColorCorrectionEffect", Lighting); c.Name = "FC"; c.Contrast = 0.2
    else
        if Lighting:FindFirstChild("FB") then Lighting.FB:Destroy() end
        if Lighting:FindFirstChild("FC") then Lighting.FC:Destroy() end
    end
end)

CreateToggle("ESP Name", VisualGrp, function(s) _G.ESP = s end)

-- ==========================================
-- KATEGORI: WEATHER SETTINGS
-- ==========================================
local WeatherGrp = CreateDropdown("WEATHER SETTINGS")
local function ResetWeather()
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
