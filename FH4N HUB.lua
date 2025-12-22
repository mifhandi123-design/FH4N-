-- FH4N HUB | V.9 ULTIMATE (MAX ZOOM FIXED)
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera

if game.CoreGui:FindFirstChild("FH4N_V9_ULTIMATE") then game.CoreGui.FH4N_V9_ULTIMATE:Destroy() end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "FH4N_V9_ULTIMATE"
sg.ResetOnSpawn = false

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
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- --- MAIN UI ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 450, 0, 320); main.Position = UDim2.new(0.5, -225, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 15); main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
MakeDraggable(main)

local sb = Instance.new("Frame", main)
sb.Size = UDim2.new(0, 110, 1, 0); sb.BackgroundColor3 = Color3.fromRGB(20, 20, 25); sb.BorderSizePixel = 0
Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 10)

local cont = Instance.new("Frame", main)
cont.Position = UDim2.new(0, 115, 0, 5); cont.Size = UDim2.new(1, -120, 1, -10); cont.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", cont)
    p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,5,0) -- Canvas diperbesar agar muat banyak
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    return p
end

local pgP = createPage("P1"); pgP.Visible = true 
local pgV = createPage("P2") 
local pgW = createPage("P3") 
local pgM = createPage("P4") 

-- --- UI BUILDER ---
local function AddTab(txt, target, order)
    local b = Instance.new("TextButton", sb)
    b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, 45 + (38 * order))
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(35, 35, 45); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        pgP.Visible = false; pgV.Visible = false; pgW.Visible = false; pgM.Visible = false; target.Visible = true
    end)
end

local function AddToggle(parent, txt, cb)
    local s = false
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = "Gotham"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        s = not s; b.BackgroundColor3 = s and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(25, 25, 30)
        b.Text = txt .. ": " .. (s and "ON" or "OFF"); cb(s)
    end)
end

local function AddInput(parent, place, cb)
    local t = Instance.new("TextBox", parent)
    t.Size = UDim2.new(1, -10, 0, 35); t.PlaceholderText = place; t.Text = ""
    t.BackgroundColor3 = Color3.fromRGB(15, 15, 20); t.TextColor3 = Color3.new(1, 1, 1); t.Font = "Gotham"; t.TextSize = 10; Instance.new("UICorner", t)
    t.FocusLost:Connect(function(ent) if ent then cb(t.Text) end end)
end

local function AddBtn(parent, txt, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.TextColor3 = Color3.new(1,1,1); b.Font = "Gotham"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- --- NAVIGATION ---
AddTab("PLAYER", pgP, 0); AddTab("VISUAL", pgV, 1); AddTab("WORLD", pgW, 2); AddTab("MISC", pgM, 3)

-- ==========================================
-- [ 1. PLAYER: AIM, FLY, SPEED, JUMP, ZOOM ]
-- ==========================================

-- AUTO AIM
local function GetClosestPlayer()
    local closest, dist = nil, math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local d = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; closest = v end
        end
    end
    return closest
end
AddToggle(pgP, "Auto Aim (Lock)", function(v)
    _G.AutoAim = v
    task.spawn(function()
        while _G.AutoAim do
            local target = GetClosestPlayer()
            if target and target.Character then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position) end
            task.wait()
        end
    end)
end)

-- FLY SYSTEM
local flyUp, flyDown = false, false
local ctrl = Instance.new("Frame", sg); ctrl.Size = UDim2.new(0, 60, 0, 130); ctrl.Position = UDim2.new(1, -75, 0.5, -65); ctrl.BackgroundTransparency = 1; ctrl.Visible = false
local function makeFlyBtn(txt, pos, cb_s, cb_e)
    local b = Instance.new("TextButton", ctrl); b.Size = UDim2.new(1,0,0,60); b.Position = pos; b.Text = txt; b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.5; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Down:Connect(cb_s); b.MouseButton1Up:Connect(cb_e)
