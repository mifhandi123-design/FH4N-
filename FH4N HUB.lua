-- [[ FH4N HUB V.59 - BIG ESP & FULL FUNCTION ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.FH4N = {
    WS = 16, JP = 50, Nc = false, Fly = false, 
    InfOx = false, Hitbox = false, Freecam = false,
    ESP_Player = false, ESP_Fish = false, ESP_Brainrot = false,
    RTX = false, FB = false, MaxZoom = 128
}

-- UI Setup
local UI_PARENT = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
if UI_PARENT:FindFirstChild("FH4N_V59") then UI_PARENT.FH4N_V59:Destroy() end
local sg = Instance.new("ScreenGui", UI_PARENT); sg.Name = "FH4N_V59"; sg.ResetOnSpawn = false

local function Drag(f)
    local d, s, p
    f.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then d = true; s = inp.Position; p = f.Position end end)
    UIS.InputChanged:Connect(function(inp) if d and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then local delta = inp.Position - s; f.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then d = false end end)
end

-- --- MAIN PANEL ---
local Main = Instance.new("ImageLabel", sg)
Main.Size = UDim2.new(0, 560, 0, 440); Main.Position = UDim2.new(0.5, -280, 0.5, -220)
Main.Image = "rbxassetid://6073747271"; Main.ScaleType = "Crop"
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Main.Active = true; Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15); Drag(Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 200, 255)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Color3.new(0,0,0); Sidebar.BackgroundTransparency = 0.6; Instance.new("UICorner", Sidebar)
local Container = Instance.new("Frame", Main); Container.Position = UDim2.new(0, 150, 0, 10); Container.Size = UDim2.new(1, -160, 1, -20); Container.BackgroundTransparency = 1

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Container); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 3; p.AutomaticCanvasSize = "Y"
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
end
local pg = { P = CreatePage("P"), C = CreatePage("C"), V = CreatePage("V"), Cam = CreatePage("Cam") }
pg.P.Visible = true

local function Tab(txt, target, order)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(0.85, 0, 0, 38); b.Position = UDim2.new(0.075, 0, 0, 20 + (45 * order)); b.Text = txt; b.BackgroundColor3 = Color3.new(1,1,1); b.BackgroundTransparency = 0.9; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 11; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do v.Visible = false end; target.Visible = true end)
end
local function Toggle(p, txt, key, cb)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(1, -10, 0, 45); f.BackgroundColor3 = Color3.new(1,1,1); f.BackgroundTransparency = 0.9; Instance.new("UICorner", f)
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(1, 0, 1, 0); b.BackgroundTransparency = 1; b.Text = "  " .. txt .. ": OFF"; b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 13; b.TextXAlignment = "Left"
    b.MouseButton1Click:Connect(function()
        _G.FH4N[key] = not _G.FH4N[key]; b.Text = "  " .. txt .. ": " .. (_G.FH4N[key] and "ON" or "OFF"); b.TextColor3 = _G.FH4N[key] and Color3.new(0,1,1) or Color3.new(1,1,1)
        if cb then cb(_G.FH4N[key]) end
    end)
end
local function Input(p, place, key)
    local t = Instance.new("TextBox", p); t.Size = UDim2.new(1, -10, 0, 40); t.PlaceholderText = place; t.Text = ""; t.BackgroundColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 0.85; t.TextColor3 = Color3.new(1,1,1); t.Font = "GothamBold"; Instance.new("UICorner", t)
    t.FocusLost:Connect(function() _G.FH4N[key] = tonumber(t.Text) or t.Text end)
end

