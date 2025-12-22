-- FH4N HUB | PREZZA PRESTIGE (ULTIMATE UPDATE)
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

if PlayerGui:FindFirstChild("FH4N_PRESTIGE") then PlayerGui.FH4N_PRESTIGE:Destroy() end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "FH4N_PRESTIGE"
sg.ResetOnSpawn = false

-- --- DRAG FUNCTION ---
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- --- MAIN PANEL ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 420, 0, 320)
main.Position = UDim2.new(0.5, -210, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
MakeDraggable(main)

-- --- SIDEBAR ---
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 110, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
sidebar.BorderSizePixel = 0
local sC = Instance.new("UICorner", sidebar); sC.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", sidebar)
title.Size = UDim2.new(1, 0, 0, 45); title.Text = "FH4N PRESTIGE"; title.TextColor3 = Color3.fromRGB(0, 120, 255); title.Font = "GothamBold"; title.BackgroundTransparency = 1; title.TextSize = 12

-- --- CONTAINER ---
local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -125, 1, -10); container.Position = UDim2.new(0, 118, 0, 5); container.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0,0,3,0); p.ScrollBarThickness = 2
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 7)
    return p
end

local pgPlayer = createPage("Player")
local pgVisual = createPage("Visual")
local pgWorld = createPage("World")
pgPlayer.Visible = true

-- --- COMPONENTS ---
local function AddTab(name, target, order)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, 50 + (38 * order))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamSemibold"; b.TextSize = 10
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(container:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        target.Visible = true
    end)
end

local function AddToggle(parent, txt, cb)
    local state = false
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.98, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(22, 22, 26); b.Text = txt .. ": OFF"; b.TextColor3 = Color3.new(0.6,0.6,0.6); b.Font = "Gotham"; b.TextSize = 10
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(22, 22, 26)
        b.TextColor3 = state and Color3.new(1,1,1) or Color3.new(0.6,0.6,0.6)
        b.Text = txt .. ": " .. (state and "ON" or "OFF")
        cb(state)
    end)
end

local function AddInput(parent, placeholder, cb)
    local t = Instance.new("TextBox", parent)
    t.Size = UDim2.new(0.98, 0, 0, 35); t.PlaceholderText = placeholder; t.BackgroundColor3 = Color3.fromRGB(15, 15, 18); t.TextColor3 = Color3.new(1,1,1); t.Font = "Gotham"; t.TextSize = 10
    Instance.new("UICorner", t)
    t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
end

local function AddButton(parent, txt, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.98, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(35, 35, 40); b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"; b.TextSize = 10
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(cb)
end

-- --- NAVIGATION ---
AddTab("PLAYER", pgPlayer, 0)
AddTab("VISUAL", pgVisual, 1)
AddTab("WORLD", pgWorld, 2)

-- ==========================================
-- [ PLAYER FEATURES ]
-- ==========================================
AddToggle(pgPlayer, "Fly Mobile (Camera)", function(s)
    _G.Fly = s
    if s then
        local root = Player.Character.HumanoidRootPart
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6); bv.Name = "M_Fly"
        task.spawn(function()
            while _G.Fly do 
                -- Kecepatan terbang mengikuti WalkSpeed yang diinput
                bv.Velocity = Camera.CFrame.LookVector * (_G.WS or 50) 
                task.wait() 
            end
            bv:Destroy()
        end)
    end
end)
AddToggle(pgPlayer, "Noclip", function(s) _G.Nc = s end)
AddToggle(pgPlayer, "Infinite Jump", function(s) _G.IJ = s end)
UIS.JumpRequest:Connect(function() if _G.IJ then Player.Character.Humanoid:ChangeState(3) end end)

AddInput(pgPlayer, "Set Speed / Fly Speed", function(v) _G.WS = tonumber(v) end)
AddInput(pgPlayer, "Set High Jump", function(v) Player.Character.Humanoid.JumpPower = tonumber(v); Player.Character.Humanoid.UseJumpPower = true end)
AddInput(pgPlayer, "Set Max Zoom", function(v) Player.CameraMaxZoomDistance = tonumber(v) end)
AddInput(pgPlayer, "TP to Player (Name)", function(v) 
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():find(v:lower()) then Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end
    end
end)

