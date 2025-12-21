-- FH4N HUB - DROPDOWN GROUPING SYSTEM
if game.CoreGui:FindFirstChild("FH4N_FINAL") then game.CoreGui.FH4N_FINAL:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local Container = Instance.new("ScrollingFrame", MainFrame)
local MinimizeBtn = Instance.new("TextButton", ScreenGui)

-- --- UI DASAR ---
MainFrame.Size = UDim2.new(0, 260, 0, 400)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "FH4N HUB | EXTREME GROUPING"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 1200)
Container.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 5)

-- --- FUNGSI BUAT KELOMPOK (DROPDOWN) ---
local function CreateDropdown(name)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame)

    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    Button.Text = "   " .. name .. " [ Klik untuk Buka ]"
    Button.TextColor3 = Color3.fromRGB(0, 0, 0)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Button)

    local Content = Instance.new("Frame", Frame)
    Content.Position = UDim2.new(0, 0, 0, 40)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.BackgroundTransparency = 1
    
    local ContentLayout = Instance.new("UIListLayout", Content)
    ContentLayout.Padding = UDim.new(0, 5)
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local isOpen = false
    Button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            Frame.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y + 45)
            Button.Text = "   " .. name .. " [ Klik untuk Tutup ]"
        else
            Frame.Size = UDim2.new(1, 0, 0, 35)
            Button.Text = "   " .. name .. " [ Klik untuk Buka ]"
        end
    end)
    
    return Content
end

-- --- FUNGSI TOGGLE ---
local function CreateToggle(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end

-- ==========================================
-- KELOMPOK 1: PLAYER (DROPDOWN)
-- ==========================================
local PlayerGroup = CreateDropdown("PLAYER")

local SpeedInput = Instance.new("TextBox", PlayerGroup)
SpeedInput.Size = UDim2.new(0.95, 0, 0, 35)
SpeedInput.PlaceholderText = "Input Speed + Enter"
SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedInput.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", SpeedInput)

local CurrentFlySpeed = 50
SpeedInput.FocusLost:Connect(function(e) if e then CurrentFlySpeed = tonumber(SpeedInput.Text) or 50; game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = CurrentFlySpeed end end)

CreateToggle("Fly Analog", PlayerGroup, function(state)
    Flying = state
    local char = game.Players.LocalPlayer.Character
    if Flying and char then
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while Flying do
                local cam = workspace.CurrentCamera
                if hum.MoveDirection.Magnitude > 0 then
                    bv.Velocity = (cam.CFrame.LookVector * hum.MoveDirection.Magnitude) * CurrentFlySpeed
                else bv.Velocity = Vector3.new(0,0.1,0) end
                bg.CFrame = cam.CFrame
                task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)

CreateToggle("Noclip", PlayerGroup, function(s) NoclipEnabled = s end)
CreateToggle("Infinite Jump", PlayerGroup, function(s) InfJumpEnabled = s end)

local TPInput = Instance.new("TextBox", PlayerGroup)
TPInput.Size = UDim2.new(0.95, 0, 0, 35)
TPInput.PlaceholderText = "TP Name + Enter"
TPInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TPInput.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", TPInput)

-- ==========================================
-- KELOMPOK 2: VISUAL (DROPDOWN)
-- ==========================================
local VisualGroup = CreateDropdown("VISUAL")

CreateToggle("RTX 5080 Effects", VisualGroup, function(state)
    local L = game:GetService("Lighting")
    if state then
        local b = Instance.new("BloomEffect", L); b.Name = "RTXB"
        local c = Instance.new("ColorCorrectionEffect", L); c.Name = "RTXC"; c.Contrast = 0.2
    else
        if L:FindFirstChild("RTXB") then L.RTXB:Destroy() end
        if L:FindFirstChild("RTXC") then L.RTXC:Destroy() end
    end
end)

CreateToggle("PC Port (Extreme)", VisualGroup, function(state)
    local L = game:GetService("Lighting")
    if state then
        local a = Instance.new("Atmosphere", L); a.Name = "PCP"; a.Density = 0.35
        L.Brightness = 2.5
    else
        if L:FindFirstChild("PCP") then L.PCP:Destroy() end
        L.Brightness = 1
    end
end)

CreateToggle("Dynamic Shadows", VisualGroup, function(state)
    game.Lighting.GlobalShadows = state
    game.Lighting.EnvironmentDiffuseScale = state and 1 or 0
    game.Lighting.EnvironmentSpecularScale = state and 1 or 0
end)

CreateToggle("ESP Player Name", VisualGroup, function(s) ESP_Enabled = s end)

-- --- MINIMIZE & CORE ---
MinimizeBtn.Size = UDim2.new(0, 70, 0, 40)
MinimizeBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
MinimizeBtn.Text = "FN —"
Instance.new("UICorner", MinimizeBtn)
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