Tab("👤 PLAYER", pg.P, 0); Tab("⚔️ COMBAT", pg.C, 1); Tab("👁️ VISUAL", pg.V, 2); Tab("📷 CAMERA", pg.Cam, 3)
Input(pg.P, "Set WalkSpeed", "WS"); Input(pg.P, "Set JumpPower", "JP")
Toggle(pg.P, "Fly 3D", "Fly"); Toggle(pg.P, "Noclip", "Nc")
Toggle(pg.C, "Hitbox Expander", "Hitbox")
Toggle(pg.V, "ESP PLAYER (BIG)", "ESP_Player")
Toggle(pg.V, "ESP FISH/CHEST", "ESP_Fish")
Toggle(pg.V, "ESP BRAINROT", "ESP_Brainrot")
Toggle(pg.V, "RTX ULTRA HD", "RTX")
Toggle(pg.Cam, "PC FREECAM", "Freecam")

-- --- ULTRA ESP SYSTEM ---
local function CreateESP(obj, name, color)
    if obj:FindFirstChild("FH4N_ESP") then 
        obj.FH4N_ESP.TextLabel.TextColor3 = color
        obj.FH4N_ESP.TextLabel.Text = name
        return 
    end
    local bg = Instance.new("BillboardGui", obj); bg.Name = "FH4N_ESP"; bg.AlwaysOnTop = true; bg.Size = UDim2.new(0, 200, 0, 50); bg.ExtentsOffset = Vector3.new(0, 3, 0)
    local tl = Instance.new("TextLabel", bg); tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = name; tl.TextColor3 = color
    tl.Font = "GothamBold"; tl.TextSize = 18; tl.TextStrokeTransparency = 0; tl.TextStrokeColor3 = Color3.new(0,0,0) -- Stroke biar jelas
end

-- --- ENGINE ---
task.spawn(function()
    while task.wait(0.5) do
        if _G.FH4N.ESP_Player then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    CreateESP(p.Character.HumanoidRootPart, p.Name, Color3.fromRGB(0, 255, 127))
                end
            end
        end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Model") then
                local n = v.Name:lower()
                if _G.FH4N.ESP_Fish and (n:find("fish") or n:find("chest") or n:find("ikan")) then
                    CreateESP(v, "💎 " .. v.Name:upper(), Color3.fromRGB(255, 215, 0))
                elseif _G.FH4N.ESP_Brainrot and (n:find("sigma") or n:find("skibidi") or n:find("brainrot")) then
                    CreateESP(v, "💀 " .. v.Name:upper(), Color3.fromRGB(255, 0, 255))
                end
            end
        end
        if not _G.FH4N.ESP_Player and not _G.FH4N.ESP_Fish and not _G.FH4N.ESP_Brainrot then
            for _, v in pairs(workspace:GetDescendants()) do if v.Name == "FH4N_ESP" then v:Destroy() end end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            if not _G.FH4N.Fly and not _G.FH4N.Freecam then char.Humanoid.WalkSpeed = _G.FH4N.WS end
            char.Humanoid.JumpPower = _G.FH4N.JP; char.Humanoid.UseJumpPower = true
            if _G.FH4N.Nc then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            if _G.FH4N.Hitbox then
                for _,p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Size = Vector3.new(10,10,10); p.Character.HumanoidRootPart.Transparency = 0.7
                    end
                end
            end
            if _G.FH4N.Fly then
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                if char.Humanoid.MoveDirection.Magnitude > 0 then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (Camera.CFrame.LookVector * (_G.FH4N.WS/5))
                end
            end
        end
    end)
end)

-- --- LOGO ---
local L = Instance.new("ImageButton", sg); L.Size = UDim2.new(0, 65, 0, 65); L.Position = UDim2.new(0, 15, 0.5, -32); L.Image = "rbxassetid://6073747271"; Instance.new("UICorner", L).CornerRadius = UDim.new(1,0); Drag(L)
local LT = Instance.new("TextLabel", L); LT.Size = UDim2.new(1,0,1,0); LT.BackgroundTransparency = 1; LT.Text = "FN"; LT.TextColor3 = Color3.new(1,1,1); LT.Font = "GothamBold"; LT.TextSize = 22
L.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
