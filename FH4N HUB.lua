-- FH4N HUB - Fitur Lengkap + RTX 5080 Graphics
if game.CoreGui:FindFirstChild("FH4N_FINAL") then game.CoreGui.FH4N_FINAL:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Header = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local MinimizeBtn = Instance.new("TextButton")

-- Setup UI Utama
ScreenGui.Name = "FH4N_FINAL"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Tombol Minimize (FN —)
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = ScreenGui
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
MinimizeBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
MinimizeBtn.Size = UDim2.new(0, 70, 0, 40)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Text = "FN —"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.TextSize = 20
MinimizeBtn.Active = true
MinimizeBtn.Draggable = true
Instance.new("UICorner", MinimizeBtn)

-- Menu Utama
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Header.Size = UDim2.new(1, 0, 0, 40)
Instance.new("UICorner", Header)

Title.Parent = Header
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "FH4N HUB | FN BIGRONE"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 45)
Container.Size = UDim2.new(1, -20, 1, -55)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 0, 750) -- Ditambah untuk fitur baru
Container.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local function CreateToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(45, 45, 45)
        callback(enabled)
    end)
end

-- --- 1. FITUR RTX 5080 (GRAPHICS) ---
CreateToggle("RTX 5080 Graphics", function(state)
    if state then
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = 2
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        
        local Bloom = Instance.new("BloomEffect", Lighting)
        Bloom.Name = "RTX_Bloom"
        Bloom.Intensity = 1
        
        local SunRays = Instance.new("SunRaysEffect", Lighting)
        SunRays.Name = "RTX_Sun"
        SunRays.Intensity = 0.1
        
        local ColorCorr = Instance.new("ColorCorrectionEffect", Lighting)
        ColorCorr.Name = "RTX_Color"
        ColorCorr.Contrast = 0.2
        ColorCorr.Saturation = 0.2
    else
        local Lighting = game:GetService("Lighting")
        if Lighting:FindFirstChild("RTX_Bloom") then Lighting.RTX_Bloom:Destroy() end
        if Lighting:FindFirstChild("RTX_Sun") then Lighting.RTX_Sun:Destroy() end
        if Lighting:FindFirstChild("RTX_Color") then Lighting.RTX_Color:Destroy() end
        Lighting.Brightness = 1
    end
end)

-- --- 2. SPEED ---
local SpeedInput = Instance.new("TextBox", Container)
SpeedInput.Size = UDim2.new(1, 0, 0, 38)
SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedInput.PlaceholderText = "Set Speed (Enter)"
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

-- --- 3. FLY ANALOG ---
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
                    bv.Velocity = (cam.CFrame.LookVector * (moveDir.Magnitude)) * CurrentFlySpeed
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

-- --- 4. ESP NAME ---
local ESP_Enabled = false
CreateToggle("Player ESP Name", function(state) ESP_Enabled = state end)

task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local tag = p.Character.Head:FindFirstChild("FN_ESP_TAG")
                if ESP_Enabled and not tag then
                    local bb = Instance.new("BillboardGui", p.Character.Head)
                    bb.Name = "FN_ESP_TAG"
                    bb.Size = UDim2.new(0, 100, 0, 50)
                    bb.AlwaysOnTop = true
                    bb.ExtentsOffset = Vector3.new(0, 3, 0)
                    local lbl = Instance.new("TextLabel", bb)
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    lbl.TextStrokeTransparency = 0
                    lbl.Font = Enum.Font.SourceSansBold
                    lbl.TextSize = 14
                    lbl.Text = p.DisplayName or p.Name
                elseif not ESP_Enabled and tag then
                    tag:Destroy()
                end
            end
        end
    end
end)

-- --- 5. NOCLIP ---
local NoclipEnabled = false
CreateToggle("Noclip", function(state) NoclipEnabled = state end)

-- --- 6. INF JUMP ---
local InfJumpEnabled = false
CreateToggle("Infinite Jump", function(state) InfJumpEnabled = state end)

-- --- 7. TELEPORT ---
local TPInput = Instance.new("TextBox", Container)
TPInput.Size = UDim2.new(1, 0, 0, 38)
TPInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TPInput.PlaceholderText = "TP Player (Enter)"
TPInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TPInput)

TPInput.FocusLost:Connect(function(enter)
    if enter and TPInput.Text ~= "" then
        local name = TPInput.Text:lower()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Name:lower():find(name) or v.DisplayName:lower():find(name) then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
end)

-- --- LOOPS ---
game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled and game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)
