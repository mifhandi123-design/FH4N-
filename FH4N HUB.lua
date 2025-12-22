-- [[ FH4N HUB - SUPREME OMNI EDITION ]] --
-- Features: Logo FN (Draggable), Minimize (—), Close (×), RTX 5080, Full Player Mods, Misc.

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FH4N HUB - OMNI FINAL", "Midnight")

-- Services
local Player = game.Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ================= CUSTOM FLOATING LOGO FN (DRAGGABLE) =================
-- Ini agar logo bisa dipindah dan tidak ikut analog
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FH4N_FloatingControl"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 70, 0, 70)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa dipindah sesuka hati

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local LogoLabel = Instance.new("TextLabel", MainFrame)
LogoLabel.Size = UDim2.new(1, 0, 1, 0)
LogoLabel.Text = "FN"
LogoLabel.TextColor3 = Color3.new(1, 1, 1)
LogoLabel.TextSize = 28
LogoLabel.Font = Enum.Font.SourceSansBold
LogoLabel.BackgroundTransparency = 1

-- Button Minimize (—)
local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, 5, 0, 0)
MinBtn.Text = "—"
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

-- Button Close (×)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, 5, 0, 30)
CloseBtn.Text = "×"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

-- Logic Buttons
MinBtn.MouseButton1Click:Connect(function() Library:ToggleUI() end)
CloseBtn.MouseButton1Click:Connect(function() 
    ScreenGui:Destroy() 
    local menu = CoreGui:FindFirstChild("FH4N HUB - OMNI FINAL")
    if menu then menu:Destroy() end
end)

-- ================= TAB 1: PLAYER (ADVANCED) =================
local PlayerTab = Window:NewTab("Player")
local PSection = PlayerTab:NewSection("Player Mods")

PSection:NewSlider("Walkspeed", "Kecepatan", 500, 16, function(s) Player.Character.Humanoid.WalkSpeed = s end)
PSection:NewSlider("Jump Power", "Lompatan", 1000, 50, function(s) Player.Character.Humanoid.JumpPower = s; Player.Character.Humanoid.UseJumpPower = true end)
PSection:NewSlider("Hip Height", "Tinggi Melayang", 50, 0, function(v) Player.Character.Humanoid.HipHeight = v end)

PSection:NewToggle("Fly (Analog)", "Terbang", function(state)
    if state then
        local bv = Instance.new("BodyVelocity", Player.Character.PrimaryPart)
        bv.Name = "FH4N_Fly"
        bv.MaxForce = Vector3.new(1, 1, 1) * 10^6
        spawn(function()
            while state and bv.Parent do
                bv.Velocity = Player.Character.Humanoid.MoveDirection * 80
                task.wait()
            end
        end)
    else
        if Player.Character.PrimaryPart:FindFirstChild("FH4N_Fly") then Player.Character.PrimaryPart.FH4N_Fly:Destroy() end
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

PSection:NewToggle("SpinBot", "Berputar", function(state)
    _G.SpinBot = state
    spawn(function()
        while _G.SpinBot do
            Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
            task.wait()
        end
    end)
end)

PSection:NewToggle("Anti-Ragdoll", "Anti Jatuh", function(state) Player.Character.Humanoid.PlatformStand = state end)
PSection:NewButton("Instant Respawn", "Reset Karakter", function() Player.Character.Humanoid.Health = 0 end)

-- ================= TAB 2: VISUAL & RTX =================
local VisualTab = Window:NewTab("Visual & RTX")
local VSection = VisualTab:NewSection("Graphics & ESP")

VSection:NewButton("RTX 5080 MODE", "Realistik", function()
    Lighting.Brightness = 2.5
    Lighting.GlobalShadows = true
    local bloom = Instance.new("BloomEffect", Lighting); bloom.Intensity = 0.5
    local atmo = Instance.new("Atmosphere", Lighting); atmo.Density = 0.3
end)

VSection:NewButton("No Fog", "Hapus Kabut", function() Lighting.FogEnd = 100000 end)
VSection:NewSlider("FOV", "Pandangan Kamera", 120, 70, function(v) game.Workspace.CurrentCamera.FieldOfView = v end)

VSection:NewToggle("ESP Name", "Nama Player", function(state)
    _G.EspName = state
    spawn(function()
        while _G.EspName do
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                    if not v.Character.Head:FindFirstChild("Tag") then
                        local g = Instance.new("BillboardGui", v.Character.Head); g.Name="Tag"; g.AlwaysOnTop=true; g.Size=UDim2.new(0,200,0,50)
                        local l = Instance.new("TextLabel", g); l.Text=v.Name; l.Size=UDim2.new(1,0,1,0); l.TextColor3=Color3.new(1,1,1); l.BackgroundTransparency=1; l.Font = Enum.Font.SourceSansBold
                    end
                end
            end
            task.wait(2)
        end
    end)
end)

-- ================= TAB 3: MISC & WORLD =================
local MiscTab = Window:NewTab("Misc & World")
local MSection = MiscTab:NewSection("Extra Features")

MSection:NewButton("Infinite Zoom", "Zoom Tanpa Batas", function() Player.CameraMaxZoomDistance = 1000000 end)
MSection:NewToggle("Auto Clicker", "Klik Otomatis", function(state)
    _G.AutoClick = state
    spawn(function() while _G.AutoClick do game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0)); task.wait(0.01) end end)
end)

MSection:NewSlider("Gravity", "Atur Gravitasi", 1000, 0, function(v) game.Workspace.Gravity = v end)
MSection:NewButton("FPS Booster", "Anti Lag", function()
    for _, v in pairs(game:GetDescendants()) do if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end end
end)

MSection:NewButton("Click TP (Ctrl+Click)", "Teleport", function()
    Mouse.Button1Down:Connect(function() if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then Player.Character:MoveTo(Mouse.Hit.p) end end)
end)

-- ================= SETTINGS =================
local SettingsTab = Window:NewTab("Settings")
SettingsTab:NewSection("Config"):NewKeybind("Toggle Key", "Sembunyikan Menu", Enum.KeyCode.RightControl, function() Library:ToggleUI() end)