end
makeFlyBtn("UP", UDim2.new(0,0,0,0), function() flyUp = true end, function() flyUp = false end)
makeFlyBtn("DOWN", UDim2.new(0,0,0,70), function() flyDown = true end, function() flyDown = false end)

AddToggle(pgP, "Fly Pure Analog", function(v)
    _G.Fly = v; ctrl.Visible = v
    if v then
        local root = Player.Character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6); bv.Name = "V9FlyV"
        local bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1e6,1e6,1e6); bg.Name = "V9FlyG"
        task.spawn(function()
            while _G.Fly do
                local md = Player.Character.Humanoid.MoveDirection
                local y = (flyUp and 1 or 0) + (flyDown and -1 or 0)
                bv.Velocity = (md * (_G.WS or 50)) + Vector3.new(0, y * (_G.WS or 50), 0)
                bg.CFrame = Camera.CFrame; task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)

-- STATS (SPEED, JUMP, ZOOM, GRAVITY)
AddInput(pgP, "Speed / FlySpeed", function(v) _G.WS = tonumber(v) end)
AddInput(pgP, "Jump Power", function(v) Player.Character.Humanoid.JumpPower = tonumber(v); Player.Character.Humanoid.UseJumpPower = true end)
AddInput(pgP, "MAX ZOOM (Distance)", function(v) Player.CameraMaxZoomDistance = tonumber(v) end)
AddInput(pgP, "Gravity Changer", function(v) workspace.Gravity = tonumber(v) end)
AddToggle(pgP, "Noclip", function(v) _G.Nc = v end)
AddToggle(pgP, "Infinite Jump", function(v) _G.IJ = v end)

-- ==========================================
-- [ 2. VISUAL: ESP, FPS, FOV ]
-- ==========================================
AddToggle(pgV, "ESP Player Highlight", function(v)
    _G.ESP = v
    task.spawn(function()
        while _G.ESP do
            for _,p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and not p.Character:FindFirstChild("Highlight") then Instance.new("Highlight", p.Character) end
            end; task.wait(2)
        end
        for _,p in pairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end end
    end)
end)

AddToggle(pgV, "Show FPS", function(v)
    _G.FPS = v
    if v then
        local l = Instance.new("TextLabel", sg); l.Size = UDim2.new(0,70,0,25); l.Position = UDim2.new(0,10,0,10); l.BackgroundColor3 = Color3.new(0,0,0); l.TextColor3 = Color3.new(0,1,0); l.BackgroundTransparency = 0.5
        local f = 0; local lt = tick()
        RunService.RenderStepped:Connect(function()
            if not _G.FPS then l:Destroy() return end
            f = f + 1; if tick()-lt >= 1 then l.Text = "FPS: "..f; f = 0; lt = tick() end
        end)
    end
end)
AddInput(pgV, "Camera FOV", function(v) Camera.FieldOfView = tonumber(v) end)

-- ==========================================
-- [ 3. WORLD & 4. MISC ]
-- ==========================================
AddToggle(pgW, "FullBright", function(v) _G.FB = v end)
AddBtn(pgW, "☀️ Siang", function() Lighting.ClockTime = 14 end)
AddBtn(pgW, "🌙 Malam", function() Lighting.ClockTime = 0 end)

AddToggle(pgM, "Auto Clicker", function(v)
    _G.AC = v
    task.spawn(function()
        while _G.AC do
            local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            task.wait(0.1)
        end
    end)
end)
AddBtn(pgM, "Rejoin Game", function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end)

-- --- CORE SYSTEM ---
UIS.JumpRequest:Connect(function() if _G.IJ then Player.Character.Humanoid:ChangeState(3) end end)
RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
    if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
end)

-- --- MINIMIZE ---
local m = Instance.new("TextButton", sg); m.Size = UDim2.new(0, 45, 0, 45); m.Position = UDim2.new(0, 10, 0.4, 0); m.Text = "FN"; m.BackgroundColor3 = Color3.fromRGB(0, 120, 255); m.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", m).CornerRadius = UDim.new(1,0)
MakeDraggable(m); m.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
