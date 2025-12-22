-- FH4N HUB V41 | FINAL STABILITY
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Bersihkan UI lama
if game.CoreGui:FindFirstChild("FH4N_V41") then game.CoreGui.FH4N_V41:Destroy() end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "FH4N_V41"
sg.ResetOnSpawn = false

-- Fungsi Drag Sederhana (Delta Friendly)
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

-- UI Utama
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 380); main.Position = UDim2.new(0.5, -260, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.Visible = false; main.BorderSizePixel = 0
Instance.new("UICorner", main)
MakeDraggable(main)

local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 130, 1, 0); side.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", side)
local container = Instance.new("Frame", main); container.Position = UDim2.new(0, 135, 0, 5); container.Size = UDim2.new(1, -140, 1, -10); container.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", container); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,10,0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5); return p
end

local pg1 = createPage("P1"); pg1.Visible = true
local pg2 = createPage("P2"); local pg3 = createPage("P3"); local pg4 = createPage("P4")

local function AddTab(txt, target, order)
    local b = Instance.new("TextButton", side); b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, 10 + (40 * order))
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSansBold"; b.TextSize = 14; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _,v in pairs(container:GetChildren()) do v.Visible = false end; target.Visible = true end)
end

local function AddToggle(p, txt, cb)
    local s = false
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(20, 20, 20); b.TextColor3 = Color3.new(0.7, 0.7, 0.7); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() s = not s; b.BackgroundColor3 = s and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(20, 20, 20); b.Text = txt .. ": " .. (s and "ON" or "OFF"); cb(s) end)
end

local function AddInput(p, place, cb)
    local t = Instance.new("TextBox", p); t.Size = UDim2.new(1, -10, 0, 35); t.PlaceholderText = place; t.BackgroundColor3 = Color3.fromRGB(10, 10, 10); t.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", t)
    t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
end

local function AddBtn(p, txt, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40, 40, 40); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- TABS
AddTab("PLAYER", pg1, 0); AddTab("TELEPORT", pg2, 1); AddTab("COMBAT", pg3, 2); AddTab("IY/MISC", pg4, 3)

-- PLAYER FEATURES
AddInput(pg1, "Speed", function(v) _G.WS = tonumber(v) end)
AddInput(pg1, "Jump", function(v) Player.Character.Humanoid.JumpPower = tonumber(v) end)
AddToggle(pg1, "Fly", function(v)
    _G.Fly = v
    if v then
        local r = Player.Character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", r); bv.MaxForce = Vector3.new(1e6,1e6,1e6); bv.Name = "BF"
        task.spawn(function() while _G.Fly do bv.Velocity = Camera.CFrame.LookVector * (_G.WS or 50) task.wait() end bv:Destroy() end)
    end
end)
AddToggle(pg1, "Noclip", function(v) _G.Nc = v end)
AddToggle(pg1, "Inf Jump", function(v) _G.IJ = v end)

-- TELEPORT FEATURES
AddInput(pg2, "TP Player Name", function(v)
    for _,p in pairs(Players:GetPlayers()) do if p.Name:lower():find(v:lower()) then Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end end
end)
AddBtn(pg2, "Server Hop", function()
    local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _,v in pairs(x.data) do if v.playing < v.maxPlayers then TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id) end end
end)
AddBtn(pg2, "Rejoin", function() TeleportService:Teleport(game.PlaceId, Player) end)

-- COMBAT FEATURES
AddToggle(pg3, "Aimlock", function(v) _G.Aim = v end)
AddToggle(pg3, "Big Hitbox", function(v)
    _G.HB = v
    while _G.HB do
        for _,p in pairs(Players:GetPlayers()) do if p ~= Player and p.Character then p.Character.HumanoidRootPart.Size = Vector3.new(20,20,20) end end
        task.wait(1)
    end
end)

-- IY & MISC
AddToggle(pg4, "Freecam", function(v)
    _G.FC = v
    if v then
        local p = Instance.new("Part", workspace); p.Anchored = true; p.Transparency = 1; Camera.CameraSubject = p
        task.spawn(function() while _G.FC do p.CFrame = Camera.CFrame task.wait() end Camera.CameraSubject = Player.Character.Humanoid p:Destroy() end)
    end
end)
AddToggle(pg4, "Anti-Fling", function(v) _G.AF = v end)
AddToggle(pg4, "Spin Bot", function(v) _G.Spin = v end)
AddBtn(pg4, "Invisible", function() for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.Transparency = 1 end end end)
AddBtn(pg4, "FPS Boost", function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = "SmoothPlastic" end end end)

-- Tombol FN
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 60, 0, 60); btn.Position = UDim2.new(0, 10, 0.4, 0)
btn.Text = "FN"; btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); btn.TextColor3 = Color3.new(1,1,1); btn.Font = "SourceSansBold"; btn.TextSize = 20
Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
MakeDraggable(btn)
btn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- Main Loop
RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if _G.Spin then Player.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0,math.rad(45),0) end
    end
    if _G.Aim then
        local t = nil; local d = 1000
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("Head") then
                local dist = (p.Character.Head.Position - Camera.CFrame.Position).Magnitude
                if dist < d then d = dist; t = p end
            end
        end
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position) end
    end
end)
UIS.JumpRequest:Connect(function() if _G.IJ then Player.Character.Humanoid:ChangeState(3) end end).JumpRequest:Connect(function() if _G.IJ then Player.Character.Humanoid:ChangeState(3) end end)_G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
    if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
end)
    if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
end)

-- --- MINIMIZE ---
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