-- ==========================================
-- [ VISUAL FEATURES ]
-- ==========================================
AddToggle(pgVisual, "ESP + Name Tag", function(s)
    _G.ESP = s
    if not s then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character then 
                if p.Character:FindFirstChild("EH") then p.Character.EH:Destroy() end
                if p.Character.HumanoidRootPart:FindFirstChild("EN") then p.Character.HumanoidRootPart.EN:Destroy() end
            end
        end
    end
    task.spawn(function()
        while _G.ESP do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not p.Character:FindFirstChild("EH") then
                    local h = Instance.new("Highlight", p.Character); h.Name = "EH"; h.FillColor = Color3.new(1,0,0)
                    local b = Instance.new("BillboardGui", p.Character.HumanoidRootPart); b.Name = "EN"; b.Size = UDim2.new(0,80,0,20); b.AlwaysOnTop = true; b.ExtentsOffset = Vector3.new(0,3,0)
                    local t = Instance.new("TextLabel", b); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.Text = p.Name; t.TextColor3 = Color3.new(1,1,1); t.Font = "GothamBold"; t.TextSize = 9
                end
            end
            task.wait(1)
        end
    end)
end)

AddToggle(pgVisual, "Show FPS Counter", function(s)
    _G.FPS = s
    if s then
        local fL = Instance.new("TextLabel", sg); fL.Size = UDim2.new(0,70,0,25); fL.Position = UDim2.new(0,10,0,10); fL.BackgroundColor3 = Color3.new(0,0,0); fL.TextColor3 = Color3.new(0,1,0); fL.TextSize = 10; fL.Font = "GothamBold"; fL.BackgroundTransparency = 0.5
        task.spawn(function() while _G.FPS do local dt = task.wait(1) fL.Text = "FPS: " .. math.floor(1/dt) end fL:Destroy() end)
    end
end)

AddToggle(pgVisual, "Unlock FPS (999)", function(s) if setfpscap then setfpscap(s and 999 or 60) end end)
AddToggle(pgVisual, "Full Bright", function(s) _G.FB = s end)
AddToggle(pgVisual, "Freecam", function(s)
    if s then
        _G.FC = Instance.new("Part", workspace); _G.FC.Anchored = true; _G.FC.Transparency = 1; _G.FC.CFrame = Camera.CFrame; Camera.CameraSubject = _G.FC
        task.spawn(function() while _G.FC do _G.FC.CFrame = _G.FC.CFrame * CFrame.new(Player.Character.Humanoid.MoveDirection * 2) Camera.CFrame = _G.FC.CFrame task.wait() end end)
    else if _G.FC then _G.FC:Destroy(); _G.FC = nil; Camera.CameraSubject = Player.Character.Humanoid end end
end)

-- ==========================================
-- [ WORLD / WEATHER FEATURES ]
-- ==========================================
AddButton(pgWorld, "☀️ SIANG TERANG", function() _G.WMode = "Siang"; Lighting.ClockTime = 14; Lighting.FogEnd = 100000 end)
AddButton(pgWorld, "🌙 MALAM HARI", function() _G.WMode = "Malam"; Lighting.ClockTime = 0 end)
AddButton(pgWorld, "🌅 SUNSET ESTETIK", function() _G.WMode = "Sunset"; Lighting.ClockTime = 17.5 end)
AddButton(pgWorld, "❄️ SALJU / BERKABUT", function() _G.WMode = "Fog"; Lighting.FogEnd = 300; Lighting.FogColor = Color3.new(1,1,1) end)
AddButton(pgWorld, "🌧️ MENDUNG / HUJAN", function() _G.WMode = "Rain"; Lighting.ClockTime = 15; Lighting.Brightness = 0.5; Lighting.OutdoorAmbient = Color3.fromRGB(50,50,50) end)
AddToggle(pgWorld, "Realistic Graphics", function(s) Lighting.Brightness = s and 3 or 1 end)

-- --- LOOP SYSTEM ---
RunService.Stepped:Connect(function()
    if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
end)

-- --- LOGO FN (DRAGGABLE) ---
local min = Instance.new("TextButton", sg)
min.Size = UDim2.new(0, 45, 0, 45); min.Position = UDim2.new(0, 10, 0.4, 0); min.Text = "FN"; min.BackgroundColor3 = Color3.fromRGB(0, 120, 255); min.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", min).CornerRadius = UDim.new(1,0)
MakeDraggable(min)
min.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
