-- [[ FH4N HUB - SUPREME OMNI V6 (WEATHER & WORLD UPDATE) ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FH4N HUB - OMNI FINAL", "Midnight")

-- Services
local Player = game.Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Mouse = Player:GetMouse()

-- ================= FITUR DRAGGABLE PANEL (GESER PANEL UTAMA) =================
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

task.spawn(function()
    local MainUI = CoreGui:WaitForChild("FH4N HUB - OMNI FINAL"):WaitForChild("Main")
    MakeDraggable(MainUI)
end)

-- ================= CUSTOM FLOATING LOGO FN (DRAGGABLE) =================
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
LogoLabel.Text = "FN"; LogoLabel.TextColor3 = Color3.new(1, 1, 1); LogoLabel.TextSize = 25; LogoLabel.Font = Enum.Font.SourceSansBold; LogoLabel.BackgroundTransparency = 1

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 25, 0, 25); MinBtn.Position = UDim2.new(1, 5, 0, 0); MinBtn.Text = "—"
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 25, 0, 25); CloseBtn.Position = UDim2.new(1, 5, 0, 30); CloseBtn.Text = "×"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

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
local PSection = PlayerTab:NewSection("Advanced Controls")

PSection:NewSlider("Walkspeed", "Speed", 500, 16, function(s)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed = s end
end)

PSection:NewSlider("Jump Power", "Jump", 1000, 50, function(s)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.JumpPower = s; Player.Character.Humanoid.UseJumpPower = true end
end)

PSection:NewToggle("Fly 3D (Analog)", "Terbang Ikuti Kamera", function(state)
    _G.Flying = state
    local char = Player.Character
    if state then
        local bv = Instance.new("BodyVelocity", char.PrimaryPart)
        bv.Name = "FlyV"; bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local bg = Instance.new("BodyGyro", char.PrimaryPart)
        bg.Name = "FlyG"; bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.D = 10; bg.P = 1000
        spawn(function()
            while _G.Flying and char and char:FindFirstChild("Humanoid") do
                bg.CFrame = workspace.CurrentCamera.CFrame
                bv.Velocity = (char.Humanoid.MoveDirection.Magnitude > 0) and (workspace.CurrentCamera.CFrame.LookVector * 100) or Vector3.new(0, 0.1, 0)
                task.wait()
            end
            if bv then bv:Destroy() end if bg then bg:Destroy() end
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

-- ================= TAB 2: VISUAL & RTX =================
local VisualTab = Window:NewTab("Visual & RTX")
local VSection = VisualTab:NewSection("Graphics Enhancer")

VSection:NewButton("RTX 5080 MODE", "Realistik", function()
    Lighting.Brightness = 2.5
    Instance.new("BloomEffect", Lighting).Intensity = 0.5
    Instance.new("Atmosphere", Lighting).Density = 0.3
end)

VSection:NewToggle("ESP Name", "Nama Pemain", function(state)
    _G.Esp = state
    while _G.Esp do
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") and not v.Character.Head:FindFirstChild("Tag") then
                local g = Instance.new("BillboardGui", v.Character.Head); g.Name="Tag"; g.AlwaysOnTop=true; g.Size=UDim2.new(0,200,0,50)
                local l = Instance.new("TextLabel", g); l.Text=v.Name; l.Size=UDim2.new(1,0,1,0); l.TextColor3=Color3.new(1,1,1); l.BackgroundTransparency=1
            end
        end
        task.wait(2)
    end
end)

-- ================= TAB 3: WEATHER (DITAMBAHKAN KEMBALI) =================
local WeatherTab = Window:NewTab("Weather")
local WSection = WeatherTab:NewSection("World Environment")

WSection:NewSlider("Time Of Day", "Atur Jam (Siang/Malam)", 24, 0, function(s)
    Lighting.ClockTime = s
end)

WSection:NewButton("Set Noon (Siang)", "Pukul 12:00", function() Lighting.ClockTime = 12 end)
WSection:NewButton("Set Night (Malam)", "Pukul 00:00", function() Lighting.ClockTime = 0 end)

WSection:NewButton("FullBright", "Hapus Kegelapan", function()
    Lighting.Brightness = 2
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
end)

WSection:NewButton("Remove Weather (Clear)", "Hapus Hujan/Kabut", function()
    for _, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("Atmosphere") or v:IsA("Clouds") then v:Destroy() end
    end
    Lighting.FogEnd = 100000
end)

WSection:NewToggle("Rainbow Sky", "Langit Berwarna", function(state)
    _G.Rainbow = state
    spawn(function()
        while _G.Rainbow do
            Lighting.Ambient = Color3.new(math.random(), math.random(), math.random())
            task.wait(0.5)
        end
    end)
end)

-- ================= TAB 4: MISC =================
local MiscTab = Window:NewTab("Misc")
local MSection = MiscTab:NewSection("Utilities")

MSection:NewButton("Click TP (Ctrl+Click)", "Teleport", function()
    Mouse.Button1Down:Connect(function() if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then Player.Character:MoveTo(Mouse.Hit.p) end end)
end)

MSection:NewSlider("Gravity", "Gravitasi", 1000, 0, function(v) game.Workspace.Gravity = v end)

MSection:NewButton("Infinite Zoom", "No Limit", function() Player.CameraMaxZoomDistance = 1000000 end)

MSection:NewToggle("Auto Clicker", "Fast Klik", function(state)
    _G.Clicks = state
    spawn(function() while _G.Clicks do game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0)); task.wait(0.01) end end)
end)

-- ================= SETTINGS =================
local Sett = Window:NewTab("Settings")
Sett:NewSection("Config"):NewKeybind("Toggle UI", "RightCtrl", Enum.KeyCode.RightControl, function() Library:ToggleUI() end)
