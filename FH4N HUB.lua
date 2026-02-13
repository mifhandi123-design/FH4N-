-- [[ FH4N HUB V.61 - THE FINAL RECLAMATION ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Database Master (Semua Fitur Ada di Sini)
_G.FH4N = {
    WS = 16, JP = 50, Nc = false, Fly = false, 
    InfOx = false, Hitbox = false, Freecam = false,
    ESP_Player = false, ESP_Fish = false, ESP_Brainrot = false,
    RTX = false, AutoAim = false, MaxZoom = 128
}

-- [[ ANTI-AFK SYSTEM ]] --
pcall(function()
    for i,v in pairs(getconnections(Player.Idled)) do v:Disable() end
    Player.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- UI Setup
local UI_PARENT = (game:GetService("CoreGui") or Player:WaitForChild("PlayerGui"))
if UI_PARENT:FindFirstChild("FH4N_V61") then UI_PARENT.FH4N_V61:Destroy() end
local sg = Instance.new("ScreenGui", UI_PARENT); sg.Name = "FH4N_V61"; sg.ResetOnSpawn = false

local function Drag(f)
    local d, s, p
    f.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then d = true; s = inp.Position; p = f.Position end end)
    UIS.InputChanged:Connect(function(inp) if d and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local delta = inp.Position - s; f.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then d = false end end)
end

-- --- MAIN PANEL ---
local Main = Instance.new("ImageLabel", sg)
Main.Size = UDim2.new(0, 580, 0, 460); Main.Position = UDim2.new(0.5, -290, 0.5, -230)
Main.Image = "rbxassetid://6073747271"; Main.ScaleType = "Crop"; Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.Active = true; Main.BorderSizePixel = 0; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15); Drag(Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 200, 255)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 150, 1, 0); Sidebar.BackgroundColor3 = Color3.new(0,0,0); Sidebar.BackgroundTransparency = 0.5; Instance.new("UICorner", Sidebar)
local Container = Instance.new("Frame", Main); Container.Position = UDim2.new(0, 160, 0, 10); Container.Size = UDim2.new(1, -170, 1, -20); Container.BackgroundTransparency = 1

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Container); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 4
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y -- FIX: Biar fitur gak hilang kebawah
    local list = Instance.new("UIListLayout", p); list.Padding = UDim.new(0, 8); return p
end
local pg = { P = CreatePage("P"), C = CreatePage("C"), V = CreatePage("V"), Cam = CreatePage("Cam") }
pg.P.Visible = true

local function Tab(txt, target, order)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(0.9, 0, 0, 40); b.Position = UDim2.new(0.05, 0, 0, 20 + (45 * order))
    b.Text = txt; b.BackgroundColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 0.9; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 11; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do v.Visible = false end; target.Visible = true end)
end

local function Toggle(p, txt, key, cb)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(1, -15, 0, 45); f.BackgroundColor3 = Color3.new(1,1,1); f.BackgroundTransparency = 0.9; Instance.new("UICorner", f)
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(1, 0, 1, 0); b.BackgroundTransparency = 1; b.Text = "  " .. txt .. ": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 12; b.TextXAlignment = "Left"
    b.MouseButton1Click:Connect(function()
        _G.FH4N[key] = not _G.FH4N[key]; b.Text = "  " .. txt .. ": " .. (_G.FH4N[key] and "ON" or "OFF")
        b.TextColor3 = _G.FH4N[key] and Color3.new(0,1,1) or Color3.new(1,1,1)
        if cb then cb(_G.FH4N[key]) end
    end)
end

local function Input(p, place, key)
    local t = Instance.new("TextBox", p); t.Size = UDim2.new(1, -15, 0, 40); t.PlaceholderText = place; t.Text = ""; t.BackgroundColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 0.85; t.TextColor3 = Color3.new(1,1,1); t.Font = "GothamBold"; Instance.new("UICorner", t)
    t.FocusLost:Connect(function() _G.FH4N[key] = tonumber(t.Text) or t.Text end)
end

-- --- FILLING THE PAGES (NO FEATURES LEFT BEHIND) ---
Tab("👤 PLAYER", pg.P, 0); Tab("⚔️ COMBAT", pg.C, 1); Tab("👁️ VISUAL", pg.V, 2); Tab("📷 CAMERA", pg.Cam, 3)

