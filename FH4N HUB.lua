-- FH4N HUB | ORGANIZED CATEGORIES
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Bersihkan sisa script lama
if PlayerGui:FindFirstChild("FH4N_FINAL_ORG") then PlayerGui.FH4N_FINAL_ORG:Destroy() end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "FH4N_FINAL_ORG"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 380)
main.Position = UDim2.new(0.5, -130, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 2
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "FH4N HUB | ALL FEATURES"
title.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = "SourceSansBold"

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 5, 0)
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

-- --- FUNGSI PENGELOMPOKAN (DROPDOWN) ---
local function CreateCategory(name)
    local catFrame = Instance.new("Frame", scroll)
    catFrame.Size = UDim2.new(1, 0, 0, 30)
    catFrame.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
    
    local catLabel = Instance.new("TextLabel", catFrame)
    catLabel.Size = UDim2.new(1, 0, 1, 0)
    catLabel.Text = "[ " .. name .. " ]"
    catLabel.TextColor3 = Color3.new(1, 1, 1)
    catLabel.BackgroundTransparency = 1
    catLabel.Font = "SourceSansBold"
end

local function CreateButton(txt, cb)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.MouseButton1Click:Connect(cb)
end

local function CreateInput(placeholder, cb)
    local t = Instance.new("TextBox", scroll)
    t.Size = UDim2.new(1, 0, 0, 35)
    t.PlaceholderText = placeholder
    t.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    t.TextColor3 = Color3.new(1, 1, 1)
    t.FocusLost:Connect(function(enter) if enter then cb(t.text) end end)
end

-- ==========================================
-- [ KATEGORI 1: PLAYER ]
-- ==========================================
CreateCategory("PLAYER FEATURES")

CreateButton("FLY (ON/OFF)", function()
    _G.Fly = not _G.Fly
    if _G.Fly then
        local bv = Instance.new("BodyVelocity", Player.Character.HumanoidRootPart)
        bv.Name = "FlyV"; bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while _G.Fly do
                bv.Velocity = Camera.CFrame.LookVector * (_G.WS or 50)
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

CreateButton("NOCLIP (ON/OFF)", function() _G.Nc = not _G.Nc end)
CreateButton("INF JUMP (ON)", function() 
    game:GetService("UserInputService").JumpRequest:Connect(function() Player.Character.Humanoid:ChangeState(3) end)
end)

CreateInput("Set WalkSpeed", function(val) _G.WS = tonumber(val) end)
CreateInput("Set JumpPower", function(val) Player.Character.Humanoid.JumpPower = tonumber(val); Player.Character.Humanoid.UseJumpPower = true end)
CreateInput("TP Player Name", function(val) 
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():find(val:lower()) then Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame end
    end
end)

-- ==========================================
-- [ KATEGORI 2: VISUAL ]
-- ==========================================
CreateCategory("VISUAL & GRAPHICS")

CreateButton("REALISTIC MAX", function()
    local b = Instance.new("BloomEffect", game.Lighting); b.Intensity = 1
    local c = Instance.new("ColorCorrectionEffect", game.Lighting); c.Saturation = 0.5
    game.Lighting.Brightness = 2.5
    game.Lighting.GlobalShadows = true
end)

CreateButton("FULL BRIGHT", function() 
    game.Lighting.Ambient = Color3.new(1,1,1); game.Lighting.OutdoorAmbient = Color3.new(1,1,1) 
end)

CreateButton("FREECAM (SMOOTH)", function()
    local p = Instance.new("Part", workspace); p.Anchored = true; p.Transparency = 1; p.CFrame = Camera.CFrame; Camera.CameraSubject = p
    task.spawn(function()
        while p.Parent do
            p.CFrame = p.CFrame * CFrame.new(Player.Character.Humanoid.MoveDirection * 1.8)
            Camera.CFrame = p.CFrame
            task.wait()
        end
    end)
end)

CreateButton("ESP PLAYER", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local h = Instance.new("Highlight", p.Character); h.FillColor = Color3.new(1, 0, 0)
        end
    end
end)

-- ==========================================
-- [ KATEGORI 3: WORLD ]
-- ==========================================
CreateCategory("WORLD SETTINGS")

CreateButton("SET DAY (SIANG)", function() game.Lighting.ClockTime = 14 end)
CreateButton("SET NIGHT (MALAM)", function() game.Lighting.ClockTime = 0 end)
CreateButton("UNLOCK FPS", function() setfpscap(999) end)

-- --- LOOP SISTEM ---
RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- TOMBOL FN (Minimize)
local min = Instance.new("TextButton", sg)
min.Size = UDim2.new(0, 45, 0, 45); min.Position = UDim2.new(0, 5, 0.4, 0); min.Text = "FN"
min.BackgroundColor3 = Color3.new(0, 0, 1); min.TextColor3 = Color3.new(1, 1, 1)
min.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)ction()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local tag = p.Character.Head:FindFirstChild("FN_ESP")
                if _G.ESP and not tag then
                    local bb = Instance.new("BillboardGui", p.Character.Head); bb.Name = "FN_ESP"; bb.Size = UDim2.new(0, 100, 0, 40); bb.AlwaysOnTop = true
                    local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Text = p.DisplayName; lbl.Font = "SourceSansBold"
                elseif not _G.ESP and tag then tag:Destroy() end
            end
        end
    end
end)
