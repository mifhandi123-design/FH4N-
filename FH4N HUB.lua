-- FH4N HUB | PREZZA UI (DRAGGABLE FN BUTTON)
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

if PlayerGui:FindFirstChild("FH4N_PREZZA_MOVE") then PlayerGui.FH4N_PREZZA_MOVE:Destroy() end

local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "FH4N_PREZZA_MOVE"
sg.ResetOnSpawn = false

-- --- FUNGSI DRAG (Agar tombol FN & Main bisa dipindah di Mobile) ---
local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- --- MAIN PANEL ---
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 280)
main.Position = UDim2.new(0.5, -200, 0.5, -140)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BorderSizePixel = 0
main.Visible = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
MakeDraggable(main)

-- --- SIDEBAR ---
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 100, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
sidebar.BorderSizePixel = 0
local sCorner = Instance.new("UICorner", sidebar)
sCorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", sidebar)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "FH4N HUB"; title.TextColor3 = Color3.new(1,1,1); title.Font = "GothamBold"; title.BackgroundTransparency = 1; title.TextSize = 14

-- --- CONTAINER ---
local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -110, 1, -10)
container.Position = UDim2.new(0, 105, 0, 5)
container.BackgroundTransparency = 1

local function createPage(name)
    local p = Instance.new("ScrollingFrame", container)
    p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.Visible = false; p.BackgroundTransparency = 1; p.CanvasSize = UDim2.new(0,0,2,0); p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    return p
end

local pagePlayer = createPage("Player")
local pageVisual = createPage("Visual")
local pageWorld = createPage("World")
pagePlayer.Visible = true

-- --- UI COMPONENT HELPERS ---
local function AddTab(name, targetPage, order)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(0.9, 0, 0, 30); b.Position = UDim2.new(0.05, 0, 0, 50 + (35 * order))
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(40, 40, 55); b.TextColor3 = Color3.new(1,1,1); b.Font = "GothamSemibold"; b.TextSize = 12
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        for _, p in pairs(container:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        targetPage.Visible = true
    end)
end

local function AddToggle(parent, txt, cb)
    local state = false
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30, 30, 40); b.Text = txt .. ": OFF"; b.TextColor3 = Color3.new(0.6,0.6,0.6); b.Font = "Gotham"; b.TextSize = 12
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 40)
        b.TextColor3 = state and Color3.new(1,1,1) or Color3.new(0.6,0.6,0.6)
        b.Text = txt .. ": " .. (state and "ON" or "OFF")
        cb(state)
    end)
end

local function AddInput(parent, placeholder, cb)
    local t = Instance.new("TextBox", parent)
    t.Size = UDim2.new(1, 0, 0, 35); t.PlaceholderText = placeholder; t.BackgroundColor3 = Color3.fromRGB(20, 20, 30); t.TextColor3 = Color3.new(1,1,1); t.Font = "Gotham"; t.TextSize = 12
    Instance.new("UICorner", t)
    t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
end

AddTab("Player", pagePlayer, 0)
AddTab("Visual", pageVisual, 1)
AddTab("World", pageWorld, 2)

-- --- FEATURES ---
AddToggle(pagePlayer, "Mobile Fly", function(s)
    _G.Fly = s
    if s then
        local root = Player.Character.HumanoidRootPart
        local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6); bv.Name = "PFly"
        task.spawn(function()
            while _G.Fly do bv.Velocity = Camera.CFrame.LookVector * (Player.Character.Humanoid.MoveDirection.Magnitude > 0 and (_G.WS or 50) or 0) task.wait() end
            bv:Destroy()
        end)
    end
end)
AddToggle(pagePlayer, "Noclip", function(s) _G.Nc = s end)
AddToggle(pagePlayer, "Inf Jump", function(s) _G.IJ = s end)
UIS.JumpRequest:Connect(function() if _G.IJ then Player.Character.Humanoid:ChangeState(3) end end)
AddInput(pagePlayer, "Speed", function(v) _G.WS = tonumber(v) end)

AddToggle(pageVisual, "ESP Player + Name", function(s)
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
                    local b = Instance.new("BillboardGui", p.Character.HumanoidRootPart); b.Name = "NE"; b.Size = UDim2.new(0,100,0,20); b.AlwaysOnTop = true; b.ExtentsOffset = Vector3.new(0,3,0)
                    local t = Instance.new("TextLabel", b); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.Text = p.Name; t.TextColor3 = Color3.new(1,1,1); t.Font = "GothamBold"; t.TextSize = 10
                end
            end
            task.wait(1)
        end
    end)
end)
AddToggle(pageVisual, "FPS Counter", function(s)
    _G.FPS = s
    if s then
        local fL = Instance.new("TextLabel", sg); fL.Size = UDim2.new(0,60,0,20); fL.Position = UDim2.new(0,10,0,10); fL.BackgroundColor3 = Color3.new(0,0,0); fL.TextColor3 = Color3.new(0,1,0); fL.TextSize = 10; fL.Font = "GothamBold"
        task.spawn(function() while _G.FPS do local dt = task.wait(1) fL.Text = "FPS: " .. math.floor(1/dt) end fL:Destroy() end)
    end
end)

AddToggle(pageWorld, "Always Day", function(s) _G.Day = s end)

RunService.Stepped:Connect(function()
    if _G.Day then Lighting.ClockTime = 14 end
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        if _G.WS and not _G.Fly then Player.Character.Humanoid.WalkSpeed = _G.WS end
        if _G.Nc then for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    end
end)

-- --- LOGO FN (NOW DRAGGABLE) ---
local min = Instance.new("TextButton", sg)
min.Name = "FN_Button"
min.Size = UDim2.new(0, 45, 0, 45)
min.Position = UDim2.new(0, 10, 0.4, 0)
min.Text = "FN"; min.BackgroundColor3 = Color3.fromRGB(0, 120, 255); min.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", min).CornerRadius = UDim.new(1,0)

MakeDraggable(min) -- Menjadikan tombol FN bisa digeser

min.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)
