-- FH4N HUB - BIG PANEL VERSION
if game.CoreGui:FindFirstChild("FH4N_FINAL") then game.CoreGui.FH4N_FINAL:Destroy() end

local UIS = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local Container = Instance.new("ScrollingFrame", MainFrame)
local MinimizeBtn = Instance.new("TextButton", ScreenGui)

-- --- FUNGSI DRAG (MOBILE FRIENDLY) ---
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
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
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- --- UI SETUP (PANEL DIPERBESAR) ---
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 450) -- Ukuran diperbesar (sebelumnya 260x380)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
MakeDraggable(MainFrame)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 50) -- Header lebih tinggi
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "FH4N HUB | BIG PANEL"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20 -- Teks lebih besar
Title.BackgroundTransparency = 1

Container.Size = UDim2.new(1, -20, 1, -70) -- Area scroll diperluas
Container.Position = UDim2.new(0, 10, 0, 60)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 1100)
Container.ScrollBarThickness = 4
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 10)

-- --- TOMBOL FN (BISA DIGESER) ---
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 70, 0, 70)
MinimizeBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
MinimizeBtn.Text = "FN"
MinimizeBtn.TextColor3 = Color3.fromRGB(0,0,0)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 24
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0)
MakeDraggable(MinimizeBtn)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- --- FUNGSI DROPDOWN ---
local function CreateDropdown(name)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(1, 0, 0, 45) -- Lebih tinggi
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
    Content.Position = UDim2.new(0, 0, 0, 55)
    Content.Size = UDim2.new(1, 0, 0, 0)
    Content.BackgroundTransparency = 1
    local CL = Instance.new("UIListLayout", Content)
    CL.Padding = UDim.new(0, 8)
    CL.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local isOpen = false
    Button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Frame.Size = isOpen and UDim2.new(1, 0, 0, CL.AbsoluteContentSize.Y + 70) or UDim2.new(1, 0, 0, 45)
        Button.Text = isOpen and "   [-] " .. name or "   [+] " .. name
    end)
    return Content
end

local function CreateToggle(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 40) -- Tombol lebih lebar
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
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
-- KELOMPOK: PLAYER
-- ==========================================
local PlayerGrp = CreateDropdown("PLAYER")

local SpeedInput = Instance.new("TextBox", PlayerGrp)
SpeedInput.Size = UDim2.new(0.95, 0, 0, 40)
SpeedInput.PlaceholderText = "Set WalkSpeed (Enter)"
SpeedInput.BackgroundColor3 = Color3.fromRGB(45,45,45)
SpeedInput.TextColor3 = Color3.fromRGB(255,255,255)
SpeedInput.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", SpeedInput)

local CurSpeed = 50
SpeedInput.FocusLost:Connect(function(e) if e then CurSpeed = tonumber(SpeedInput.Text) or 16; if game.Players.LocalPlayer.Character then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = CurSpeed end end end)

CreateToggle("Fly Analog", PlayerGrp, function(state)
    _G.Flying = state
    local char = game.Players.LocalPlayer.Character
    if _G.Flying and char then
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while _G.Flying do
                local cam = workspace.CurrentCamera
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

CreateToggle("Noclip (Tembus)", PlayerGrp, function(s) _G.Noclip = s end)
CreateToggle("Infinite Jump", PlayerGrp, function(s) _G.InfJump = s end)

local TPInput = Instance.new("TextBox", PlayerGrp)
TPInput.Size = UDim2.new(0.95, 0, 0, 40)
TPInput.PlaceholderText = "Teleport to Player (Enter)"
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

-- ==========================================
-- KELOMPOK: VISUAL
-- ==========================================
local VisualGrp = CreateDropdown("VISUAL")

CreateToggle("RTX 5080 Effects", VisualGrp, function(state)
    local L = game.Lighting
    if state then
        local b = Instance.new("BloomEffect", L); b.Name = "RXB"
        local c = Instance.new("ColorCorrectionEffect", L); c.Name = "RXC"; c.Contrast = 0.25
    else
        if L:FindFirstChild("RXB") then L.RXB:Destroy() end
        if L:FindFirstChild("RXC") then L.RXC:Destroy() end
    end
end)

CreateToggle("PC Port (Extreme Shader)", VisualGrp, function(state)
    local L = game.Lighting
    if state then
        local a = Instance.new("Atmosphere", L); a.Name = "PCA"; a.Density = 0.35
        L.Brightness = 2.5
    else
        if L:FindFirstChild("PCA") then L.PCA:Destroy() end
        L.Brightness = 1
    end
end)

CreateToggle("Dynamic Shadows", VisualGrp, function(s) game.Lighting.GlobalShadows = s end)
CreateToggle("ESP Player Name", VisualGrp, function(s) _G.ESP = s end)

-- --- CORE LOOPS ---
game:GetService("RunService").Stepped:Connect(function()
    if _G.Noclip and game.Players.LocalPlayer.Character then
        for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump then game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping") end
end)

task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local tag = p.Character.Head:FindFirstChild("FN_ESP")
                if _G.ESP and not tag then
                    local bb = Instance.new("BillboardGui", p.Character.Head)
                    bb.Name = "FN_ESP"; bb.Size = UDim2.new(0, 150, 0, 50); bb.AlwaysOnTop = true
                    local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Text = p.DisplayName or p.Name; lbl.Font = Enum.Font.SourceSansBold; lbl.TextSize = 14
                elseif not _G.ESP and tag then tag:Destroy() end
            end
        end
    end
end)
