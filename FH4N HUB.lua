-- [[ FH4N HUB V.51 - FINAL INTEGRATION ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Global Config
_G.FH4N = {
    WS = 16, JP = 50, IJ = false, Nc = false, 
    Fly = false, FB = false, Hitbox = false, 
    Freecam = false, MaxZoom = 128, Adidas = false,
    InfOx = false, AutoAim = false,
    ESP_Master = false, FPS_Boost = false,
    TP_Target = "", SV_TP = false
}

-- [[ AUTO ANTI-AFK ]] --
pcall(function()
    for i,v in pairs(getconnections(Player.Idled)) do v:Disable() end
    Player.Idled:Connect(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new(0,0))
    end)
end)

-- UI Setup
local UI_PARENT = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
if UI_PARENT:FindFirstChild("FH4N_V51") then UI_PARENT.FH4N_V51:Destroy() end
local sg = Instance.new("ScreenGui", UI_PARENT); sg.Name = "FH4N_V51"; sg.ResetOnSpawn = false

-- --- DRAG SYSTEM ---
local function Drag(f)
    local d, s, p
    f.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then d = true; s = inp.Position; p = f.Position end end)
    UIS.InputChanged:Connect(function(inp) if d and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local delta = inp.Position - s; f.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then d = false end end)
end

-- --- MAIN PANEL ---
local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 520, 0, 420); Main.Position = UDim2.new(0.5, -260, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Main.BorderSizePixel = 0; Instance.new("UICorner", Main); Drag(Main)
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Instance.new("UICorner", Sidebar)
local Container = Instance.new("Frame", Main); Container.Position = UDim2.new(0, 135, 0, 10); Container.Size = UDim2.new(1, -145, 1, -20); Container.BackgroundTransparency = 1

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Container); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0, 0, 5, 0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5); return p
end

local pg = { P = CreatePage("P"), C = CreatePage("C"), V = CreatePage("V"), T = CreatePage("T"), M = CreatePage("M") }
pg.P.Visible = true

-- --- UI BUILDERS ---
local function Tab(txt, target, order)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, 10 + (36 * order)); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.TextColor3 = Color3.new(1, 1, 1); b.Font = "GothamBold"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do v.Visible = false end; target.Visible = true end)
end

local function Toggle(p, txt, key, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt .. ": OFF"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() _G.FH4N[key] = not _G.FH4N[key]; b.BackgroundColor3 = _G.FH4N[key] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(25, 25, 30); b.Text = txt .. ": " .. (_G.FH4N[key] and "ON" or "OFF"); if cb then cb(_G.FH4N[key]) end end)
end

local function Input(p, place, key)
    local t = Instance.new("TextBox", p); t.Size = UDim2.new(1, -10, 0, 35); t.PlaceholderText = place; t.Text = ""; t.BackgroundColor3 = Color3.fromRGB(20, 20, 25); t.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", t)
    t.FocusLost:Connect(function() _G.FH4N[key] = tonumber(t.Text) or t.Text end)
end

-- --- NAVIGATION ---
Tab("👤 PLAYER", pg.P, 0); Tab("⚔️ COMBAT", pg.C, 1); Tab("👁️ VISUAL/ESP", pg.V, 2); Tab("🌀 TELEPORT", pg.T, 3); Tab("⚙️ MISC", pg.M, 4)

-- PLAYER CONTENT
Input(pg.P, "WalkSpeed", "WS")
Toggle(pg.P, "Infinite Oxygen", "InfOx")
Toggle(pg.P, "Adidas Animation", "Adidas", function(v)
    if v then pcall(function()
        local char = Player.Character
        char.Animate.idle.Animation1.AnimationId = "rbxassetid://180435571"
        char.Animate.walk.WalkAnim.AnimationId = "rbxassetid://180435727"
        char.Humanoid:ChangeState(15)
    end) end
end)
Toggle(pg.P, "Fly 3D Mode", "Fly")
Toggle(pg.P, "Noclip", "Nc")

