-- FH4N HUB FINAL - Organized Categories
if game.CoreGui:FindFirstChild("FH4N_FINAL") then game.CoreGui.FH4N_FINAL:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local Container = Instance.new("ScrollingFrame", MainFrame)
local MinimizeBtn = Instance.new("TextButton", ScreenGui)

-- --- UI CONFIGURATION ---
MainFrame.Name = "MainFrame"
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
Title.Text = "FH4N HUB | FINAL"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 1050)
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

-- --- UTILITY FUNCTIONS ---
local function CreateLabel(txt)
    local l = Instance.new("TextLabel", Container)
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Text = "--- " .. txt .. " ---"
    l.TextColor3 = Color3.fromRGB(0, 150, 255)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.SourceSansBold
    l.TextSize = 15
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
-- KATEGORI 1: PLAYER
-- ==========================================
CreateLabel("PLAYER")

-- Speed
local SpeedInput = Instance.new("TextBox", Container)
SpeedInput.Size = UDim2.new(1, 0, 0, 38)
SpeedInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedInput.PlaceholderText = "Set WalkSpeed (Enter)"
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

-- Fly
local Flying = false
CreateToggle("Fly Analog (Full Dir)", function(state)
    Flying = state
    local char = game.Players.LocalPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
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

-- Noclip
local NoclipEnabled = false
CreateToggle("Noclip (Tembus)", function(s) NoclipEnabled = s end)

-- Infinite Jump
local InfJumpEnabled = false
CreateToggle("Infinite Jump", function(s) InfJumpEnabled = s end)

-- Teleport
local TPInput = Instance.new("TextBox", Container)
TPInput.Size = UDim2.new(1, 0, 0, 38)
TPInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TPInput.PlaceholderText = "TP to Player (Enter)"
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
-- KATEGORI 2: VISUAL
-- ==========================================
CreateLabel("VISUAL")

-- RTX 5080
CreateToggle("RTX 5080 Effects", function(state)
    local L = game:GetService("Lighting")
    if state then
        local bl = Instance.new("BloomEffect", L); bl.Name = "RTX_B"; bl.Intensity = 0.5
        local cc = Instance.new("ColorCorrectionEffect", L); cc.Name = "RTX_C"; cc.Contrast = 0.2
    else
        if L:FindFirstChild("RTX_B") then L.RTX_B:Destroy() end
        if L:FindFirstChild("RTX_C") then L.RTX_C:Destroy() end
    end
end)

-- PC PORT
CreateToggle("PC Port (Shaders)", function(state)
    local L = game:GetService("Lighting")
    if state then
        L.Brightness = 2.5
        local at = Instance.new("Atmosphere", L); at.Name = "PCP_A"; at.Density = 0.3
        local sky = Instance.new("Sky", L); sky.Name = "PCP_S"; sky.SunAngularSize = 15
    else
        if L:FindFirstChild("PCP_A") then L.PCP_A:Destroy() end
        if L:FindFirstChild("PCP_S") then L.PCP_S:Destroy() end
        L.Brightness = 1
    end
end)

-- Dynamic Shadow
CreateToggle("Dynamic Shadow", function(state)
    game:GetService("Lighting").GlobalShadows = state
    game:GetService("Lighting").EnvironmentDiffuseScale = state and 1 or 0
    game:GetService("Lighting").EnvironmentSpecularScale = state and 1 or 0
end)

-- ESP Player
local ESP_Enabled = false
CreateToggle("ESP Player Name", function(s) ESP_Enabled = s end)

-- --- BACKGROUND LOOPS ---
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
                    local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(255, 255, 255); lbl.TextStrokeTransparency = 0; lbl.Text = p.DisplayName or p.Name; lbl.Font = Enum.Font.SourceSansBold
                elseif not ESP_Enabled and tag then tag:Destroy() end
            end
        end
    end
end)
