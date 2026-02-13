-- [[ FH4N HUB V.57 - FULL GALAXY BACKGROUND ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Global Config
_G.FH4N = {
    WS = 16, JP = 50, Nc = false, Fly = false, 
    InfOx = false, AutoAim = false, Freecam = false,
    ESP_Player = false, ESP_Fish = false, ESP_Brainrot = false,
    RTX = false, FB = false, MaxZoom = 128
}

-- UI Setup
local UI_PARENT = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
if UI_PARENT:FindFirstChild("FH4N_ULTIMATE") then UI_PARENT.FH4N_ULTIMATE:Destroy() end
local sg = Instance.new("ScreenGui", UI_PARENT); sg.Name = "FH4N_ULTIMATE"; sg.ResetOnSpawn = false

-- --- DRAG SYSTEM ---
local function Drag(f)
    local d, s, p
    f.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then d = true; s = inp.Position; p = f.Position end end)
    UIS.InputChanged:Connect(function(inp) if d and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local delta = inp.Position - s; f.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then d = false end end)
end

-- --- MAIN PANEL (GALAXY BACKGROUND) ---
local Main = Instance.new("ImageLabel", sg)
Main.Name = "Main"
Main.Size = UDim2.new(0, 550, 0, 420)
Main.Position = UDim2.new(0.5, -275, 0.5, -210)
Main.Image = "rbxassetid://6073747271" -- HD Galaxy Texture
Main.ScaleType = Enum.ScaleType.Crop
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
Drag(Main)

-- Efek Glass/Blur Overlay
local Overlay = Instance.new("Frame", Main)
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.4
Instance.new("UICorner", Overlay).CornerRadius = UDim.new(0, 15)

-- Stroke Border Neon
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 200, 255)
Stroke.Thickness = 2.5
Stroke.Transparency = 0.3

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Sidebar.BackgroundTransparency = 0.5
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 15)

-- Container
local Container = Instance.new("Frame", Main)
Container.Position = UDim2.new(0, 150, 0, 45)
Container.Size = UDim2.new(1, -160, 1, -60)
Container.BackgroundTransparency = 1

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -150, 0, 40)
Title.Position = UDim2.new(0, 150, 0, 5)
Title.Text = "FH4N HUB | V.57 GALAXY"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = "GothamBold"
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Container)
    p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 2
    p.CanvasSize = UDim2.new(0, 0, 0, 0); p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    return p
end

local pg = { P = CreatePage("P"), C = CreatePage("C"), V = CreatePage("V"), Cam = CreatePage("Cam"), T = CreatePage("T") }
pg.P.Visible = true

-- --- TAB & TOGGLE BUILDER (MODERN STYLE) ---
local function Tab(txt, target, order)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0.85, 0, 0, 35)
    b.Position = UDim2.new(0.075, 0, 0, 100 + (42 * order))
    b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundTransparency = 0.9; b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = "GothamBold"; b.TextSize = 11; Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do v.Visible = false end
        target.Visible = true
    end)
end

local function Toggle(p, txt, key, cb)
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(1, -10, 0, 40); f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    f.BackgroundTransparency = 0.9; Instance.new("UICorner", f)
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(1, 0, 1, 0); b.BackgroundTransparency = 1
    b.Text = "  " .. txt .. ": OFF"; b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = "GothamMedium"; b.TextSize = 13; b.TextXAlignment = Enum.TextXAlignment.Left
    
    b.MouseButton1Click:Connect(function()
        _G.FH4N[key] = not _G.FH4N[key]
        b.Text = "  " .. txt .. ": " .. (_G.FH4N[key] and "ON" or "OFF")
        b.TextColor3 = _G.FH4N[key] and Color3.fromRGB(0, 255, 255) or Color3.new(1, 1, 1)
        if cb then cb(_G.FH4N[key]) end
    end)
end

-- --- NAVIGATION ---
Tab("👤 PLAYER", pg.P, 0); Tab("⚔️ COMBAT", pg.C, 1); Tab("👁️ VISUAL", pg.V, 2); Tab("📷 CAMERA", pg.Cam, 3)

-- --- LOGO (GALAXY BUTTON) ---
local L = Instance.new("ImageButton", sg)
L.Size = UDim2.new(0, 65, 0, 65)
L.Position = UDim2.new(0, 15, 0.5, -32)
L.Image = "rbxassetid://6073747271"
L.BackgroundColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", L).Color = Color3.fromRGB(0, 200, 255)
Drag(L)

local LT = Instance.new("TextLabel", L)
LT.Size = UDim2.new(1, 0, 1, 0); LT.BackgroundTransparency = 1
LT.Text = "FN"; LT.TextColor3 = Color3.new(1, 1, 1)
LT.Font = "GothamBold"; LT.TextSize = 22

L.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- --- FEATURES ---
Toggle(pg.P, "Fly 3D", "Fly")
Toggle(pg.V, "ESP Player", "ESP_Player")
Toggle(pg.V, "RTX Mode", "RTX")
Toggle(pg.Cam, "PC Freecam", "Freecam")

-- --- LOOP ENGINE (STABLE) ---
RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if _G.FH4N.Fly then
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                if char.Humanoid.MoveDirection.Magnitude > 0 then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (Camera.CFrame.LookVector * (tonumber(_G.FH4N.WS)/5))
                end
            end
        end
    end)
end)

print("FH4N HUB V.57 GALAXY LOADED!")
