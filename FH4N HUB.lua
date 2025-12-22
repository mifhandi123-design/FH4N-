-- FH4N HUB | V.FINAL ANALOG SYSTEM
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

if PlayerGui:FindFirstChild("FH4N_ANALOG_VERSION") then PlayerGui.FH4N_ANALOG_VERSION:Destroy() end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "FH4N_ANALOG_VERSION"
sg.ResetOnSpawn = false

-- --- DRAG FUNCTION ---
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- --- UI STRUCTURE ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 420, 0, 320); main.Position = UDim2.new(0.5, -210, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
MakeDraggable(main)

local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 110, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30); sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -125, 1, -10); container.Position = UDim2.new(0, 118, 0, 5); container.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0,0,3,0); p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 7)
    return p
end

local pgPlayer = createPage("Player"); pgPlayer.Visible = true
local pgVisual = createPage("Visual"); local pgWorld = createPage("World")

-- --- UI HELPERS ---
local function AddTab(name, target, order)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(0.9, 0, 0, 32); b.Position = UDim2.new(0.05, 0, 0, 50 + (38 * order))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamSemibold"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(container:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        target.Visible = true
    end)
end

local function AddToggle(parent, txt, cb)
    local state = false
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.98, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.Text = txt .. ": OFF"; b.TextColor3 = Color3.new(0.6,0.6,0.6); b.Font = "Gotham"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 35)
        b.TextColor3 = state and Color3.new(1,1,1) or Color3.new(0.6,0.6,0.6)
        b.Text = txt .. ": " .. (state and "ON" or "OFF"); cb(state)
    end)
end

local function AddInput(parent, placeholder, cb)
    local t = Instance.new("TextBox", parent)
    t.Size = UDim2.new(0.98, 0, 0, 35); t.PlaceholderText = placeholder; t.BackgroundColor3 = Color3.fromRGB(20, 20, 25); t.TextColor3 = Color3.new(1,1,1); t.Font = "Gotham"; t.TextSize = 10; Instance.new("UICorner", t)
    t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
end

AddTab("PLAYER", pgPlayer, 0); AddTab("VISUAL", pgVisual, 1); AddTab("WORLD", pgWorld, 2)

-- ==========================================
-- [ PLAYER: FLY ANALOG PURE ]
-- ==========================================
AddToggle(pgPlayer, "Fly (Analog Control)", function(s)
    _G.Fly = s
    if s then
        local root = Player.Character:WaitForChild("HumanoidRootPart")
        local hum = Player.Character:WaitForChild("Humanoid")
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6); bv.Name = "FlyV"
        local bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1e6,1e6,1e6); bg.Name = "FlyG"
        
        task.spawn(function()
            while _G.Fly do
                -- Bergerak berdasarkan input analog (MoveDirection)
                -- Mengikuti arah kamera (jika analog ditekan)
                if hum.MoveDirection.Magnitude > 0 then
                    bv.Velocity = Camera.CFrame.LookVector * (_G.WS or 50)
                else
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                bg.CFrame = Camera.CFrame
                task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)

AddToggle(pgPlayer, "Noclip", function(s) _G.Nc = s end)
AddInput(pgPlayer, "Speed / Fly Speed", function(v) _G.WS = tonumber(v) end)
AddInput(pgPlayer, "Max Zoom", function(v) Player.CameraMaxZoomDistance = tonumber(v) end)

-- ==========================================
-- [ VISUAL: FREECAM PURE ]
-- ==========================================
AddToggle(pgVisual, "Freecam (Analog Control)", function(s)
    if s then
        local target = Instance.new("Part", workspace)
        target.Size = Vector3.new(1,1,1); target.Transparency = 1; target.Anchored = true; target.CanCollide = false
        target.Position = Camera.CFrame.Position; target.Name = "FCamPart"
        Camera.CameraSubject = target
        _G.FCam = target
        task.spawn(function()
            while _G.FCam do
                local moveDir = Player.Character.Humanoid.MoveDirection
                if moveDir.Magnitude > 0 then
                    target.CFrame = target.CFrame * CFrame.new(moveDir.X * 2, 0, moveDir.Z * 2)
                    -- Agar freecam mengikuti arah pandangan kamera saat maju:
                    target.CFrame = CFrame.new(target.Position, target.Position + Camera.CFrame.LookVector)
                end
                task.wait()
            end
        end)
    else
        if _G.FCam then _G.FCam:Destroy(); _G.FCam = nil end
        Camera.CameraSubject = Player.Character:FindFirstChild("Humanoid")
    end
end)

AddToggle(pgVisual, "ESP + Name", function(s)
    _G.ESP = s
    if not s then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character then 
                if p.Character:FindFirstChild("HE") then p.Character.HE:Destroy() end
                if p.Character.HumanoidRootPart:FindFirstChild("NE") then p.Character.HumanoidRootPart.NE:Destroy() end
            end
        end
    end
    task.spawn(function()
        while _G.ESP do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not p.Character:FindFirstChild("HE") then
                    local h = Instance.new("Highlight", p.Character); h.Name = "HE"; h.FillColor = Color3.new(1,0,0)
                    local b = Instance.new("BillboardGui", p.Character.HumanoidRootPart); b.Name = "NE"; b.Size = UDim2.new(0,80,0,20); b.AlwaysOnTop = true; b.ExtentsOffset = Vector3.new(0,3,0)
                    local t = Instance.new("TextLabel", b); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.Text = p.Name; t.TextColor3 = Color3.new(1,1,1); t.Font = "GothamBold"; t.TextSize = 9
                end
            end
            task.wait(1)
        end
    end)
end)

-- ==========================================
-- [ WORLD: WEATHER ]
-- ==========================================
local function AddWBtn(txt, ct, fog)
    local b = Instance.new("TextButton", pgWorld)
    b.Size = UDim2.new(0.98, 0, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(35, 35, 45); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() Lighting.ClockTime = ct; Lighting.FogEnd = fog or 100000 end)
end
AddWBtn("☀️ SIANG", 14)
AddWBtn("🌙 MALAM", 0)
AddWBtn("🌅 SUNSET", 17.5)
AddWBtn("❄️ SALJU/FOG", 12, 300)

-- --- SYSTEM ---
RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.Fly and not _G.FCam then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
end)

local min = Instance.new("TextButton", sg)
min.Size = UDim2.new(0, 45, 0, 45); min.Position = UDim2.new(0, 10, 0.4, 0); min.Text = "FN"; min.BackgroundColor3 = Color3.fromRGB(0, 120, 255); min.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", min).CornerRadius = UDim.new(1,0)
MakeDraggable(min); min.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)ting.Brightness = s and 3 or 1 end)

-- --- LOOP SYSTEM ---
RunService.Stepped:Connect(function()
    if _G.FB then Lighting.Ambient = Color3.new(1,1,1); Lighting.OutdoorAmbient = Color3.new(1,1,1) end
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
end)

-- --- LOGO FN (DRAGGABLE) ---
local min = Instance.new("TextButton", sg)
min.Size = UDim2.new(0, 45, 0, 45); min.Position = UDim2.new(0, 10, 0.4, 0); min.Text = "FN"; min.BackgroundColor3 = Color3.fromRGB(0, 120, 255); min.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", min).CornerRadius = UDim.new(1,0)
MakeDraggable(min)
min.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
