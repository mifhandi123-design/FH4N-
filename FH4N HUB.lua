-- [[ FH4N HUB | V.32 - THE TRUE ETERNITY ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
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
_G.AntiAFK = true

-- Anti-AFK Logic
local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end
end)

-- Cleanup UI
if game:GetService("CoreGui"):FindFirstChild("FH4N_V32") then game:GetService("CoreGui").FH4N_V32:Destroy() end

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
sg.Name = "FH4N_V32"

-- --- DRAG SYSTEM V3 (SUPER SMOOTH) ---
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- --- MAIN FRAME ---
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 520, 0, 380); Main.Position = UDim2.new(0.5, -260, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Main.Visible = false; Main.BorderSizePixel = 0
Instance.new("UICorner", Main); MakeDraggable(Main)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Instance.new("UICorner", Sidebar)
local Content = Instance.new("Frame", Main); Content.Position = UDim2.new(0, 135, 0, 5); Content.Size = UDim2.new(1, -140, 1, -10); Content.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", Content); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,4,0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5); return p
end

local pages = { P = createPage("P"), C = createPage("C"), T = createPage("T"), W = createPage("W"), M = createPage("M") }
pages.P.Visible = true

-- --- UI HELPERS ---
local function AddTab(name, target, pos)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, 10 + (36 * pos))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _,v in pairs(Content:GetChildren()) do v.Visible = false end; target.Visible = true end)
end

local function AddToggle(p, txt, cb)
    local s = false
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt..": OFF"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() s = not s; b.BackgroundColor3 = s and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(25, 25, 30); b.Text = txt..": "..(s and "ON" or "OFF"); cb(s) end)
end

local function AddBtn(p, txt, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- --- CONTENT ---
AddTab("👤 PLAYER", pages.P, 0); AddTab("⚔️ COMBAT", pages.C, 1); AddTab("🌀 TELEPORT", pages.T, 2); AddTab("🌍 WORLD", pages.W, 3); AddTab("🛠️ MISC", pages.M, 4)

-- Page: PLAYER
local inWS = Instance.new("TextBox", pages.P); inWS.Size = UDim2.new(1,-10,0,35); inWS.PlaceholderText = "WalkSpeed"; inWS.Text = ""; inWS.BackgroundColor3 = Color3.fromRGB(20,20,25); inWS.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", inWS); inWS.FocusLost:Connect(function() _G.WS = tonumber(inWS.Text) end)
local inJP = Instance.new("TextBox", pages.P); inJP.Size = UDim2.new(1,-10,0,35); inJP.PlaceholderText = "JumpPower"; inJP.Text = ""; inJP.BackgroundColor3 = Color3.fromRGB(20,20,25); inJP.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", inJP); inJP.FocusLost:Connect(function() _G.JP = tonumber(inJP.Text) end)
AddToggle(pages.P, "Fly 3D", function(v)
    _G.Fly = v
    if v then
        local root = Player.Character.PrimaryPart
        local bv = Instance.new("BodyVelocity", root); bv.Name = "F1"; bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        local bg = Instance.new("BodyGyro", root); bg.Name = "F2"; bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
        task.spawn(function()
            while _G.Fly do bv.Velocity = Camera.CFrame.LookVector * (_G.WS or 50); bg.CFrame = Camera.CFrame; task.wait() end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)
AddToggle(pages.P, "Noclip", function(v) _G.Nc = v end)
AddToggle(pages.P, "Infinite Jump", function(v) _G.IJ = v end)

-- Page: COMBAT
AddToggle(pages.C, "Hitbox Expander", function(v) _G.Hitbox = v end)
AddToggle(pages.C, "Spin Bot", function(v) _G.Spin = v; task.spawn(function() while _G.Spin do if Player.Character then Player.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(50), 0) end task.wait() end end) end)

-- Page: TELEPORT
AddBtn(pages.T, "Server Hop", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/6W_X/ServerHop/main/ServerHop.lua'))() end)
AddBtn(pages.T, "Rejoin", function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end)

-- Page: WORLD
AddToggle(pages.W, "FullBright", function(v) _G.FB = v end)
AddBtn(pages.W, "Set Day (12:00)", function() Lighting.ClockTime = 12 end)
AddBtn(pages.W, "FPS Booster Pro", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
    Lighting.GlobalShadows = false
end)

-- Page: MISC
AddToggle(pages.M, "Anti-AFK", function(v) _G.AntiAFK = v end)
AddBtn(pages.M, "Invisible Mode (FE)", function()
    local char = Player.Character
    local root = char.LowerTorso
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v:Destroy() end
    end
end)
AddBtn(pages.M, "Infinite Yield", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

-- --- LOGO ---
local Logo = Instance.new("TextButton", sg)
Logo.Size = UDim2.new(0, 50, 0, 50); Logo.Position = UDim2.new(0, 20, 0.5, 0)
Logo.Text = "FN"; Logo.BackgroundColor3 = Color3.fromRGB(0, 120, 255); Logo.TextColor3 = Color3.new(1,1,1)
Logo.Font = "GothamBold"; Logo.TextSize = 20; Instance.new("UICorner", Logo).CornerRadius = UDim.new(1,0)
MakeDraggable(Logo)
Logo.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- --- HEARTBEAT ENGINE ---
RunService.Heartbeat:Connect(function()
    pcall(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            if _G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
            if _G.JP then Player.Character.Humanoid.JumpPower = _G.JP; Player.Character.Humanoid.UseJumpPower = true end
            if _G.Nc then for _,v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            if _G.Hitbox then
                for _,p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character then p.Character.HumanoidRootPart.Size = Vector3.new(15,15,15); p.Character.HumanoidRootPart.Transparency = 0.7 end
                end
            end
        end
        if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1); Lighting.Brightness = 2 end
    end)
end)

UIS.JumpRequest:Connect(function() if _G.IJ and Player.Character then Player.Character.Humanoid:ChangeState(3) end end)alse end end end
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
