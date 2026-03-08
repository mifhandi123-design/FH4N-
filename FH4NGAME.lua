-- [[ FH4N HUB - V.550 FULL STABLE FIX ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.FH4N_V550 = {
    WS = 16, JP = 50, InfJump = false, Nc = false, 
    Fly = false, FlySpeed = 50, 
    AutoAnswer = false, Esp = false, GodMode = false,
    BGColor = Color3.fromRGB(12, 12, 15),
    StrokeColor = Color3.fromRGB(0, 255, 150),
    Brightness = 1,
    TargetPlayer = "",
    SavedPos = {},
    Configs = {}
}

-- [[ 🛡️ ANTI-AFK: PERMANENT ]] --
local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)

-- --- UI RENDERER ---
local target = (game:GetService("CoreGui") or Player:WaitForChild("PlayerGui"))
if target:FindFirstChild("FH4N_V550") then target["FH4N_V550"]:Destroy() end
local sg = Instance.new("ScreenGui", target); sg.Name = "FH4N_V550"

local function Drag(f)
    local d, s, p; f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = i.Position; p = f.Position end end)
    UIS.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - s; f.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
end

local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 580, 0, 520); Main.Position = UDim2.new(0.5, -290, 0.5, -260); Main.BackgroundColor3 = _G.FH4N_V550.BGColor; Main.Active = true; Drag(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15); local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 2; Stroke.Color = _G.FH4N_V550.StrokeColor

-- [ TAB & CONTENT SYSTEM ]
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 0, 350); Sidebar.Position = UDim2.new(0, 10, 0, 60); Sidebar.BackgroundTransparency = 1
local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -160, 1, -140); Container.Position = UDim2.new(0, 150, 0, 60); Container.BackgroundTransparency = 1

local function AddPage()
    local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.ScrollBarThickness = 0; p.AutomaticCanvasSize = "Y"
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
end
local pg1, pg2, pg3, pg4 = AddPage(), AddPage(), AddPage(), AddPage(); pg1.Visible = true

local function Tab(t, p, o)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 40); b.Position = UDim2.new(0, 0, 0, o * 45); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; p.Visible = true end)
end
Tab("👤 PLAYER", pg1, 0); Tab("🎣 FARM", pg2, 1); Tab("🌀 TELEPORT", pg3, 2); Tab("⚙️ SETTINGS", pg4, 3)

local function Toggle(p, txt, key)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1, -10, 0, 40); b.Text = "  "..txt..": OFF"; b.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b.TextColor3 = Color3.new(1,1,1); b.TextXAlignment = "Left"; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() _G.FH4N_V550[key] = not _G.FH4N_V550[key]; b.Text = "  "..txt..": "..(_G.FH4N_V550[key] and "ON" or "OFF"); b.TextColor3 = _G.FH4N_V550[key] and Color3.new(0,1,0.5) or Color3.new(1,1,1) end)
end
local function Input(p, pl, key)
    local i = Instance.new("TextBox", p); i.Size = UDim2.new(1, -10, 0, 40); i.PlaceholderText = pl; i.Text = ""; i.BackgroundColor3 = Color3.fromRGB(20, 20, 25); i.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", i)
    i.FocusLost:Connect(function() _G.FH4N_V550[key] = tonumber(i.Text) or i.Text end)
end

-- --- PAGE 1: PLAYER ---
Toggle(pg1, "God Mode", "GodMode"); Toggle(pg1, "Fly Mode", "Fly"); Toggle(pg1, "Noclip", "Nc"); Toggle(pg1, "Inf Jump", "InfJump"); Toggle(pg1, "ESP Player", "Esp")
Input(pg1, "WalkSpeed", "WS"); Input(pg1, "JumpPower", "JP")

