-- [[ FH4N HUB | V.37 - COMPLETE OVERHAUL ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Global States
_G.WS = 16
_G.JP = 50
_G.IJ = false
_G.Nc = false
_G.Fly = false
_G.FB = false
_G.Hitbox = false
_G.ESP = false
_G.AntiAFK = true

-- Anti-AFK Logic
Player.Idled:Connect(function()
    if _G.AntiAFK then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

-- UI Setup
local UI_PARENT = game:GetService("CoreGui") or Player:FindFirstChild("PlayerGui")
if UI_PARENT:FindFirstChild("FH4N_FINAL") then UI_PARENT.FH4N_FINAL:Destroy() end

local sg = Instance.new("ScreenGui", UI_PARENT); sg.Name = "FH4N_FINAL"

-- --- DRAG SYSTEM ---
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

-- --- MAIN PANEL ---
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 550, 0, 400); Main.Position = UDim2.new(0.5, -275, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15); Main.Visible = true; Main.BorderSizePixel = 0
Instance.new("UICorner", Main); MakeDraggable(Main)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22); Instance.new("UICorner", Sidebar)
local Container = Instance.new("Frame", Main); Container.Position = UDim2.new(0, 145, 0, 10); Container.Size = UDim2.new(1, -155, 1, -20); Container.BackgroundTransparency = 1

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Container); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0, 0, 5, 0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 6); return p
end

local pg = { P = CreatePage("Player"), C = CreatePage("Combat"), V = CreatePage("Visual"), T = CreatePage("TP"), M = CreatePage("Misc") }
pg.P.Visible = true

-- --- UI ELEMENTS ---
local function AddTab(txt, target, order)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, 10 + (40 * order))
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.TextColor3 = Color3.new(1, 1, 1); b.Font = "GothamBold"
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do v.Visible = false end; target.Visible = true end)
end

local function AddToggle(p, txt, cb)
    local s = false
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 38); b.Text = txt .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() s = not s; b.BackgroundColor3 = s and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(25, 25, 30); b.Text = txt .. ": " .. (s and "ON" or "OFF"); cb(s) end)
end

local function AddInput(p, place, cb)
    local t = Instance.new("TextBox", p); t.Size = UDim2.new(1, -10, 0, 38); t.PlaceholderText = place; t.Text = ""; t.BackgroundColor3 = Color3.fromRGB(20, 20, 25); t.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", t)
    t.FocusLost:Connect(function() cb(t.Text) end)
end

local function AddBtn(p, txt, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 38); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- --- CONTENT SETUP ---
AddTab("👤 PLAYER", pg.P, 0); AddTab("⚔️ COMBAT", pg.C, 1); AddTab("👁️ VISUAL", pg.V, 2); AddTab("🌀 TELEPORT", pg.T, 3); AddTab("🛠️ MISC", pg.M, 4)

-- PLAYER
AddInput(pg.P, "WalkSpeed / FlySpeed", function(v) _G.WS = tonumber(v) or 16 end)
AddInput(pg.P, "Jump Power", function(v) _G.JP = tonumber(v) or 50 end)
AddToggle(pg.P, "Fly 3D (Analog Support)", function(v)
    _G.Fly = v
    if v then
        task.spawn(function()
            local char = Player.Character; local root = char:WaitForChild("HumanoidRootPart"); local hum = char:WaitForChild("Humanoid")
            local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6)
            local bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
            while _G.Fly do
                bg.CFrame = Camera.CFrame
                bv.Velocity = (hum.MoveDirection.Magnitude > 0) and (Camera.CFrame.LookVector * _G.WS) or Vector3.new(0, 0.1, 0)
                task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)
AddToggle(pg.P, "Noclip", function(v) _G.Nc = v end)
AddToggle(pg.P, "Infinite Jump", function(v) _G.IJ = v end)

-- COMBAT
AddToggle(pg.C, "Hitbox Expander (15x15)", function(v) _G.Hitbox = v end)
AddToggle(pg.C, "Spin Bot", function(v) _G.Spin = v; task.spawn(function() while _G.Spin do Player.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(60), 0); task.wait() end end) end)

-- VISUAL
AddToggle(pg.V, "ESP Highlight", function(v) _G.ESP = v end)
AddToggle(pg.V, "FullBright", function(v) _G.FB = v end)
AddBtn(pg.V, "FPS Booster", function() 
    for _, v in pairs(game:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end if v:IsA("Decal") then v:Destroy() end end
end)

-- TELEPORT
AddInput(pg.T, "TP Player Name", function(v)
    for _,p in pairs(Players:GetPlayers()) do if p.Name:lower():find(v:lower()) then Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end end
end)
AddBtn(pg.T, "Server Hop", function() TeleportService:Teleport(game.PlaceId) end)
AddBtn(pg.T, "Rejoin", function() TeleportService:Teleport(game.PlaceId, Player) end)

-- MISC
AddToggle(pg.M, "Anti-AFK", function(v) _G.AntiAFK = v end)
AddBtn(pg.M, "Infinite Yield (Admin)", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

-- --- LOGO ---
local Logo = Instance.new("TextButton", sg); Logo.Size = UDim2.new(0, 55, 0, 55); Logo.Position = UDim2.new(0, 20, 0.5, 0)
Logo.Text = "FN"; Logo.BackgroundColor3 = Color3.fromRGB(0, 120, 255); Logo.TextColor3 = Color3.new(1, 1, 1); Logo.Font = "GothamBold"; Logo.TextSize = 22
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0); MakeDraggable(Logo)
Logo.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- --- HEARTBEAT CORE ---
RunService.Heartbeat:Connect(function()
    pcall(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local hum = Player.Character.Humanoid
            if _G.WS and not _G.Fly then hum.WalkSpeed = _G.WS end
            hum.JumpPower = _G.JP; hum.UseJumpPower = true
            if _G.Nc then for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            if _G.Hitbox then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character then p.Character.HumanoidRootPart.Size = Vector3.new(15,15,15); p.Character.HumanoidRootPart.Transparency = 0.7 end
                end
            end
            if _G.ESP then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character and not p.Character:FindFirstChild("Highlight") then Instance.new("Highlight", p.Character) end
                end
            end
        end
        if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.Brightness = 2 end
    end)
end)
UIS.JumpRequest:Connect(function() if _G.IJ and Player.Character then Player.Character.Humanoid:ChangeState(3) end end)r3.new(1,1,1) end
end)

-- --- MINIMIZE ---
local m = Instance.new("TextButton", sg); m.Size = UDim2.new(0, 45, 0, 45); m.Position = UDim2.new(0, 10, 0.4, 0); m.Text = "FN"; m.BackgroundColor3 = Color3.fromRGB(0, 120, 255); m.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", m).CornerRadius = UDim.new(1,0)
MakeDraggable(m); m.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
