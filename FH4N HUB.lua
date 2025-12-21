-- FH4N HUB - WEATHER & VISUAL EDITION
if game.CoreGui:FindFirstChild("FH4N_FINAL") then game.CoreGui.FH4N_FINAL:Destroy() end

local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FH4N_FINAL"

-- --- DRAG SYSTEM ---
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
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame)
MakeDraggable(MainFrame)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "FH4N HUB | WEATHER & VISUAL"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -65)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 1200)
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
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame)

    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    Button.Text = "   [+] " .. name
    Button.TextColor3 = Color3.fromRGB(0, 0, 0)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 16
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Button)

    local Content = Instance.new("Frame", Frame)
    Content.Position = UDim2.new(0, 0, 0, 45)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.BackgroundTransparency = 1
    local CL = Instance.new("UIListLayout", Content)
    CL.Padding = UDim.new(0, 8)
    CL.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local isOpen = false
    Button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Frame.Size = isOpen and UDim2.new(1, 0, 0, CL.AbsoluteContentSize.Y + 60) or UDim2.new(1, 0, 0, 40)
        Button.Text = isOpen and "   [-] " .. name or "   [+] " .. name
    end)
    return Content
end

local function CreateButton(name, parent, color, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 38)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- KATEGORI: VISUAL & WEATHER
-- ==========================================
local VisualGrp = CreateDropdown("VISUAL & WEATHER")

-- Fungsi Reset Cuaca
local function ResetWeather()
    Lighting.ClockTime = 14
    Lighting.Brightness = 2
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = true
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    local atm = Lighting:FindFirstChild("WeatherAtm")
    if atm then atm:Destroy() end
end

CreateButton("☀️ Siang (Realistis)", VisualGrp, Color3.fromRGB(255, 140, 0), function()
    ResetWeather()
    Lighting.ClockTime = 14
    Lighting.Brightness = 3
    local atm = Instance.new("Atmosphere", Lighting)
    atm.Name = "WeatherAtm"; atm.Density = 0.2; atm.Glare = 0.5
end)

CreateButton("🌙 Malam (Cinematic)", VisualGrp, Color3.fromRGB(25, 25, 112), function()
    ResetWeather()
    Lighting.ClockTime = 0
    Lighting.Brightness = 0.5
    Lighting.OutdoorAmbient = Color3.fromRGB(10, 10, 30)
    local atm = Instance.new("Atmosphere", Lighting)
    atm.Name = "WeatherAtm"; atm.Density = 0.1
end)

CreateButton("❄️ Musim Salju", VisualGrp, Color3.fromRGB(200, 230, 255), function()
    ResetWeather()
    Lighting.ClockTime = 12
    Lighting.FogColor = Color3.fromRGB(200, 200, 200)
    Lighting.FogEnd = 500
    local atm = Instance.new("Atmosphere", Lighting)
    atm.Name = "WeatherAtm"; atm.Density = 0.5; atm.Color = Color3.fromRGB(200, 200, 200)
end)

CreateButton("🌸 Musim Semi (Soft)", VisualGrp, Color3.fromRGB(255, 182, 193), function()
    ResetWeather()
    Lighting.ClockTime = 10
    local atm = Instance.new("Atmosphere", Lighting)
    atm.Name = "WeatherAtm"; atm.Density = 0.25; atm.Color = Color3.fromRGB(255, 200, 200)
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 120, 120)
end)

CreateButton("🏝️ Musim Pantai (Summer)", VisualGrp, Color3.fromRGB(0, 191, 255), function()
    ResetWeather()
    Lighting.ClockTime = 15
    Lighting.Brightness = 4
    local atm = Instance.new("Atmosphere", Lighting)
    atm.Name = "WeatherAtm"; atm.Density = 0.15; atm.Color = Color3.fromRGB(255, 240, 200); atm.Glare = 1
end)

-- ==========================================
-- KATEGORI: PLAYER
-- ==========================================
local PlayerGrp = CreateDropdown("PLAYER")

local SpeedInput = Instance.new("TextBox", PlayerGrp)
SpeedInput.Size = UDim2.new(0.95, 0, 0, 38)
SpeedInput.PlaceholderText = "Set Speed (Enter)"
SpeedInput.BackgroundColor3 = Color3.fromRGB(45,45,45)
SpeedInput.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", SpeedInput)

local CurSpeed = 16
SpeedInput.FocusLost:Connect(function(e) if e then CurSpeed = tonumber(SpeedInput.Text) or 16; if game.Players.LocalPlayer.Character then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = CurSpeed end end end)

local TPInput = Instance.new("TextBox", PlayerGrp)
TPInput.Size = UDim2.new(0.95, 0, 0, 38)
TPInput.PlaceholderText = "Teleport Name"
TPInput.BackgroundColor3 = Color3.fromRGB(45,45,45)
TPInput.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", TPInput)

TPInput.FocusLost:Connect(function(e)
    if e then
        local t = TPInput.Text:lower()
        for _,v in pairs(game.Players:GetPlayers()) do
            if v.Name:lower():find(t) then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame end
        end
    end
end)
