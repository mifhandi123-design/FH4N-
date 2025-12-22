local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Anti-Double Script
if PlayerGui:FindFirstChild("FH4N_V_FIXED") then PlayerGui.FH4N_V_FIXED:Destroy() end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "FH4N_V_FIXED"
sg.ResetOnSpawn = false

-- --- DRAG FUNCTION (Sangat Stabil) ---
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
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
end

-- --- UI MAIN ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 300); main.Position = UDim2.new(0.5, -200, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
MakeDraggable(main)

local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 100, 1, 0); sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30); sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -115, 1, -10); container.Position = UDim2.new(0, 110, 0, 5); container.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0,0,2.5,0); p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 5)
    return p
end

local pgPlayer = createPage("Player"); pgPlayer.Visible = true
local pgVisual = createPage("Visual"); local pgWorld = createPage("World")

-- --- UI BUILDER ---
local function AddTab(name, target, order)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, 45 + (40 * order))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(40, 40, 50); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamBold"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(container:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        target.Visible = true
    end)
end

local function AddToggle(parent, txt, cb)
    local state = false
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.Text = txt .. ": OFF"; b.TextColor3 = Color3.new(0.8,0.8,0.8); b.Font = "Gotham"; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 35)
        b.Text = txt .. ": " .. (state and "ON" or "OFF"); cb(state)
    end)
end

local function AddInput(parent, placeholder, cb)
    local t = Instance.new("TextBox", parent)
    t.Size = UDim2.new(1, 0, 0, 35); t.PlaceholderText = placeholder; t.BackgroundColor3 = Color3.fromRGB(20, 20, 25); t.TextColor3 = Color3.new(1,1,1); t.Font = "Gotham"; t.TextSize = 10; Instance.new("UICorner", t)
    t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
end

AddTab("PLAYER", pgPlayer, 0); AddTab("VISUAL", pgVisual, 1); AddTab("WORLD", pgWorld, 2)

-- ==========================================
-- [ PLAYER: FLY ANALOG ]
-- ==========================================
AddToggle(pgPlayer, "Fly Analog (Input Based)", function(s)
    _G.Fly = s
    if s then
        local root = Player.Character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6); bv.Name = "V_FlyV"
        local bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1e6,1e6,1e6); bg.Name = "V_FlyG"
        task.spawn(function()
            while _G.Fly do
                -- Gerakan mengikuti arah pandangan kamera saat analog ditekan
                if Player.Character.Humanoid.MoveDirection.Magnitude > 0 then
                    bv.Velocity = Camera.CFrame.LookVector * (_G.WS or 50)
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0)
                end
                bg.CFrame = Camera.CFrame; task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)

AddToggle(pgPlayer, "Noclip", function(s) _G.Nc = s end)
AddInput(pgPlayer, "Speed / Fly Speed", function(v) _G.WS = tonumber(v) end)
AddInput(pgPlayer, "Set Max Zoom", function(v) Player.CameraMaxZoomDistance = tonumber(v) end)

-- ==========================================
-- [ VISUAL: FIX FPS & FREECAM ]
-- ==========================================
AddToggle(pgVisual, "FPS Counter (Smooth Update)", function(s)
    _G.ShowFPS = s
    if s then
        local fl = Instance.new("TextLabel", sg); fl.Size = UDim2.new(0, 70, 0, 25); fl.Position = UDim2.new(0, 10, 0, 10); fl.BackgroundColor3 = Color3.new(0,0,0); fl.TextColor3 = Color3.new(0,1,0); fl.BackgroundTransparency = 0.5; fl.Font = "GothamBold"; fl.TextSize = 12
        Instance.new("UICorner", fl)
        local lastTime = tick()
        local frameCount = 0
        RunService.RenderStepped:Connect(function()
            if not _G.ShowFPS then fl:Destroy() return end
            frameCount = frameCount + 1
            if tick() - lastTime >= 1 then
                fl.Text = "FPS: " .. frameCount
                frameCount = 0
                lastTime = tick()
            end
        end)
    end
end)

AddToggle(pgVisual, "Freecam (Independent)", function(s)
    _G.Freecam = s
    if s then
        local part = Instance.new("Part", workspace); part.Anchored = true; part.CanCollide = false; part.Transparency = 1; part.Position = Camera.CFrame.Position
        Camera.CameraSubject = part; _G.FCPart = part
        task.spawn(function()
            while _G.Freecam do
                local md = Player.Character.Humanoid.MoveDirection
                if md.Magnitude > 0 then
                    part.CFrame = part.CFrame * CFrame.new(md.X * 2, 0, md.Z * 2)
                    part.CFrame = CFrame.new(part.Position, part.Position + Camera.CFrame.LookVector)
                end
                task.wait()
            end
        end)
    else
        if _G.FCPart then _G.FCPart:Destroy() end
        Camera.CameraSubject = Player.Character.Humanoid
    end
end)

-- ==========================================
-- [ WORLD: WEATHER ]
-- ==========================================
local function AddW(txt, ct)
    local b = Instance.new("TextButton", pgWorld)
    b.Size = UDim2.new(1, 0, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(40,40,50); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() Lighting.ClockTime = ct end)
end
AddW("☀️ Siang", 14); AddW("🌙 Malam", 0); AddW("🌅 Sunset", 17.5)

-- --- SYSTEM LOOP ---
RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.Fly and not _G.Freecam then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
end)

-- --- MINIMIZE BUTTON ---
local min = Instance.new("TextButton", sg)
min.Size = UDim2.new(0, 45, 0, 45); min.Position = UDim2.new(0, 10, 0.4, 0); min.Text = "FN"; min.BackgroundColor3 = Color3.fromRGB(0, 120, 255); min.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", min).CornerRadius = UDim.new(1,0)
MakeDraggable(min); min.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)hen Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
end)

-- --- LOGO FN (DRAGGABLE) ---
local min = Instance.new("TextButton", sg)
min.Size = UDim2.new(0, 45, 0, 45); min.Position = UDim2.new(0, 10, 0.4, 0); min.Text = "FN"; min.BackgroundColor3 = Color3.fromRGB(0, 120, 255); min.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", min).CornerRadius = UDim.new(1,0)
MakeDraggable(min)
min.MouseButton1Click:Connect(function() main.Visible = not main.Visible end)