-- --- PAGE 4: SV SETINGAN ---
local cl = Instance.new("TextLabel", pg4); cl.Size = UDim2.new(1,0,0,20); cl.Text = "💾 SV SETINGAN (CONFIG)"; cl.TextColor3 = Color3.new(1,1,0); cl.BackgroundTransparency = 1
for i = 1, 3 do
    local f = Instance.new("Frame", pg4); f.Size = UDim2.new(1,-10,0,40); f.BackgroundTransparency = 1
    local s = Instance.new("TextButton", f); s.Size = UDim2.new(0.48,0,1,0); s.Text = "SAVE "..i; s.BackgroundColor3 = Color3.fromRGB(0, 80, 200); s.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner",s)
    local l = Instance.new("TextButton", f); l.Position = UDim2.new(0.52,0,0,0); l.Size = UDim2.new(0.48,0,1,0); l.Text = "LOAD "..i; l.BackgroundColor3 = Color3.fromRGB(100, 50, 150); l.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner",l)
    s.MouseButton1Click:Connect(function() _G.FH4N_V550.Configs[i] = {WS=_G.FH4N_V550.WS, JP=_G.FH4N_V550.JP, BC=_G.FH4N_V550.BGColor, SC=_G.FH4N_V550.StrokeColor, BR=_G.FH4N_V550.Brightness}; s.Text = "OK!" task.wait(0.5) s.Text = "SAVE "..i end)
    l.MouseButton1Click:Connect(function() local d = _G.FH4N_V550.Configs[i] if d then _G.FH4N_V550.WS=d.WS; _G.FH4N_V550.JP=d.JP; _G.FH4N_V550.BGColor=d.BC; _G.FH4N_V550.StrokeColor=d.SC; _G.FH4N_V550.Brightness=d.BR; l.Text = "LOADED!" end task.wait(0.5) l.Text = "LOAD "..i end)
end

-- --- CORE LOOP: SANGAT STABIL ---
RunService.Stepped:Connect(function()
    pcall(function()
        local char = Player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            -- UI Updates
            Main.BackgroundColor3 = _G.FH4N_V550.BGColor
            Stroke.Color = _G.FH4N_V550.StrokeColor
            Main.BackgroundTransparency = 1 - (math.clamp(tonumber(_G.FH4N_V550.Brightness) or 1, 0.5, 10) / 10)
            
            -- Player Mods
            if hum then
                hum.WalkSpeed = _G.FH4N_V550.WS
                hum.JumpPower = _G.FH4N_V550.JP
                if _G.FH4N_V550.GodMode then hum.MaxHealth = 1e9; hum.Health = 1e9 end
            end
            
            -- Fly & Noclip
            if _G.FH4N_V550.Nc then
                for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
            
            if _G.FH4N_V550.Fly and hrp then
                hrp.Velocity = Vector3.new(0,0,0)
                if hum.MoveDirection.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (Camera.CFrame.LookVector * (_G.FH4N_V550.FlySpeed / 50))
                end
            end
        end
    end)
end)

-- LOGO & TOGGLE
local L = Instance.new("ImageButton", sg); L.Size = UDim2.new(0, 70, 0, 70); L.Position = UDim2.new(0, 20, 0.5, -35); L.Image = "rbxassetid://6073747271"; L.ZIndex = 9999; Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0); Drag(L)
L.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)ath.clamp(tonumber(_G.FH4N_V490.Brightness) or 1, 0.5, 10) / 10)
        if _G.FH4N_V490.Nc then for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if _G.FH4N_V490.Fly then c.HumanoidRootPart.Velocity = Vector3.new(0,0,0); if h.MoveDirection.Magnitude > 0 then c.HumanoidRootPart.CFrame += (Camera.CFrame.LookVector * (_G.FH4N_V490.FlySpeed/10)) end end
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character then
                local b = v.Character:FindFirstChild("FH4N_ESP")
                if _G.FH4N_V490.Esp then if not b then CreateESP(v) else b.Visible = true; b.Color3 = _G.FH4N_V490.StrokeColor end
                elseif b then b.Visible = false end
            end
        end
    end)
end)

local L = Instance.new("ImageButton", sg); L.Size = UDim2.new(0, 70, 0, 70); L.Position = UDim2.new(0, 20, 0.5, -35); L.Image = "rbxassetid://6073747271"; L.ZIndex = 9999; Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0); Drag(L)
L.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
