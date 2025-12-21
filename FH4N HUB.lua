-- FH4N HUB - FIX GROUPING
if game.CoreGui:FindFirstChild("FH4N_FINAL") then game.CoreGui.FH4N_FINAL:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local Container = Instance.new("ScrollingFrame", MainFrame)
local MinimizeBtn = Instance.new("TextButton", ScreenGui)

-- --- UI CONFIG ---
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "FH4N HUB | VERSION 2.0"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 1100)
Container.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)

MinimizeBtn.Size = UDim2.new(0, 70, 0, 40)
MinimizeBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
MinimizeBtn.Text = "FN —"
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Draggable = true
Instance.new("UICorner", MinimizeBtn)
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- --- HELPER: SECTION LABEL ---
local function CreateSection(txt)
    local frame = Instance.new("Frame", Container)
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundTransparency = 1
    
    local line = Instance.new("Frame", frame)
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    
    local l = Instance.new("TextLabel", frame)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.Font = Enum.Font.SourceSansBold
    l.TextSize = 16
    l.BackgroundTransparency = 1
end

local function CreateToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(30, 30, 30)
        callback(state)
    end)
end

-- ==========================================
-- KELOMPOK: PLAYER
-- ==========================================
CreateSection("PLAYER SETTINGS")

local SpeedInput = Instance.new("TextBox", Container)
SpeedInput.Size = UDim2.new(1, 0, 0, 38)
SpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedInput.PlaceholderText = "Speed: 16 (Enter)"
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SpeedInput)

local CurrentFlySpeed = 50
SpeedInput.FocusLost:Connect(function(enter)
    if enter then
        local num = tonumber(SpeedInput.Text)
        if num then 
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num 
            CurrentFlySpeed = num
        end
    end
end)

local Flying = false
CreateToggle("Fly Analog", function(state)
    Flying = state
    local char = game.Players.LocalPlayer.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local cam = workspace.CurrentCamera
    if Flying and root and hum then
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while Flying and char.Parent do
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    bv.Velocity = (cam.CFrame.LookVector * moveDir.Magnitude) * CurrentFlySpeed
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0)
                end
                bg.CFrame = cam.CFrame
                task.wait()
            end
            bv:Destroy() bg:Destroy()
        end)
    end
end)

CreateToggle("Noclip", function(s) NoclipEnabled = s end)
CreateToggle("Infinite Jump", function(s) InfJumpEnabled = s end)

local TPInput = Instance.new("TextBox", Container)
TPInput.Size = UDim2.new(1, 0, 0, 38)
TPInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TPInput.PlaceholderText = "TP Name Player (Enter)"
TPInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TPInput)

TPInput.FocusLost:Connect(function(enter)
    if enter and TPInput.Text ~= "" then
        local target = TPInput.Text:lower()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Name:lower():find(target) or v.DisplayName:lower():find(target) then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
end)

-- ==========================================
-- KELOMPOK: VISUAL
-- ==========================================
CreateSection("VISUAL SETTINGS")

CreateToggle("RTX 5080 Effects", function(state)
    local L = game:GetService("Lighting")
    if state then
        local bl = Instance.new("BloomEffect", L); bl.Name = "RTXB"; bl.Intensity = 0.5
        local cc = Instance.new("ColorCorrectionEffect", L); cc.Name = "RTXC"; cc.Contrast = 0.2
    else
        if L:FindFirstChild("RTXB") then L.RTXB:Destroy() end
        if L:FindFirstChild("RTXC") then L.RTXC:Destroy() end
    end
end)

CreateToggle("PC Port (Extreme)", function(state)
    local L = game:GetService("Lighting")
    if state then
        L.Brightness = 2.5
        local at = Instance.new("Atmosphere", L); at.Name = "PCA"; at.Density = 0.35
    else
        if L:FindFirstChild("PCA") then L.PCA:Destroy() end
        L.Brightness = 1
    end
end)

CreateToggle("Dynamic Shadows", function(state)
    game:GetService("Lighting").GlobalShadows = state
    game:GetService("Lighting").EnvironmentDiffuseScale = state and 1 or 0
    game:GetService("Lighting").EnvironmentSpecularScale = state and 1 or 0
end)

CreateToggle("ESP Player Name", function(s) ESP_Enabled = s end)

-- --- SYSTEM LOOPS (KEEP ACTIVE) ---
game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled then game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping") end
end)

task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local tag = p.Character.Head:FindFirstChild("FN_ESP")
                if ESP_Enabled and not tag then
                    local bb = Instance.new("BillboardGui", p.Character.Head)
                    bb.Name = "FN_ESP"; bb.Size = UDim2.new(0, 100, 0, 50); bb.AlwaysOnTop = true; bb.ExtentsOffset = Vector3.new(0, 3, 0)
                    local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(255, 255, 255); lbl.TextStrokeTransparency = 0; lbl.Text = p.DisplayName or p.Name; lbl.Font = Enum.Font.SourceSansBold; lbl.TextSize = 12
                elseif not ESP_Enabled and tag then tag:Destroy() end
            end
        end
    end
end)
