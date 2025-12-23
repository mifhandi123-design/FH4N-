-- [[ FH4N HUB V.42 - ADIDAS ANIMATION UPDATE ]] --
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
    ESP = false, AntiAFK = true, Spin = false,
    Freecam = false, MaxZoom = 128, Adidas = false
}

-- Anti-AFK
Player.Idled:Connect(function()
    if _G.FH4N.AntiAFK then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new(0,0))
    end
end)

-- UI Setup
local UI_PARENT = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
if UI_PARENT:FindFirstChild("FH4N_V42") then UI_PARENT.FH4N_V42:Destroy() end
local sg = Instance.new("ScreenGui", UI_PARENT); sg.Name = "FH4N_V42"

-- --- DRAG SYSTEM ---
local function Drag(f)
    local d, s, p
    f.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            d = true; s = inp.Position; p = f.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if d and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - s
            f.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then d = false end end)
end

-- --- MAIN PANEL ---
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 520, 0, 400); Main.Position = UDim2.new(0.5, -260, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Main.Visible = true; Main.BorderSizePixel = 0
Instance.new("UICorner", Main); Drag(Main)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Instance.new("UICorner", Sidebar)
local Container = Instance.new("Frame", Main); Container.Position = UDim2.new(0, 135, 0, 10); Container.Size = UDim2.new(1, -145, 1, -20); Container.BackgroundTransparency = 1

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Container); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0, 0, 4, 0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5); return p
end

local pages = { P = CreatePage("Player"), C = CreatePage("Combat"), Cam = CreatePage("Camera"), T = CreatePage("TP"), M = CreatePage("Misc") }
pages.P.Visible = true

-- --- UI BUILDERS ---
local function Tab(txt, target, order)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, 10 + (36 * order))
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.TextColor3 = Color3.new(1, 1, 1); b.Font = "GothamBold"; b.TextSize = 10
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do v.Visible = false end; target.Visible = true end)
end

local function Toggle(p, txt, key, callback)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G.FH4N[key] = not _G.FH4N[key]
        b.BackgroundColor3 = _G.FH4N[key] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(25, 25, 30)
        b.Text = txt .. ": " .. (_G.FH4N[key] and "ON" or "OFF")
        if callback then callback(_G.FH4N[key]) end
    end)
end

local function Input(p, place, key)
    local t = Instance.new("TextBox", p); t.Size = UDim2.new(1, -10, 0, 35); t.PlaceholderText = place; t.Text = ""
    t.BackgroundColor3 = Color3.fromRGB(20, 20, 25); t.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", t)
    t.FocusLost:Connect(function() _G.FH4N[key] = tonumber(t.Text) or _G.FH4N[key] end)
end

local function Btn(p, txt, cb)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- --- CONTENT SETUP ---
Tab("PLAYER", pages.P, 0); Tab("COMBAT", pages.C, 1); Tab("CAMERA", pages.Cam, 2); Tab("TELEPORT", pages.T, 3); Tab("MISC", pages.M, 4)

-- PLAYER TAB
Input(pages.P, "WalkSpeed", "WS")
Input(pages.P, "JumpPower", "JP")
Toggle(pages.P, "Fly 3D Analog", "Fly", function(v)
    if v then
        task.spawn(function()
            local r = Player.Character:WaitForChild("HumanoidRootPart")
            local h = Player.Character:WaitForChild("Humanoid")
            local bv = Instance.new("BodyVelocity", r); bv.MaxForce = Vector3.new(1e6,1e6,1e6)
            local bg = Instance.new("BodyGyro", r); bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
            while _G.FH4N.Fly do
                bg.CFrame = Camera.CFrame
                bv.Velocity = (h.MoveDirection.Magnitude > 0) and (Camera.CFrame.LookVector * _G.FH4N.WS) or Vector3.new(0,0.1,0)
                task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)
Toggle(pages.P, "Adidas Animation", "Adidas", function(v)
    if v then
        -- Adidas Animation Script Logic
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GamerScripter/Adidas-Anim/main/Script.lua"))()
    end
end)
Toggle(pages.P, "Noclip", "Nc")
Toggle(pages.P, "Infinite Jump", "IJ")

-- COMBAT & CAMERA & OTHERS
Toggle(pages.C, "Hitbox Expander", "Hitbox")
Toggle(pages.Cam, "Freecam (Analog Move)", "Freecam", function(v)
    if v then
        local p = Instance.new("Part", workspace); p.Size = Vector3.new(1,1,1); p.Transparency = 1; p.Anchored = true; p.CanCollide = false
        p.CFrame = Camera.CFrame; Camera.CameraSubject = p
        task.spawn(function()
            while _G.FH4N.Freecam do
                p.CFrame *= CFrame.new(Player.Character.Humanoid.MoveDirection * 2)
                task.wait()
            end
            Camera.CameraSubject = Player.Character.Humanoid; p:Destroy()
        end)
    end
end)
Input(pages.Cam, "Max Zoom Distance", "MaxZoom")
Toggle(pages.Cam, "FullBright", "FB")
Input(pages.T, "TP Player Name", "TP_Target")
Btn(pages.M, "Infinite Yield", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

-- --- LOGO ---
local L = Instance.new("TextButton", sg); L.Size = UDim2.new(0, 55, 0, 55); L.Position = UDim2.new(0, 15, 0.5, 0)
L.Text = "FN"; L.BackgroundColor3 = Color3.fromRGB(0, 120, 255); L.TextColor3 = Color3.new(1, 1, 1); L.Font = "GothamBold"; L.TextSize = 22
Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0); Drag(L)
L.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- --- HEARTBEAT ENGINE ---
RunService.Heartbeat:Connect(function()
    pcall(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local hum = Player.Character.Humanoid
            if not _G.FH4N.Fly then hum.WalkSpeed = _G.FH4N.WS end
            hum.JumpPower = _G.FH4N.JP; hum.UseJumpPower = true
            Player.Character.MaxZoomDistance = _G.FH4N.MaxZoom
            if _G.FH4N.Nc then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            if _G.FH4N.Hitbox then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character then p.Character.HumanoidRootPart.Size = Vector3.new(15, 15, 15); p.Character.HumanoidRootPart.Transparency = 0.7 end
                end
            end
        end
        if _G.FH4N.FB then Lighting.Ambient = Color3.new(1, 1, 1); Lighting.Brightness = 2 end
    end)
end)

UIS.JumpRequest:Connect(function() if _G.FH4N.IJ and Player.Character then Player.Character.Humanoid:ChangeState(3) end end)

task.spawn(function()
    while task.wait(0.5) do
        if _G.FH4N.TP_Target and _G.FH4N.TP_Target ~= "" then
            local t = _G.FH4N.TP_Target:lower()
            for _,p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Name:lower():find(t) and p.Character then
                    Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                    _G.FH4N.TP_Target = ""
                end
            end
        end
    end
end)
