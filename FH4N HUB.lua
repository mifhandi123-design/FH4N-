-- [[ FH4N HUB V.39 - CLEAN & OPTIMIZED ]] --
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Global States (Hanya Satu Tempat Penyimpanan)
_G.Config = {
    WS = 16,
    JP = 50,
    IJ = false,
    Nc = false,
    Fly = false,
    FB = false,
    Hitbox = false
}

-- UI Parent Fix
local UI_PARENT = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
if UI_PARENT:FindFirstChild("FH4N_V39") then UI_PARENT.FH4N_V39:Destroy() end

local sg = Instance.new("ScreenGui", UI_PARENT)
sg.Name = "FH4N_V39"
sg.ResetOnSpawn = false

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

-- --- MAIN FRAME ---
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 480, 0, 320); Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Main.Visible = true; Drag(Main)
Instance.new("UICorner", Main)

local Side = Instance.new("Frame", Main); Side.Size = UDim2.new(0, 110, 1, 0); Side.BackgroundColor3 = Color3.fromRGB(15, 15, 18); Instance.new("UICorner", Side)
local Cont = Instance.new("Frame", Main); Cont.Position = UDim2.new(0, 115, 0, 5); Cont.Size = UDim2.new(1, -120, 1, -10); Cont.BackgroundTransparency = 1

local function Page(n)
    local p = Instance.new("ScrollingFrame", Cont); p.Name = n; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false
    p.BackgroundTransparency = 1; p.ScrollBarThickness = 2; p.CanvasSize = UDim2.new(0,0,3,0)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5); return p
end

local P = Page("P"); local C = Page("C"); local T = Page("T"); local W = Page("W"); P.Visible = true

-- --- COMPONENTS ---
local function Tab(t, tg, o)
    local b = Instance.new("TextButton", Side); b.Size = UDim2.new(0.9, 0, 0, 30); b.Position = UDim2.new(0.05,0,0,10+(35*o))
    b.Text = t; b.BackgroundColor3 = Color3.fromRGB(25,25,30); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Cont:GetChildren()) do v.Visible = false end; tg.Visible = true end)
end

local function Toggle(p, t, key)
    local b = Instance.new("TextButton", p); b.Size = UDim2.new(1,-10,0,35); b.Text = t..": OFF"
    b.BackgroundColor3 = Color3.fromRGB(20,20,25); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() 
        _G.Config[key] = not _G.Config[key]
        b.BackgroundColor3 = _G.Config[key] and Color3.fromRGB(0,120,255) or Color3.fromRGB(20,20,25)
        b.Text = t..": "..(_G.Config[key] and "ON" or "OFF")
        
        -- Special Logic for Fly
        if key == "Fly" and _G.Config.Fly then
            task.spawn(function()
                local r = Player.Character:WaitForChild("HumanoidRootPart")
                local h = Player.Character:WaitForChild("Humanoid")
                local bv = Instance.new("BodyVelocity", r); bv.MaxForce = Vector3.new(1e6,1e6,1e6)
                local bg = Instance.new("BodyGyro", r); bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
                while _G.Config.Fly do
                    bg.CFrame = Camera.CFrame
                    bv.Velocity = (h.MoveDirection.Magnitude > 0) and (Camera.CFrame.LookVector * _G.Config.WS) or Vector3.new(0,0.1,0)
                    task.wait()
                end
                bv:Destroy(); bg:Destroy()
            end)
        end
    end)
end

local function Input(p, t, key)
    local i = Instance.new("TextBox", p); i.Size = UDim2.new(1,-10,0,35); i.PlaceholderText = t; i.Text = ""
    i.BackgroundColor3 = Color3.fromRGB(18,18,22); i.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", i)
    i.FocusLost:Connect(function() _G.Config[key] = tonumber(i.Text) or _G.Config[key] end)
end

-- --- MENYUSUN MENU ---
Tab("PLAYER", P, 0); Tab("COMBAT", C, 1); Tab("TP", T, 2); Tab("WORLD", W, 3)

Input(P, "Speed Value", "WS")
Input(P, "Jump Value", "JP")
Toggle(P, "Fly Analog 3D", "Fly")
Toggle(P, "Noclip", "Nc")
Toggle(P, "Infinite Jump", "IJ")

Toggle(C, "Hitbox Musuh", "Hitbox")
Input(T, "TP Player Name", "TP_Target") -- Input khusus untuk TP

Toggle(W, "FullBright", "FB")

-- --- LOGO ---
local L = Instance.new("TextButton", sg); L.Size = UDim2.new(0,50,0,50); L.Position = UDim2.new(0,10,0.5,0); L.Text = "FN"
L.BackgroundColor3 = Color3.fromRGB(0,120,255); L.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", L).CornerRadius = UDim.new(1,0); Drag(L)
L.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- --- SINGLE ENGINE LOOP (Paling Stabil) ---
UIS.JumpRequest:Connect(function() if _G.Config.IJ and Player.Character then Player.Character.Humanoid:ChangeState(3) end end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            -- 1. WalkSpeed (Hanya jika tidak sedang Fly)
            if not _G.Config.Fly then char.Humanoid.WalkSpeed = _G.Config.WS end
            
            -- 2. JumpPower
            char.Humanoid.JumpPower = _G.Config.JP
            char.Humanoid.UseJumpPower = true
            
            -- 3. Noclip
            if _G.Config.Nc then
                for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
            
            -- 4. Hitbox
            if _G.Config.Hitbox then
                for _,p in pairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character then 
                        p.Character.HumanoidRootPart.Size = Vector3.new(15,15,15)
                        p.Character.HumanoidRootPart.Transparency = 0.7 
                    end
                end
            end
        end
        -- 5. Lighting
        if _G.Config.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.Brightness = 2 end
    end)
end)

-- TP Logic terpisah agar tidak berat
task.spawn(function()
    while task.wait(1) do
        if _G.Config.TP_Target and _G.Config.TP_Target ~= "" then
            local targetName = _G.Config.TP_Target:lower()
            for _,p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Name:lower():find(targetName) and p.Character then
                    Player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                    _G.Config.TP_Target = "" -- Reset setelah TP
                end
            end
        end
    end
end)
