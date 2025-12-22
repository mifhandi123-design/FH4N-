-- [[ FH4N HUB - OMNI EDITION (ULTIMATE FINAL) ]] --
-- Nama Script: FH4N HUB
-- Status: Update (Added Gravity & Server Utilities)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FH4N HUB - OMNI FINAL", "Midnight")

-- Variables & Services
local Player = game.Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- ================= TAB 1: PLAYER =================
local PlayerTab = Window:NewTab("Player")
local PSection = PlayerTab:NewSection("Pergerakan")

PSection:NewSlider("Walkspeed", "Kecepatan lari", 500, 16, function(s)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = s
    end
end)

PSection:NewSlider("Jump Power", "Tinggi lompatan", 1000, 50, function(s)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.JumpPower = s
        Player.Character.Humanoid.UseJumpPower = true
    end
end)

PSection:NewToggle("Fly (Analog)", "Terbang mengikuti arah gerak", function(state)
    if state then
        local bv = Instance.new("BodyVelocity", Player.Character.PrimaryPart)
        bv.Name = "FH4N_Fly"
        bv.MaxForce = Vector3.new(1, 1, 1) * 10^6
        bv.Velocity = Vector3.new(0, 0, 0)
        spawn(function()
            while state and bv.Parent do
                bv.Velocity = Player.Character.Humanoid.MoveDirection * 75
                task.wait()
            end
        end)
    else
        if Player.Character.PrimaryPart:FindFirstChild("FH4N_Fly") then
            Player.Character.PrimaryPart.FH4N_Fly:Destroy()
        end
    end
end)

PSection:NewToggle("Noclip", "Menembus objek/tembok", function(state)
    _G.NoClip = state
    RunService.Stepped:Connect(function()
        if _G.NoClip and Player.Character then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- ================= TAB 2: VISUAL & RTX =================
local VisualTab = Window:NewTab("Visual & RTX")
local VSection = VisualTab:NewSection("Graphics RTX 5080")

VSection:NewButton("RTX 5080 MODE", "Aktifkan Pencahayaan Super Realistis", function()
    Lighting.Brightness = 2.5
    Lighting.GlobalShadows = true
    Lighting.ShadowSoftness = 0
    local bloom = Instance.new("BloomEffect", Lighting)
    bloom.Intensity = 0.4
    local color = Instance.new("ColorCorrectionEffect", Lighting)
    color.Contrast = 0.25
    color.Saturation = 0.35
    local atmo = Instance.new("Atmosphere", Lighting)
    atmo.Density = 0.35
end)

VSection:NewToggle("ESP Name", "Lihat nama pemain di balik tembok", function(state)
    _G.EspName = state
    spawn(function()
        while _G.EspName do
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                    if not v.Character.Head:FindFirstChild("FH4N_NameTag") then
                        local bGui = Instance.new("BillboardGui", v.Character.Head)
                        bGui.Name = "FH4N_NameTag"
                        bGui.Size = UDim2.new(0, 200, 0, 50)
                        bGui.AlwaysOnTop = true
                        bGui.ExtentsOffset = Vector3.new(0, 3, 0)
                        local lbl = Instance.new("TextLabel", bGui)
                        lbl.BackgroundTransparency = 1
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.Text = v.Name
                        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                        lbl.TextSize = 14
                        lbl.Font = Enum.Font.SourceSansBold
                    end
                end
            end
            task.wait(2)
        end
        if not _G.EspName then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character.Head:FindFirstChild("FH4N_NameTag") then
                    v.Character.Head.FH4N_NameTag:Destroy()
                end
            end
        end
    end)
end)

-- ================= TAB 3: SERVER & WORLD (IDE BARU) =================
local WorldTab = Window:NewTab("Server & World")
local WSection = WorldTab:NewSection("World Manipulation")

WSection:NewSlider("Gravity", "Atur gravitasi dunia (Standar: 196)", 1000, 0, function(v)
    game.Workspace.Gravity = v
end)

WSection:NewButton("Server Hop", "Pindah ke server lain secara acak", function()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualIndex = 0
    local function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        if Site.nextPageCursor and Site.nextPageCursor ~= "" then
            foundAnything = Site.nextPageCursor
        end
        for i,v in pairs(Site.data) do
            if v.playing < v.maxPlayers then
                TeleportService:TeleportToPlaceInstance(PlaceID, v.id, Player)
            end
        end
    end
    TPReturner()
end)

-- ================= TAB 4: MISC =================
local MiscTab = Window:NewTab("Misc")
local MSection = MiscTab:NewSection("Utilitas Tambahan")

MSection:NewButton("Enable Infinite Zoom", "Zoom kamera tanpa batas", function()
    Player.CameraMaxZoomDistance = 1000000
    Player.CameraMinZoomDistance = 0
end)

MSection:NewButton("Anti-AFK", "Cegah auto-kick", function()
    local vu = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

MSection:NewButton("Click TP (Ctrl + Click)", "Teleport instan", function()
    Mouse.Button1Down:Connect(function()
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            Player.Character:MoveTo(Mouse.Hit.p)
        end
    end)
end)

-- ================= TAB 5: SETTINGS =================
local SettingsTab = Window:NewTab("Settings")
SettingsTab:NewSection("Menu Config"):NewKeybind("Hide/Show Menu", "Tombol tutup menu", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

SettingsTab:NewSection("Control"):NewButton("Destroy HUB", "Hapus script", function()
    game:GetService("CoreGui")["FH4N HUB - OMNI FINAL"]:Destroy()
end)  if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
end)

-- --- MINIMIZE BUTTON ---
local m = Instance.new("TextButton", sg); m.Size = UDim2.new(0, 45, 0, 45); m.Position = UDim2.new(0, 10, 0.4, 0); m.Text = "FN"; m.BackgroundColor3 = Color3.fromRGB(0, 120, 255); m.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", m).CornerRadius = UDim.new(1,0)
MakeDraggable(m); m.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)AC = v
    task.spawn(function()
        while _G.AC do
            local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            task.wait(0.1)
        end
    end)
end)
AddBtn(pgM, "Rejoin Game", function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end)

-- --- CORE SYSTEMS ---
UIS.JumpRequest:Connect(function() if _G.IJ then Player.Character.Humanoid:ChangeState(3) end end)
RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
    if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
end)

-- --- MINIMIZE BUTTON ---
local m = Instance.new("TextButton", sg); m.Size = UDim2.new(0, 45, 0, 45); m.Position = UDim2.new(0, 10, 0.4, 0); m.Text = "FN"; m.BackgroundColor3 = Color3.fromRGB(0, 120, 255); m.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", m).CornerRadius = UDim.new(1,0)
MakeDraggable(m); m.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)alkSpeed = _G.WS end
        if _G.Nc then for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
    if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
end)

-- --- MINIMIZE ---
local m = Instance.new("TextButton", sg); m.Size = UDim2.new(0, 45, 0, 45); m.Position = UDim2.new(0, 10, 0.4, 0); m.Text = "FN"; m.BackgroundColor3 = Color3.fromRGB(0, 120, 255); m.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", m).CornerRadius = UDim.new(1,0)
MakeDraggable(m); m.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
