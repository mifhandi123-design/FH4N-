-- [[ FH4N HUB - SUPREME OMNI V8 (ULTIMATE STABLE) ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FH4N HUB - OMNI FINAL", "Midnight")

-- Services
local Player = game.Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Mouse = Player:GetMouse()

-- Variables for Locking (Mencegah speed berubah sendiri)
local TargetWalkspeed = 16
local TargetJumpPower = 50
local LockActive = true

-- ================= SISTEM DRAGGABLE PANEL UTAMA =================
-- Fungsi paksa agar panel Kavo bisa digeser di layar
task.spawn(function()
    local MainUI = CoreGui:WaitForChild("FH4N HUB - OMNI FINAL"):WaitForChild("Main")
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    MainUI.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainUI.Position
        end
    end)

    MainUI.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end)

-- ================= LOGO FN & CONTROL BUTTONS =================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 70, 0, 70)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local LogoLabel = Instance.new("TextLabel", MainFrame)
LogoLabel.Size = UDim2.new(1, 0, 1, 0); LogoLabel.Text = "FN"; LogoLabel.TextColor3 = Color3.new(1,1,1); LogoLabel.BackgroundTransparency = 1; LogoLabel.TextSize = 25; LogoLabel.Font = Enum.Font.SourceSansBold

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 25, 0, 25); MinBtn.Position = UDim2.new(1, 5, 0, 0); MinBtn.Text = "—"
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); MinBtn.TextColor3 = Color3.new(1,1,1)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25); CloseBtn.Position = UDim2.new(1, 5, 0, 30); CloseBtn.Text = "×"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); CloseBtn.TextColor3 = Color3.new(1,1,1)

-- Toggle Menu (Input Blocking agar slider tidak tergeser saat tertutup)
local MenuVisible = true
MinBtn.MouseButton1Click:Connect(function()
    MenuVisible = not MenuVisible
    Library:ToggleUI()
    local mainGui = CoreGui:FindFirstChild("FH4N HUB - OMNI FINAL")
    if mainGui then mainGui.Enabled = MenuVisible end
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy(); CoreGui:FindFirstChild("FH4N HUB - OMNI FINAL"):Destroy() end)

-- ================= LOOP UNTUK LOCK VALUE (FIXED) =================
RunService.RenderStepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if LockActive then
            Player.Character.Humanoid.WalkSpeed = TargetWalkspeed
            Player.Character.Humanoid.JumpPower = TargetJumpPower
            Player.Character.Humanoid.UseJumpPower = true
        end
    end
end)

-- ================= TAB 1: PLAYER =================
local PlayerTab = Window:NewTab("Player")
local PSection = PlayerTab:NewSection("Advanced Player")

PSection:NewSlider("Walkspeed", "Kecepatan", 500, 16, function(s) TargetWalkspeed = s end)
PSection:NewSlider("Jump Power", "Lompatan", 1000, 50, function(s) TargetJumpPower = s end)

PSection:NewToggle("Fly 3D (Analog)", "Terbang Ikuti Kamera", function(state)
    _G.Flying = state
    local char = Player.Character
    if state then
        local bv = Instance.new("BodyVelocity", char.PrimaryPart)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local bg = Instance.new("BodyGyro", char.PrimaryPart)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.D = 10; bg.P = 1000
        spawn(function()
            while _G.Flying and char and char:FindFirstChild("Humanoid") do
                bg.CFrame = workspace.CurrentCamera.CFrame
                bv.Velocity = (char.Humanoid.MoveDirection.Magnitude > 0) and (workspace.CurrentCamera.CFrame.LookVector * 100) or Vector3.new(0, 0.1, 0)
                task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)

PSection:NewToggle("Noclip", "Tembus Tembok", function(state)
    _G.NoClip = state
    RunService.Stepped:Connect(function()
        if _G.NoClip and Player.Character then
            for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end)
end)

PSection:NewButton("Instant Respawn", "Reset Karakter", function() Player.Character.Humanoid.Health = 0 end)

-- ================= TAB 2: TELEPORT =================
local TPTab = Window:NewTab("Teleport")
local TSection = TPTab:NewSection("Teleport Utilities")

TSection:NewButton("Click TP (Ctrl + Click)", "Teleport ke arah Mouse", function()
    Mouse.Button1Down:Connect(function()
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            Player.Character:MoveTo(Mouse.Hit.p)
        end
    end)
end)

TSection:NewTextBox("TP to Player", "Masukkan Nama Player", function(txt)
    local target = game.Players:FindFirstChild(txt)
    if target and target.Character then
        Player.Character:MoveTo(target.Character.HumanoidRootPart.Position)
    end
end)

-- ================= TAB 3: VISUAL & WEATHER =================
local VisualTab = Window:NewTab("Visual & Weather")
local VSection = VisualTab:NewSection("Graphics")

VSection:NewButton("RTX 5080 MODE", "Realistik", function()
    Lighting.Brightness = 2.5
    Instance.new("BloomEffect", Lighting).Intensity = 0.5
    Instance.new("Atmosphere", Lighting).Density = 0.3
end)

VSection:NewSlider("Time of Day", "Atur Jam", 24, 0, function(s) Lighting.ClockTime = s end)
VSection:NewButton("FullBright", "Terang Maksimal", function()
    Lighting.Brightness = 2; Lighting.GlobalShadows = false; Lighting.FogEnd = 100000
end)

-- ================= TAB 4: MISC =================
local MiscTab = Window:NewTab("Misc")
local MSection = MiscTab:NewSection("Utilities")

MSection:NewButton("Infinite Zoom", "Zoom Jauh", function() Player.CameraMaxZoomDistance = 1000000 end)

MSection:NewToggle("Auto Clicker", "Klik Cepat", function(state)
    _G.Clicks = state
    spawn(function() while _G.Clicks do game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0)); task.wait(0.01) end end)
end)

MSection:NewButton("FPS Booster", "Anti Lag", function()
    for _, v in pairs(game:GetDescendants()) do if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end end
end)

-- ================= SETTINGS =================
local Sett = Window:NewTab("Settings")
Sett:NewSection("Config"):NewKeybind("Toggle UI", "RightCtrl", Enum.KeyCode.RightControl, function() Library:ToggleUI() end)
