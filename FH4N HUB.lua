-- [[ FH4N HUB | V.35 - THE ALL-IN-ONE FINAL ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Global Settings (Kunci Nilai)
_G.WS = 16
_G.JP = 50
_G.IJ = false
_G.Nc = false
_G.Fly = false
_G.FB = false
_G.Hitbox = false

-- Cleanup UI Lama
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("FH4N_V35") then CoreGui.FH4N_V35:Destroy() end

local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "FH4N_V35"

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
Main.Size = UDim2.new(0, 520, 0, 380); Main.Position = UDim2.new(0.5, -260, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15); Main.Visible = false; Main.BorderSizePixel = 0
Instance.new("UICorner", Main); MakeDraggable(Main)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22); Instance.new("UICorner", Sidebar)
local Container = Instance.new("Frame", Main); Container.Position = UDim2.new(0, 135, 0, 10); Container.Size = UDim2.new(1, -145, 1, -20); Container.BackgroundTransparency = 1

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Container); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0, 0, 4, 0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5); return p
end

local pages = { P = CreatePage("Player"), C = CreatePage("Combat"), T = CreatePage("TP"), W = CreatePage("World"), M = CreatePage("Misc") }
pages.P.Visible = true

-- --- UI HELPERS ---
local function AddTab(name, target, order)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, 10 + (36 * order))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.TextColor3 = Color3.new(1, 1, 1); b.Font = "GothamBold"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do v.Visible = false end; target.Visible = true end)
end

local function AddToggle(p, txt, cb)
    local s = false
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() s = not s; b.BackgroundColor3 = s and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(25, 25, 30); b.Text = txt .. ": " .. (s and "ON" or "OFF"); cb(s) end)
end

local function AddInput(p, place, cb)
    local t = Instance.new("TextBox", p); t.Size = UDim2.new(1, -10, 0, 35); t.PlaceholderText = place; t.Text = ""; t.BackgroundColor3 = Color3.fromRGB(20, 20, 25); t.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", t)
    t.FocusLost:Connect(function() cb(t.Text) end)
end

local function AddBtn(p, txt, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- --- NAVIGATION ---
AddTab("👤 PLAYER", pages.P, 0); AddTab("⚔️ COMBAT", pages.C, 1); AddTab("🌀 TELEPORT", pages.T, 2); AddTab("🌍 WORLD", pages.W, 3); AddTab("🛠️ MISC", pages.M, 4)

-- PLAYER PAGE
AddInput(pages.P, "Speed (Walk/Fly)", function(v) _G.WS = tonumber(v) or 16 end)
AddInput(pages.P, "Jump Power", function(v) _G.JP = tonumber(v) or 50 end)
AddToggle(pages.P, "Fly 3D (Analog Support)", function(v)
    _G.Fly = v
    if v then
        task.spawn(function()
            local char = Player.Character
            local root = char:WaitForChild("HumanoidRootPart")
            local hum = char:WaitForChild("Humanoid")
            local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6)
            local bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
            while _G.Fly do
                bg.CFrame = Camera.CFrame
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    bv.Velocity = Camera.CFrame.LookVector * (moveDir.Magnitude * _G.WS)
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0)
                end
                task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)
AddToggle(pages.P, "Noclip", function(v) _G.Nc = v end)
AddToggle(pages.P, "Infinite Jump", function(v) _G.IJ = v end)

-- COMBAT PAGE
AddToggle(pages.C, "Hitbox Expander", function(v) _G.Hitbox = v end)
AddBtn(pages.C, "Spin Bot", function() 
    task.spawn(function() while true do if Player.Character then Player.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(50), 0) end task.wait() end end)
end)

-- TELEPORT PAGE
AddInput(pages.T, "TP to Player (Name)", function(v)
    for _,p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(v:lower()) then Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end
    end
end)
AddBtn(pages.T, "Server Hop", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/6W_X/ServerHop/main/ServerHop.lua'))() end)
AddBtn(pages.T, "Rejoin Game", function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end)

-- WORLD PAGE
AddToggle(pages.W, "FullBright", function(v) _G.FB = v end)
AddBtn(pages.W, "Set Morning", function() Lighting.ClockTime = 12 end)
AddBtn(pages.W, "FPS Booster Pro", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end)

-- MISC PAGE
AddBtn(pages.M, "Infinite Yield (Admin)", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

-- --- LOGO BUTTON ---
local Logo = Instance.new("TextButton", sg)
Logo.Size = UDim2.new(0, 50, 0, 50); Logo.Position = UDim2.new(0, 10, 0.5, 0)
Logo.Text = "FN"; Logo.BackgroundColor3 = Color3.fromRGB(0, 120, 255); Logo.TextColor3 = Color3.new(1, 1, 1); Logo.Font = "GothamBold"; Logo.TextSize = 20
Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0); MakeDraggable(Logo)
Logo.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- --- ENGINE LOOP ---
UIS.JumpRequest:Connect(function() if _G.IJ and Player.Character then Player.Character.Humanoid:ChangeState(3) end end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local hum = Player.Character.Humanoid
            if _G.WS and not _G.Fly then hum.WalkSpeed = _G.WS end
            hum.JumpPower = _G.JP
            hum.UseJumpPower = true
            
            if _G.Nc then
                for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
            
            if _G.Hitbox then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character then 
                        p.Character.HumanoidRootPart.Size = Vector3.new(15,15,15)
                        p.Character.HumanoidRootPart.Transparency = 0.7 
                    end
                end
            end
        end
        if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1); Lighting.Brightness = 2 end
    end)
end)     if _G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
    if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
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
