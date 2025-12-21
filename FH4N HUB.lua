-- FH4N HUB - Fitur Fly Analog & Stabil
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
MainFrame.Size = UDim2.new(0, 260, 0, 350)
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
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 3, 0)
Container.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 10)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- --- FUNGSI TOGGLE ---
local function CreateToggle(name, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    Instance.new("UICorner", btn)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(45, 45, 45)
        callback(enabled)
    end)
end

-- --- FITUR FLY ANALOG ---
local Flying = false
local FlySpeed = 50
CreateToggle("Fly (Analog Control)", function(state)
    Flying = state
    local char = game.Players.LocalPlayer.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if Flying and root and hum then
        -- Menghilangkan gravitasi agar tidak jatuh
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.Parent = root
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.Parent = root
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = root.CFrame
        
        task.spawn(function()
            while Flying and char.Parent do
                -- Mengambil input dari Analog/Joystick
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    bv.Velocity = moveDir * FlySpeed
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0) -- Mengambang diam
                end
                
                bg.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
            bv:Destroy()
            bg:Destroy()
        end)
    end
end)

-- --- FITUR SPEED ---
local SpeedInput = Instance.new("TextBox", Container)
SpeedInput.Size = UDim2.new(1, 0, 0, 40)
SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedInput.PlaceholderText = "Set Speed (Ketik & Enter)"
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SpeedInput)

SpeedInput.FocusLost:Connect(function(enter)
    if enter then
        local num = tonumber(SpeedInput.Text)
        if num then 
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num 
            FlySpeed = num -- Fly Speed mengikuti WalkSpeed
        end
    end
end)

-- --- NOCLIP & INFJUMP ---
local NoclipEnabled = false
CreateToggle("Noclip (Tembus)", function(state) NoclipEnabled = state end)

local InfJumpEnabled = false
CreateToggle("Infinite Jump", function(state) InfJumpEnabled = state end)

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

-- --- TELEPORT ---
local TPInput = Instance.new("TextBox", Container)
TPInput.Size = UDim2.new(1, 0, 0, 40)
TPInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TPInput.PlaceholderText = "TP Player (Nama & Enter)"
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
