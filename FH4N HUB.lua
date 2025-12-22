-- FH4N HUB V39 | THE FINAL GENESIS (DELTA STABLE)
-- SEMUA FITUR DIGABUNG: TP, FLY, SPEEDS, FREECAM, AIMBOT, ESP, ADMIN

local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

if game.CoreGui:FindFirstChild("FH4N_V39") then game.CoreGui.FH4N_V39:Destroy() end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "FH4N_V39"
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
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

-- --- UI SETUP ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 580, 0, 440); main.Position = UDim2.new(0.5, -290, 0.5, -220)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); main.Visible = false; main.BorderSizePixel = 0
Instance.new("UICorner", main); MakeDraggable(main)

local side = Instance.new("Frame", main); side.Size = UDim2.new(0, 150, 1, 0); side.BackgroundColor3 = Color3.fromRGB(8, 8, 8); Instance.new("UICorner", side)
local holder = Instance.new("Frame", main); holder.Position = UDim2.new(0, 155, 0, 5); holder.Size = UDim2.new(1, -165, 1, -10); holder.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", holder); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,30,0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); return p
end

local pages = {P=createPage("P"), T=createPage("T"), C=createPage("C"), V=createPage("V"), M=createPage("M")}
pages.P.Visible = true

local function AddTab(txt, target, order)
    local b = Instance.new("TextButton", side); b.Size = UDim2.new(0.9, 0, 0, 38); b.Position = UDim2.new(0.05, 0, 0, 10 + (43 * order))
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.TextColor3 = Color3.new(1,1,1); b.Font = "SourceSansBold"; b.TextSize = 14; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _,v in pairs(holder:GetChildren()) do v.Visible = false end; target.Visible = true end)
end

local function AddToggle(p, txt, cb)
    local s = false
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 42); b.Text = txt .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(18, 18, 18); b.TextColor3 = Color3.new(0.7,0.7,0.7); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() s = not s; b.BackgroundColor3 = s and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(18, 18, 18); b.Text = txt .. ": " .. (s and "ON" or "OFF"); cb(s) end)
end

local function AddInput(p, place, cb)
    local t = Instance.new("TextBox", p); t.Size = UDim2.new(1, -10, 0, 42); t.PlaceholderText = place; t.BackgroundColor3 = Color3.fromRGB(15, 15, 15); t.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", t)
    t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
end

local function AddBtn(p, txt, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 42); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- --- NAVIGATION ---
AddTab("MOVEMENT", pages.P, 0); AddTab("TELEPORT", pages.T, 1); AddTab("COMBAT", pages.C, 2); AddTab("VISUALS", pages.V, 3); AddTab("UTILS/ADMIN", pages.M, 4)

-- --- [ MOVEMENT ] ---
AddInput(pages.P, "WalkSpeed", function(v) _G.WS = tonumber(v) end)
AddInput(pages.P, "JumpPower", function(v) Player.Character.Humanoid.JumpPower = tonumber(v); Player.Character.Humanoid.UseJumpPower = true end)
AddInput(pages.P, "Gravity (Def 196)", function(v) workspace.Gravity = tonumber(v) end)
AddToggle(pages.P, "Fly Mode", function(v)
    _G.Fly = v
    if v then
        local root = Player.Character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6); bv.Name = "F"
        local bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1e6,1e6,1e6); bg.Name = "G"
        task.spawn(function()
            while _G.Fly do bv.Velocity = Camera.CFrame.LookVector * (_G.WS or 50); bg.CFrame = Camera.CFrame; task.wait() end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)
AddToggle(pages.P, "Noclip", function(v) _G.Nc = v end)
AddToggle(pages.P, "Infinite Jump", function(v) _G.IJ = v end)

-- --- [ TELEPORT ] ---
AddInput(pages.T, "Teleport to Player Name", function(v)
    for _,p in pairs(Players:GetPlayers()) do if p.Name:lower():find(v:lower()) then Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end end
end)
AddBtn(pages.T, "Click TP (Ctrl+Click)", function()
    local mouse = Player:GetMouse()
    mouse.Button1Down:Connect(function() if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then Player.Character.HumanoidRootPart.CFrame = mouse.Hit + Vector3.new(0,3,0) end end)
end)
AddBtn(pages.T, "Server Hop", function()
    local x = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _,v in pairs(x.data) do if v.playing < v.maxPlayers then TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id) end end
end)
AddBtn(pages.T, "Rejoin", function() TeleportService:Teleport(game.PlaceId, Player) end)

-- --- [ COMBAT ] ---
AddToggle(pages.C, "Aimlock (Nearest)", function(v)
    _G.Aim = v
    RunService.RenderStepped:Connect(function()
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
end)
AddToggle(pages.C, "Big Hitbox", function(v)
    _G.HB = v
    while _G.HB do
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then p.Character.HumanoidRootPart.Size = Vector3.new(25,25,25); p.Character.HumanoidRootPart.Transparency = 0.8 end
        end; task.wait(1)
    end
end)
AddToggle(pages.C, "Auto Clicker", function(v) _G.AC = v while _G.AC do local t = Player.Character:FindFirstChildOfClass("Tool") if t then t:Activate() end task.wait(0.05) end end)

-- --- [ VISUALS ] ---
AddToggle(pages.V, "Freecam", function(v)
    _G.Freecam = v
    if v then
        local p = Instance.new("Part", workspace); p.Anchored = true; p.CanCollide = false; p.Transparency = 1; p.CFrame = Camera.CFrame
        Camera.CameraSubject = p
        task.spawn(function()
            while _G.Freecam do p.CFrame = Camera.CFrame; task.wait() end
            Camera.CameraSubject = Player.Character.Humanoid; p:Destroy()
        end)
    end
end)
AddToggle(pages.V, "ESP Highlight", function(v)
    _G.ESP = v
    while _G.ESP do
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and not p.Character:FindFirstChild("Highlight") then Instance.new("Highlight", p.Character) end
        end; task.wait(2)
    end
end)
AddToggle(pages.V, "FullBright", function(v) _G.FB = v end)

-- --- [ UTILS ] ---
AddBtn(pages.M, "Infinite Yield Admin", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
AddBtn(pages.M, "CMD-X Admin", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source", true))() end)
AddBtn(pages.M, "Dark Dex Explorer", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
AddBtn(pages.M, "FPS Booster", function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end end end)

-- --- TOGGLE BUTTON ---
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 70, 0, 70); btn.Position = UDim2.new(0, 30, 0.4, 0)
btn.Text = "FN"; btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); btn.TextColor3 = Color3.new(1,1,1); btn.Font = "SourceSansBold"; btn.TextSize = 25
Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0); MakeDraggable(btn)
btn.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- --- LOOPS ---
RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
    if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
end)
UIS.JumpRequest:Connect(function() if _G.IJ then Player.Character.Humanoid:ChangeState(3) end end)_G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
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
