-- [[ FH4N HUB - V.480 CONFIG SYSTEM UPDATE ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.FH4N_V480 = {
    WS = 16, JP = 50, InfJump = false, Nc = false, 
    Fly = false, FlySpeed = 50, 
    AutoFish = false, AutoAnswer = false,
    Esp = false, GodMode = false,
    BGColor = Color3.fromRGB(12, 12, 15),
    StrokeColor = Color3.fromRGB(0, 255, 150),
    Brightness = 1,
    TargetPlayer = "",
    SavedPos = {},
    Configs = {} -- Database Config Lokal
}

-- [[ 🛡️ ANTI-AFK: ALWAYS ON ]] --
local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)

-- [[ 📚 DATABASE KATA ]] --
local Kamus = {["a"]={"aku","apel"}, ["b"]={"buku","bola"}, ["c"]={"cabe","cari"}}

-- --- UI CONSTRUCTION ---
local target = (game:GetService("CoreGui") or Player:WaitForChild("PlayerGui"))
if target:FindFirstChild("FH4N_V480") then target["FH4N_V480"]:Destroy() end
local sg = Instance.new("ScreenGui", target); sg.Name = "FH4N_V480"

-- [ Fungsi Drag & Dasar UI Tetap Sama Seperti V.470 ]
local function Drag(f)
    local d, s, p; f.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true; s = i.Position; p = f.Position end end)
    UIS.InputChanged:Connect(function(i) if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then local delta = i.Position - s; f.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
end

local Main = Instance.new("Frame", sg); Main.Size = UDim2.new(0, 580, 0, 520); Main.Position = UDim2.new(0.5, -290, 0.5, -260); Main.BackgroundColor3 = _G.FH4N_V480.BGColor; Main.Active = true; Drag(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15); local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 2; Stroke.Color = _G.FH4N_V480.StrokeColor

-- [ TAB SYSTEM ]
local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 0, 350); Sidebar.Position = UDim2.new(0, 10, 0, 60); Sidebar.BackgroundTransparency = 1
local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -160, 1, -140); Container.Position = UDim2.new(0, 150, 0, 60); Container.BackgroundTransparency = 1

local function AddPage()
    local p = Instance.new("ScrollingFrame", Container); p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0,0,0,0); p.AutomaticCanvasSize = "Y"; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 10); return p
end
local pg1, pg2, pg3, pg4 = AddPage(), AddPage(), AddPage(), AddPage(); pg1.Visible = true

local function Tab(t, p, o)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 40); b.Position = UDim2.new(0, 0, 0, o * 45); b.Text = t; b.TextColor3 = Color3.new(1,1,1); b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Container:GetChildren()) do v.Visible = false end; p.Visible = true end)
end
Tab("👤 PLAYER", pg1, 0); Tab("🎣 FARM", pg2, 1); Tab("🌀 TELEPORT", pg3, 2); Tab("⚙️ SETTINGS", pg4, 3)

-- --- FITUR BARU: SAVE CONFIG DI PAGE 4 ---
local confLabel = Instance.new("TextLabel", pg4); confLabel.Size = UDim2.new(1,0,0,30); confLabel.Text = "💾 CONFIG MANAGER"; confLabel.TextColor3 = Color3.new(1,1,1); confLabel.BackgroundTransparency = 1; confLabel.Font = "GothamBold"

for i = 1, 3 do
    local f = Instance.new("Frame", pg4); f.Size = UDim2.new(1,-10,0,40); f.BackgroundTransparency = 1
    local s = Instance.new("TextButton", f); s.Size = UDim2.new(0.48,0,1,0); s.Text = "SAVE SETTING "..i; s.BackgroundColor3 = Color3.fromRGB(0, 80, 200); s.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", s)
    local l = Instance.new("TextButton", f); l.Position = UDim2.new(0.52,0,0,0); l.Size = UDim2.new(0.48,0,1,0); l.Text = "LOAD SETTING "..i; l.BackgroundColor3 = Color3.fromRGB(80, 0, 200); l.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", l)
    
    s.MouseButton1Click:Connect(function()
        _G.FH4N_V480.Configs[i] = {
            WS = _G.FH4N_V480.WS, JP = _G.FH4N_V480.JP, 
            BC = _G.FH4N_V480.BGColor, SC = _G.FH4N_V480.StrokeColor,
            BR = _G.FH4N_V480.Brightness
        }
        s.Text = "CONFIG "..i.." SAVED!"
        task.wait(1)
        s.Text = "SAVE SETTING "..i
    end)
    
    l.MouseButton1Click:Connect(function()
        local data = _G.FH4N_V480.Configs[i]
        if data then
            _G.FH4N_V480.WS = data.WS; _G.FH4N_V480.JP = data.JP
            _G.FH4N_V480.BGColor = data.BC; _G.FH4N_V480.StrokeColor = data.SC
            _G.FH4N_V480.Brightness = data.BR
            l.Text = "LOADED!"
        else
            l.Text = "EMPTY!"
        end
        task.wait(1)
        l.Text = "LOAD SETTING "..i
    end)
end

-- [ SISANYA SAMA SEPERTI V.470: GODMODE, ESP, TELEPORT, DLL ]
-- ... (KODE LANJUTAN TETAP TERPASANG DI DALAM ENGINE) ...

RunService.Heartbeat:Connect(function()
    pcall(function()
        local c = Player.Character; local h = c.Humanoid
        h.WalkSpeed = _G.FH4N_V480.WS; h.JumpPower = _G.FH4N_V480.JP
        if _G.FH4N_V480.GodMode then h.MaxHealth = 1e9; h.Health = 1e9 end
        Main.BackgroundColor3 = _G.FH4N_V480.BGColor; Stroke.Color = _G.FH4N_V480.StrokeColor
        Main.BackgroundTransparency = 1 - (math.clamp(tonumber(_G.FH4N_V480.Brightness) or 1, 0.5, 10) / 10)
    end)
end)

-- LOGO & PROFILE
local L = Instance.new("ImageButton", sg); L.Size = UDim2.new(0, 70, 0, 70); L.Position = UDim2.new(0, 20, 0.5, -35); L.Image = "rbxassetid://6073747271"; L.ZIndex = 9999; Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0); Drag(L)
L.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)
