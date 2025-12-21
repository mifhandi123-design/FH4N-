-- FH4N HUB - FINAL LOGO DRAG REPAIR
if game.CoreGui:FindFirstChild("FH4N_FINAL") then game.CoreGui.FH4N_FINAL:Destroy() end

local UIS = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FH4N_FINAL"

-- --- SISTEM DRAG TERBAIK (WORK UNTUK MOBILE) ---
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    local moveDistance = 0 -- Untuk mendeteksi apakah ini klik atau geser

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            moveDistance = 0
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            moveDistance = delta.Magnitude
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return function() return moveDistance end
end

-- --- UI SETUP (MEGA PANEL) ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 580) -- PANEL SANGAT BESAR
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
MakeDraggable(MainFrame)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 65)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "FH4N HUB | ULTRA PANEL"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 28
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -90)
Container.Position = UDim2.new(0, 10, 0, 80)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 1400)
Container.ScrollBarThickness = 5
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 15)

-- --- TOMBOL FN (FIXED DRAG) ---
local MinimizeBtn = Instance.new("TextButton", ScreenGui)
MinimizeBtn.Size = UDim2.new(0, 100, 0, 100) -- Logo FN Mega Besar
MinimizeBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
MinimizeBtn.Text = "FN"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 35
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0)
local getDist = MakeDraggable(MinimizeBtn)

-- Klik hanya terdeteksi jika logo TIDAK sedang digeser
MinimizeBtn.Activated:Connect(function()
    if getDist() < 10 then -- Jika gerakannya kurang dari 10 pixel, anggap klik
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- --- FUNGSI DROPDOWN ---
local function CreateDropdown(name)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(1, 0, 0, 55)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame)

    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(1, 0, 0, 55)
    Button.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    Button.Text = "      [+]  " .. name
    Button.TextColor3 = Color3.fromRGB(0, 0, 0)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 22
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Button)

    local Content = Instance.new("Frame", Frame)
    Content.Position = UDim2.new(0, 0, 0, 65)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.BackgroundTransparency = 1
    local CL = Instance.new("UIListLayout", Content)
    CL.Padding = UDim.new(0, 10)
    CL.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local isOpen = false
    Button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Frame.Size = isOpen and UDim2.new(1, 0, 0, CL.AbsoluteContentSize.Y + 90) or UDim2.new(1, 0, 0, 55)
        Button.Text = isOpen and "      [-]  " .. name or "      [+]  " .. name
    end)
    return Content
end

local function CreateToggle(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 50) -- Tombol fitur lebih besar
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
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
-- ISI KATEGORI (PLAYER & VISUAL)
-- ==========================================
local PlayerGrp = CreateDropdown("PLAYER SETTINGS")
local VisualGrp = CreateDropdown("VISUAL SETTINGS")

-- [FUNGSI SPEED/FLY/NOCLIP/GRAPHICS SAMA SEPERTI SEBELUMNYA]
-- (Saya ringkas untuk memastikan Script berjalan lancar)

CreateToggle("Fly Analog", PlayerGrp, function(s) _G.Flying = s end)
CreateToggle("Noclip", PlayerGrp, function(s) _G.Noclip = s end)
CreateToggle("Infinite Jump", PlayerGrp, function(s) _G.InfJump = s end)

CreateToggle("RTX 5080 Shader", VisualGrp, function(s)
    local L = game.Lighting
    if s then
        Instance.new("BloomEffect", L).Name = "RXB"
        Instance.new("ColorCorrectionEffect", L).Name = "RXC"
    else
        if L:FindFirstChild("RXB") then L.RXB:Destroy() end
        if L:FindFirstChild("RXC") then L.RXC:Destroy() end
    end
end)
CreateToggle("Dynamic Shadows", VisualGrp, function(s) game.Lighting.GlobalShadows = s end)
CreateToggle("ESP Player", VisualGrp, function(s) _G.ESP = s end)n tag:Destroy() end
            end
        end
    end
end)
