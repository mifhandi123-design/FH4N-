-- [[ FH4N HUB | V.29 ETERNITY - SUPREME EDITION ]] --
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Variabel Global untuk Locking
_G.WS = 16
_G.JP = 50
_G.IJ = false
_G.Nc = false
_G.Fly = false
_G.FB = false

-- Cleanup UI Lama
if game.CoreGui:FindFirstChild("FH4N_V29") then game.CoreGui.FH4N_V29:Destroy() end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "FH4N_V29"
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

-- --- MAIN UI PANEL ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 400); main.Position = UDim2.new(0.5, -275, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); main.Visible = false; main.BorderSizePixel = 0
Instance.new("UICorner", main); MakeDraggable(main)

local sb = Instance.new("Frame", main); sb.Size = UDim2.new(0, 140, 1, 0); sb.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", sb)
local cont = Instance.new("Frame", main); cont.Position = UDim2.new(0, 145, 0, 5); cont.Size = UDim2.new(1, -150, 1, -10); cont.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", cont); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 3; p.CanvasSize = UDim2.new(0,0,2,0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8); return p
end

local pages = {
    P = createPage("Player"), C = createPage("Combat"), V = createPage("Visual"), 
    T = createPage("Teleport"), W = createPage("World"), M = createPage("Misc")
}
pages.P.Visible = true

local function AddTab(txt, target, order)
    local b = Instance.new("TextButton", sb); b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, 10 + (40 * order))
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 11; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _,v in pairs(cont:GetChildren()) do v.Visible = false end; target.Visible = true end)
end

local function AddToggle(p, txt, cb)
    local s = false
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 38); b.Text = txt .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(0.8, 0.8, 0.8); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() s = not s; b.BackgroundColor3 = s and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(25, 25, 30); b.Text = txt .. ": " .. (s and "ON" or "OFF"); cb(s) end)
end

local function AddInput(p, place, cb)
    local t = Instance.new("TextBox", p); t.Size = UDim2.new(1, -10, 0, 38); t.PlaceholderText = place; t.BackgroundColor3 = Color3.fromRGB(20, 20, 25); t.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", t)
    t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
end

local function AddBtn(p, txt, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 38); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- --- NAVIGATION ---
AddTab("👤 PLAYER", pages.P, 0); AddTab("⚔️ COMBAT", pages.C, 1); AddTab("👁️ VISUAL", pages.V, 2)
AddTab("🌀 TELEPORT", pages.T, 3); AddTab("🌍 WORLD", pages.W, 4); AddTab("🛠️ MISC", pages.M, 5)

-- --- [ PLAYER PAGE ] ---
AddInput(pages.P, "Set WalkSpeed (Default 16)", function(v) _G.WS = tonumber(v) end)
AddInput(pages.P, "Set JumpPower (Default 50)", function(v) _G.JP = tonumber(v) end)
AddToggle(pages.P, "Infinite Jump", function(v) _G.IJ = v end)
AddToggle(pages.P, "Noclip (Tembus Tembok)", function(v) _G.Nc = v end)
AddToggle(pages.P, "Fly 3D (Ikuti Kamera)", function(v)
    _G.Fly = v
    if v then
        local root = Player.Character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6); bv.Name = "ETH_Fly"
        local bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1e6,1e6,1e6); bg.Name = "ETH_Gyro"
        task.spawn(function()
            while _G.Fly do 
                bv.Velocity = Camera.CFrame.LookVector * (_G.WS or 50)
                bg.CFrame = Camera.CFrame
                task.wait() 
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)
AddBtn(pages.P, "Reset Character", function() Player.Character:BreakJoints() end)

-- --- [ COMBAT PAGE ] ---
AddToggle(pages.C, "Hitbox Expander (15x15)", function(v)
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
AddToggle(pages.C, "Spin Bot", function(v)
    _G.Spin = v
    task.spawn(function() while _G.Spin do Player.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(50), 0); task.wait() end end)
end)

-- --- [ VISUAL PAGE ] ---
AddToggle(pages.V, "ESP Highlight", function(v)
    _G.ESP = v
    task.spawn(function()
        while _G.ESP do
            for _,p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Character and not p.Character:FindFirstChild("Highlight") then
                    Instance.new("Highlight", p.Character).FillColor = Color3.new(1, 0, 0)
                end
            end; task.wait(2)
        end
    end)
end)
AddInput(pages.V, "Field of View (FOV)", function(v) Camera.FieldOfView = tonumber(v) end)

-- --- [ TELEPORT PAGE ] ---
AddInput(pages.T, "TP to Player (Name)", function(v)
    for _,p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(v:lower()) then Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end
    end
end)
AddBtn(pages.T, "Server Hop", function()
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, s in pairs(Servers.data) do
        if s.playing < s.maxPlayers then TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id) end
    end
end)

-- --- [ WORLD PAGE ] ---
AddToggle(pages.W, "FullBright (Anti Gelap)", function(v) _G.FB = v end)
AddBtn(pages.W, "Set Morning", function() Lighting.ClockTime = 10 end)
AddBtn(pages.W, "Set Night", function() Lighting.ClockTime = 0 end)

-- --- [ MISC PAGE ] ---
AddToggle(pages.M, "Auto Clicker", function(v)
    _G.AC = v
    task.spawn(function()
        while _G.AC do
            local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            task.wait(0.1)
        end
    end)
end)
AddBtn(pages.M, "Infinite Yield", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

-- --- FLOATING LOGO BUTTON ---
local logo = Instance.new("TextButton", sg)
logo.Size = UDim2.new(0, 55, 0, 55); logo.Position = UDim2.new(0, 20, 0.4, 0)
logo.Text = "FN"; logo.BackgroundColor3 = Color3.fromRGB(0, 120, 255); logo.TextColor3 = Color3.new(1,1,1)
logo.Font = "GothamBold"; logo.TextSize = 20; Instance.new("UICorner", logo).CornerRadius = UDim.new(1,0)
MakeDraggable(logo)

logo.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)

-- --- CORE ENGINE (LOOPS & LOCKS) ---
UIS.JumpRequest:Connect(function() 
    if _G.IJ and Player.Character and Player.Character:FindFirstChild("Humanoid") then 
        Player.Character.Humanoid:ChangeState(3) 
    end 
end)

RunService.Heartbeat:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local Hum = Player.Character.Humanoid
        -- Speed Lock
        if _G.WS and not _G.Fly then Hum.WalkSpeed = _G.WS end
        -- Jump Lock
        if _G.JP then Hum.JumpPower = _G.JP; Hum.UseJumpPower = true end
        -- Noclip Logic
        if _G.Nc then 
            for _,v in pairs(Player.Character:GetDescendants()) do 
                if v:IsA("BasePart") then v.CanCollide = false end 
            end 
        end
    end
    -- World Lighting Lock
    if _G.FB then 
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.Brightness = 2
    end
end)_G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
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
