-- FH4N HUB | V.28 ETERNITY (THE FINAL COMPLETION)
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

if game.CoreGui:FindFirstChild("FH4N_V28") then game.CoreGui.FH4N_V28:Destroy() end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "FH4N_V28"
sg.ResetOnSpawn = false

-- --- DRAG SYSTEM (SMOOTH & ANTI-ANALOG) ---
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

-- --- MAIN UI ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 400); main.Position = UDim2.new(0.5, -275, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 10); main.Visible = false; main.BorderSizePixel = 0
Instance.new("UICorner", main); MakeDraggable(main)

local sb = Instance.new("Frame", main); sb.Size = UDim2.new(0, 140, 1, 0); sb.BackgroundColor3 = Color3.fromRGB(12, 12, 15); Instance.new("UICorner", sb)
local cont = Instance.new("Frame", main); cont.Position = UDim2.new(0, 145, 0, 5); cont.Size = UDim2.new(1, -150, 1, -10); cont.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", cont); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,25,0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5); return p
end

local pages = {
    P = createPage("Player"), C = createPage("Combat"), V = createPage("Visual"), 
    T = createPage("Teleport"), W = createPage("World"), D = createPage("Dances"), M = createPage("Misc")
}
pages.P.Visible = true

local function AddTab(txt, target, order)
    local b = Instance.new("TextButton", sb); b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, 10 + (36 * order))
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(25, 25, 35); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 8; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _,v in pairs(cont:GetChildren()) do v.Visible = false end; target.Visible = true end)
end

local function AddToggle(p, txt, cb)
    local s = false
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(20, 20, 25); b.TextColor3 = Color3.new(0.8, 0.8, 0.8); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() s = not s; b.BackgroundColor3 = s and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(20, 20, 25); b.Text = txt .. ": " .. (s and "ON" or "OFF"); cb(s) end)
end

local function AddInput(p, place, cb)
    local t = Instance.new("TextBox", p); t.Size = UDim2.new(1, -10, 0, 35); t.PlaceholderText = place; t.BackgroundColor3 = Color3.fromRGB(15, 15, 20); t.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", t)
    t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
end

local function AddBtn(p, txt, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(35, 35, 45); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- --- NAVIGATION ---
AddTab("🔥 PLAYER", pages.P, 0); AddTab("⚔️ COMBAT", pages.C, 1); AddTab("👁️ VISUAL", pages.V, 2)
AddTab("🌀 TELEPORT", pages.T, 3); AddTab("🌍 WORLD", pages.W, 4); AddTab("🕺 DANCES", pages.D, 5); AddTab("🛠️ MISC", pages.M, 6)

-- --- [ PLAYER ] ---
AddInput(pages.P, "WalkSpeed", function(v) _G.WS = tonumber(v) end)
AddInput(pages.P, "JumpPower", function(v) Player.Character.Humanoid.JumpPower = tonumber(v); Player.Character.Humanoid.UseJumpPower = true end)
AddToggle(pages.P, "Fly Mode", function(v)
    _G.Fly = v
    if v then
        local root = Player.Character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6); bv.Name = "ETH_Fly"
        local bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1e6,1e6,1e6); bg.Name = "ETH_Gyro"
        task.spawn(function()
            while _G.Fly do bv.Velocity = Camera.CFrame.LookVector * (_G.WS or 50); bg.CFrame = Camera.CFrame; task.wait() end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)
AddToggle(pages.P, "Noclip", function(v) _G.Nc = v end)
AddToggle(pages.P, "Infinite Jump", function(v) _G.IJ = v end)
AddBtn(pages.P, "Reset Character", function() Player.Character:BreakJoints() end)