-- COMBAT CONTENT
Toggle(pg.C, "Auto Aim Lock", "AutoAim")
Toggle(pg.C, "Hitbox Expander", "Hitbox")

-- VISUAL CONTENT
Toggle(pg.V, "Master ESP (All)", "ESP_Master")
Toggle(pg.V, "FullBright", "FB")
Toggle(pg.V, "FPS Booster", "FPS_Boost", function(v)
    if v then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic
            elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1 end
        end
        Lighting.GlobalShadows = false
    end
end)

-- TELEPORT CONTENT
Toggle(pg.T, "Safe SV Mode", "SV_TP")
Input(pg.T, "Nama Player", "TP_Target")
local tpBtn = Instance.new("TextButton", pg.T); tpBtn.Size = UDim2.new(1, -10, 0, 35); tpBtn.Text = "Teleport Target"; tpBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50); tpBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tpBtn)
tpBtn.MouseButton1Click:Connect(function()
    local t = tostring(_G.FH4N.TP_Target):lower()
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= Player and p.Name:lower():find(t) and p.Character then
            Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * (_G.FH4N.SV_TP and CFrame.new(0,3,0) or CFrame.new(0,0,0))
        end
    end
end)

-- --- ESP SYSTEM ---
local function CreateESP(obj, name, color)
    if obj:FindFirstChild("FH4N_ESP") then return end
    local bg = Instance.new("BillboardGui", obj); bg.Name = "FH4N_ESP"; bg.AlwaysOnTop = true; bg.Size = UDim2.new(0, 100, 0, 50); bg.ExtentsOffset = Vector3.new(0, 3, 0)
    local tl = Instance.new("TextLabel", bg); tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = name; tl.TextColor3 = color; tl.Font = "GothamBold"; tl.TextSize = 11; tl.TextStrokeTransparency = 0
end

-- --- CORE LOOP ---
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            if not _G.FH4N.Fly then char.Humanoid.WalkSpeed = tonumber(_G.FH4N.WS) or 16 end
            if _G.FH4N.Nc then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            if _G.FH4N.InfOx then char.Humanoid.AirCapacity = 100 end
            
            if _G.FH4N.Fly then
                char.HumanoidRootPart.Velocity = Vector3.new(0,0.1,0)
                if char.Humanoid.MoveDirection.Magnitude > 0 then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (Camera.CFrame.LookVector * (char.Humanoid.WalkSpeed/5))
                end
            end
            
            if _G.FH4N.ESP_Master then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character then CreateESP(p.Character.HumanoidRootPart, p.Name, Color3.new(0,1,0)) end
                end
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name:lower():find("chest") or v.Name:lower():find("brainrot")) then
                        CreateESP(v, v.Name, Color3.new(1,0.5,0))
                    end
                end
            else
                for _, v in pairs(workspace:GetDescendants()) do if v.Name == "FH4N_ESP" then v:Destroy() end end
            end
        end
        if _G.FH4N.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.Brightness = 2 end
    end)
end)

-- --- LOGO SYSTEM (ZArchiver / File Support) ---
local LogoFile = "fh4n_logo.png"
local L = Instance.new("ImageButton", sg); L.Size = UDim2.new(0, 55, 0, 55); L.Position = UDim2.new(0, 10, 0.5, 0); L.BackgroundColor3 = Color3.fromRGB(0, 120, 255); L.BorderSizePixel = 0; Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0); Drag(L)

local function LoadLogo()
    if isfile and readfile and isfile(LogoFile) then
        L.Image = getcustomasset(LogoFile)
    else
        L.Image = ""
        local t = Instance.new("TextLabel", L); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.Text = "FN"; t.TextColor3 = Color3.new(1,1,1); t.Font = "GothamBold"; t.TextSize = 20
    end
end
LoadLogo()
L.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
