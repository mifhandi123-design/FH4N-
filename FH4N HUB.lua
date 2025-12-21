-- FH4N HUB FINAL VERSION (FIXED EXECUTION & DRAG)
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer

-- Hapus UI lama jika ada
if game.CoreGui:FindFirstChild("FH4N_ULTRA") then game.CoreGui.FH4N_ULTRA:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FH4N_ULTRA"
ScreenGui.ResetOnSpawn = false

-- --- FUNGSI DRAG (KHUSUS MOBILE) ---
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

-- --- MAIN PANEL (MEGA SIZE) ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 550)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
MakeDraggable(MainFrame)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "FH4N HUB | MEGA PANEL"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 25
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -20, 1, -80)
Container.Position = UDim2.new(0, 10, 0, 75)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 1200)
Container.ScrollBarThickness = 4
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 12)

-- --- TOMBOL FN (FIXED DRAG) ---
local MinimizeBtn = Instance.new("TextButton", ScreenGui)
MinimizeBtn.Size = UDim2.new(0, 90, 0, 90)
MinimizeBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
MinimizeBtn.Text = "FN"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 30
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0)
MakeDraggable(MinimizeBtn)

MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- --- HELPER: DROPDOWN & TOGGLE ---
local function CreateDropdown(name)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame)

    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
    Button.Text = "   [+]  " .. name
    Button.TextColor3 = Color3.fromRGB(0, 0, 0)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 20
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Button)

    local Content = Instance.new("Frame", Frame)
    Content.Position = UDim2.new(0, 0, 0, 60)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.BackgroundTransparency = 1
    local CL = Instance.new("UIListLayout", Content)
    CL.Padding = UDim.new(0, 10)
    CL.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local isOpen = false
    Button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Frame.Size = isOpen and UDim2.new(1, 0, 0, CL.AbsoluteContentSize.Y + 80) or UDim2.new(1, 0, 0, 50)
        Button.Text = isOpen and "   [-]  " .. name or "   [+]  " .. name
    end)
    return Content
end

local function CreateToggle(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 45)
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
-- KATEGORI 1: PLAYER
-- ==========================================
local PlayerGrp = CreateDropdown("PLAYER SETTINGS")

local SpeedInput = Instance.new("TextBox", PlayerGrp)
SpeedInput.Size = UDim2.new(0.95, 0, 0, 45)
SpeedInput.PlaceholderText = "Input Speed & Enter"
SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SpeedInput)

local CurSpeed = 16
SpeedInput.FocusLost:Connect(function(e) if e then CurSpeed = tonumber(SpeedInput.Text) or 16; if LPlayer.Character then LPlayer.Character.Humanoid.WalkSpeed = CurSpeed end end end)

_G.Flying = false
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
                    bv.Velocity = (cam.CFrame.LookVector * hum.MoveDirection.Magnitude) * CurSpeed
                else bv.Velocity = Vector3.new(0,0.1,0) end
                bg.CFrame = cam.CFrame
                task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)

CreateToggle("Noclip", PlayerGrp, function(s) _G.Noclip = s end)
CreateToggle("Infinite Jump", PlayerGrp, function(s) _G.InfJump = s end)

-- ==========================================
-- KATEGORI 2: VISUAL
-- ==========================================
local VisualGrp = CreateDropdown("VISUAL SETTINGS")

CreateToggle("RTX 5080 Shader", VisualGrp, function(s)
    if s then
        local b = Instance.new("BloomEffect", Lighting); b.Name = "FN_B"; b.Intensity = 0.5
        local c = Instance.new("ColorCorrectionEffect", Lighting); c.Name = "FN_C"; c.Contrast = 0.3
    else
        if Lighting:FindFirstChild("FN_B") then Lighting.FN_B:Destroy() end
        if Lighting:FindFirstChild("FN_C") then Lighting.FN_C:Destroy() end
    end
end)

CreateToggle("PC Port (Extreme)", VisualGrp, function(s)
    if s then
        local a = Instance.new("Atmosphere", Lighting); a.Name = "FN_A"; a.Density = 0.35
        Lighting.Brightness = 3
    else
        if Lighting:FindFirstChild("FN_A") then Lighting.FN_A:Destroy() end
        Lighting.Brightness = 1
    end
end)

CreateToggle("Dynamic Shadows", VisualGrp, function(s) Lighting.GlobalShadows = s end)

_G.ESP = false
CreateToggle("ESP Player Name", VisualGrp, function(s) _G.ESP = s end)

-- --- LOOPING SYSTEM ---
RunService.Stepped:Connect(function()
    if _G.Noclip and LPlayer.Character then
        for _, v in pairs(LPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if _G.InfJump and LPlayer.Character then LPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local tag = p.Character.Head:FindFirstChild("FN_ESP")
                if _G.ESP and not tag then
                    local bb = Instance.new("BillboardGui", p.Character.Head)
                    bb.Name = "FN_ESP"; bb.Size = UDim2.new(0, 150, 0, 50); bb.AlwaysOnTop = true
                    local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Text = p.DisplayName; lbl.Font = "SourceSansBold"; lbl.TextSize = 14
                elseif not _G.ESP and tag then tag:Destroy() end
            end
        end
    end
end)
