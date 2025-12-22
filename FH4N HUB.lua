-- [[ FH4N HUB - SUPREME OMNI V3 (FINAL FLY UPDATE) ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FH4N HUB - OMNI FINAL", "Midnight")

-- Services
local Player = game.Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Mouse = Player:GetMouse()

-- ================= CUSTOM FLOATING LOGO & CONTROLS =================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FH4N_FloatingControl"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 70, 0, 70)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local LogoLabel = Instance.new("TextLabel", MainFrame)
LogoLabel.Size = UDim2.new(1, 0, 1, 0)
LogoLabel.Text = "FN"
LogoLabel.TextColor3 = Color3.new(1, 1, 1); LogoLabel.TextSize = 25; LogoLabel.Font = Enum.Font.SourceSansBold; LogoLabel.BackgroundTransparency = 1

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 25, 0, 25); MinBtn.Position = UDim2.new(1, 5, 0, 0); MinBtn.Text = "—"
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25); CloseBtn.Position = UDim2.new(1, 5, 0, 30); CloseBtn.Text = "×"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

-- UI Toggle & Input Block Logic
local MenuOpen = true
MinBtn.MouseButton1Click:Connect(function()
    MenuOpen = not MenuOpen
    Library:ToggleUI()
    local mainGui = CoreGui:FindFirstChild("FH4N HUB - OMNI FINAL")
    if mainGui then mainGui.Enabled = MenuOpen end
end)

CloseBtn.MouseButton1Click:Connect(function() 
    ScreenGui:Destroy() 
    if CoreGui:FindFirstChild("FH4N HUB - OMNI FINAL") then CoreGui:FindFirstChild("FH4N HUB - OMNI FINAL"):Destroy() end
end)

-- ================= TAB 1: PLAYER =================
local PlayerTab = Window:NewTab("Player")
local PSection = PlayerTab:NewSection("Advanced Movement")

-- Slider Sensitivitas Diperhalus
PSection:NewSlider("Walkspeed", "Kecepatan", 300, 16, function(s)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = s
    end
end)

PSection:NewSlider("Jump Power", "Lompatan", 500, 50, function(s)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.JumpPower = s
        Player.Character.Humanoid.UseJumpPower = true
    end
end)

-- FLY 3D: KE ATAS/BAWAH SESUAI KAMERA
PSection:NewToggle("Fly Analog 3D", "Terbang (Ikuti Arah Kamera)", function(state)
    _G.Flying = state
    local char = Player.Character
    if state then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelo"
        bv.Parent = char.PrimaryPart
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.Parent = char.PrimaryPart
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.D = 10
        bg.P = 1000
        
        spawn(function()
            while _G.Flying and char and char:FindFirstChild("Humanoid") do
                -- Mengikuti arah pandang kamera (Bisa ke atas/bawah)
                bg.CFrame = workspace.CurrentCamera.CFrame
                local moveDir = char.Humanoid.MoveDirection
                
                if moveDir.Magnitude > 0 then
                    -- Terbang ke arah kamera menghadap jika analog ditekan
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                else
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    end
end)

PSection:NewToggle("Noclip", "Tembus Tembok", function(state)
    _G.Noclip = state
    RunService.Stepped:Connect(function()
        if _G.Noclip and Player.Character then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- ================= TAB 2: VISUAL & RTX =================
local VisualTab = Window:NewTab("Visual & RTX")
local VSection = VisualTab:NewSection("Graphics")

VSection:NewButton("RTX 5080 MODE", "Realistik", function()
    Lighting.Brightness = 2.5
    Lighting.GlobalShadows = true
    local bloom = Instance.new("BloomEffect", Lighting); bloom.Intensity = 0.5
    local atmo = Instance.new("Atmosphere", Lighting); atmo.Density = 0.3
end)

VSection:NewToggle("ESP Name", "Nama Player", function(state)
    _G.Esp = state
    while _G.Esp do
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                if not v.Character.Head:FindFirstChild("Tag") then
                    local g = Instance.new("BillboardGui", v.Character.Head); g.Name="Tag"; g.AlwaysOnTop=true; g.Size=UDim2.new(0,200,0,50)
                    local l = Instance.new("TextLabel", g); l.Text=v.Name; l.Size=UDim2.new(1,0,1,0); l.TextColor3=Color3.new(1,1,1); l.BackgroundTransparency=1
                end
            end
        end
        task.wait(1)
    end
end)

-- ================= TAB 3: WORLD & MISC =================
local MiscTab = Window:NewTab("World & Misc")
local MSection = MiscTab:NewSection("Extra")

MSection:NewButton("Infinite Zoom", "Zoom Jauh", function() 
    Player.CameraMaxZoomDistance = 1000000 
end)

MSection:NewSlider("Gravity", "Atur Gravitasi", 1000, 0, function(v) 
    game.Workspace.Gravity = v 
end)

MSection:NewButton("FPS Booster", "Anti Lag", function()
    for _, v in pairs(game:GetDescendants()) do if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end end
end)

-- ================= SETTINGS =================
local Sett = Window:NewTab("Settings")
Sett:NewSection("Config"):NewKeybind("Toggle UI", "Standard", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)