-- PLAYER PAGE
Input(pg.P, "Speed [Default 16]", "WS")
Input(pg.P, "Jump [Default 50]", "JP")
Toggle(pg.P, "Fly Mode", "Fly")
Toggle(pg.P, "Noclip (Wall)", "Nc")
Toggle(pg.P, "Infinite Oxygen", "InfOx")

-- COMBAT PAGE
Toggle(pg.C, "Big Hitbox (All)", "Hitbox")
Toggle(pg.C, "Auto Aim Lock", "AutoAim")

-- VISUAL PAGE (ULTRA BIG ESP)
Toggle(pg.V, "ESP Player", "ESP_Player")
Toggle(pg.V, "ESP Fish & Chest", "ESP_Fish")
Toggle(pg.V, "ESP Brainrot", "ESP_Brainrot")
Toggle(pg.V, "RTX HDR Grafik", "RTX")

-- CAMERA PAGE
Toggle(pg.Cam, "PC Style Freecam", "Freecam")
Input(pg.Cam, "Max Zoom Distance", "MaxZoom")

-- --- THE ENGINE (POWERFUL & STABLE) ---
local upV, downV = 0, 0
local function ApplyESP(obj, name, col)
    if not obj:FindFirstChild("FH4N_ESP") then
        local bg = Instance.new("BillboardGui", obj); bg.Name = "FH4N_ESP"; bg.AlwaysOnTop = true; bg.Size = UDim2.new(0, 200, 0, 50); bg.ExtentsOffset = Vector3.new(0, 3, 0)
        local tl = Instance.new("TextLabel", bg); tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = name:upper(); tl.TextColor3 = col
        tl.Font = "GothamBold"; tl.TextSize = 24; tl.TextStrokeTransparency = 0; tl.TextStrokeColor3 = Color3.new(0,0,0)
    end
end

RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            local hrp = char.HumanoidRootPart
            if not _G.FH4N.Fly and not _G.FH4N.Freecam then hum.WalkSpeed = _G.FH4N.WS end
            hum.JumpPower = _G.FH4N.JP; hum.UseJumpPower = true
            Player.CameraMaxZoomDistance = _G.FH4N.MaxZoom
            
            if _G.FH4N.Nc then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            if _G.FH4N.InfOx then hum.AirCapacity = 100 end
            
            if _G.FH4N.Fly then
                hrp.Velocity = Vector3.new(0,0,0)
                if hum.MoveDirection.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * (_G.FH4N.WS/6))
                end
            end
            
            if _G.FH4N.Hitbox then
                for _,p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Size = Vector3.new(12,12,12); p.Character.HumanoidRootPart.Transparency = 0.7
                    end
                end
            end
        end
    end)
end)

-- ESP SCANNER (BIGGER & BRIGHTER)
task.spawn(function()
    while task.wait(0.5) do
        if _G.FH4N.ESP_Player or _G.FH4N.ESP_Fish or _G.FH4N.ESP_Brainrot then
            if _G.FH4N.ESP_Player then
                for _,p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character then ApplyESP(p.Character.HumanoidRootPart, p.Name, Color3.new(0,1,0.5)) end
                end
            end
            for _,v in pairs(workspace:GetDescendants()) do
                local n = v.Name:lower()
                if _G.FH4N.ESP_Fish and (n:find("fish") or n:find("chest")) then ApplyESP(v, "💎 "..v.Name, Color3.new(1,0.8,0))
                elseif _G.FH4N.ESP_Brainrot and (n:find("sigma") or n:find("skibidi")) then ApplyESP(v, "💀 "..v.Name, Color3.new(1,0,1)) end
            end
        else
            for _,v in pairs(workspace:GetDescendants()) do if v.Name == "FH4N_ESP" then v:Destroy() end end
        end
    end
end)

-- --- LOGO ---
local L = Instance.new("ImageButton", sg); L.Size = UDim2.new(0, 70, 0, 70); L.Position = UDim2.new(0, 20, 0.5, -35); L.Image = "rbxassetid://6073747271"; Instance.new("UICorner", L).CornerRadius = UDim.new(1,0); Drag(L)
local LT = Instance.new("TextLabel", L); LT.Size = UDim2.new(1,0,1,0); LT.BackgroundTransparency = 1; LT.Text = "FN"; LT.TextColor3 = Color3.new(1,1,1); LT.Font = "GothamBold"; LT.TextSize = 25
L.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

print("FH4N HUB V.61 - TOTAL ECLIPSE LOADED!")