-- --- [ COMBAT ] ---
AddToggle(pages.C, "Hitbox Expander", function(v)
    _G.Hitbox = v
    task.spawn(function()
        while _G.Hitbox do
            for _,p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(15, 15, 15)
                    p.Character.HumanoidRootPart.Transparency = 0.8
                end
            end; task.wait(1)
        end
    end)
end)
AddToggle(pages.C, "Kill Aura (WIP)", function(v) _G.KA = v end)
AddToggle(pages.C, "Spin Bot", function(v)
    _G.Spin = v
    while _G.Spin do Player.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(45), 0); task.wait() end
end)

-- --- [ VISUAL ] ---
AddToggle(pages.V, "ESP Tracers (Lines)", function(v)
    _G.Tracers = v
    -- Logic Tracer Here
end)
AddToggle(pages.V, "ESP Highlight", function(v)
    _G.ESP = v
    while _G.ESP do
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character and not p.Character:FindFirstChild("Highlight") then
                Instance.new("Highlight", p.Character).FillColor = Color3.new(1, 0, 0)
            end
        end; task.wait(2)
    end
end)
AddInput(pages.V, "Field of View", function(v) Camera.FieldOfView = tonumber(v) end)

-- --- [ TELEPORT ] ---
AddInput(pages.T, "Teleport to Player", function(v)
    for _,p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(v:lower()) then Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end
    end
end)
AddBtn(pages.T, "Server Hop (Cari Server Baru)", function()
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(Servers.data) do
        if s.playing < s.maxPlayers then TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id) end
    end
end)

-- --- [ WORLD ] ---
AddToggle(pages.W, "FullBright", function(v) _G.FB = v end)
AddBtn(pages.W, "Time: Morning", function() Lighting.ClockTime = 9 end)
AddBtn(pages.W, "Time: Night", function() Lighting.ClockTime = 0 end)
AddBtn(pages.W, "Remove Fog & Clouds", function() Lighting.FogEnd = 1e7; for _,v in pairs(Lighting:GetChildren()) do if v:IsA("Clouds") then v:Destroy() end end end)

-- --- [ DANCES ] ---
local function Dance(id)
    for _,v in pairs(Player.Character.Humanoid:GetPlayingAnimationTracks()) do v:Stop() end
    local a = Instance.new("Animation"); a.AnimationId = "rbxassetid://"..id
    local t = Player.Character.Humanoid:LoadAnimation(a); t.Looped = true; t:Play()
end
AddBtn(pages.D, "🕺 Old School", function() Dance("333333135") end)
AddBtn(pages.D, "👯 Stylish", function() Dance("215384594") end)
AddBtn(pages.D, "🔥 Hip Hop", function() Dance("330339186") end)
AddBtn(pages.D, "🌀 Breakspin", function() Dance("182436356") end)
AddBtn(pages.D, "🛑 STOP DANCE", function() for _,v in pairs(Player.Character.Humanoid:GetPlayingAnimationTracks()) do v:Stop() end end)

-- --- [ MISC ] ---
AddBtn(pages.M, "FPS Booster (Potato PC)", function()
    for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end end
end)
AddToggle(pages.M, "Auto Clicker", function(v)
    _G.AC = v
    while _G.AC do
        local tool = Player.Character:FindFirstChildOfClass("Tool")
        if tool then tool:Activate() end
        task.wait(0.1)
    end
end)
AddBtn(pages.M, "Infinite Yield (FE Admin)", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

-- --- LOGO FN (FIXED DRAG) ---
local logo = Instance.new("TextButton", sg)
logo.Size = UDim2.new(0, 60, 0, 60); logo.Position = UDim2.new(0, 50, 0, 150)
logo.Text = "FN"; logo.BackgroundColor3 = Color3.fromRGB(0, 120, 255); logo.TextColor3 = Color3.new(1,1,1)
logo.Font = "GothamBold"; logo.TextSize = 20; Instance.new("UICorner", logo).CornerRadius = UDim.new(1,0)
MakeDraggable(logo)

logo.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- --- LOOPS ---
UIS.JumpRequest:Connect(function() if _G.IJ then Player.Character.Humanoid:ChangeState(3) end end)
RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
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
