--[[
    FH4N HUB V5 - MOBILE OPTIMIZED
    Fitur: Fly (Joystick/Mobile Support), Speed, InfJump, Noclip, Anti-AFK
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LogoFN = Instance.new("TextButton")
local Container = Instance.new("ScrollingFrame")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Setup UI
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "FH4N_Mobile"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- --- LOGO FN (MINIMIZE) ---
LogoFN.Name = "LogoFN"
LogoFN.Parent = ScreenGui
LogoFN.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LogoFN.Position = UDim2.new(0.05, 0, 0.4, 0)
LogoFN.Size = UDim2.new(0, 55, 0, 55)
LogoFN.Visible = false
LogoFN.Text = "FN"
LogoFN.TextColor3 = Color3.fromRGB(0, 255, 255)
LogoFN.TextSize = 22
LogoFN.Font = Enum.Font.GothamBold
Instance.new("UICorner", LogoFN).CornerRadius = UDim.new(1, 0)
local lStroke = Instance.new("UIStroke", LogoFN)
lStroke.Color = Color3.fromRGB(0, 255, 255)
lStroke.Thickness = 2

-- --- MAIN FRAME ---
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 210, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser di Mobile
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local mStroke = Instance.new("UIStroke", MainFrame)
mStroke.Color = Color3.fromRGB(45, 45, 45)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "FH4N HUB V5"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 25
CloseBtn.BackgroundTransparency = 1

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 45)
Container.Size = UDim2.new(1, -20, 1, -55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 7)

-- Logika Buka/Tutup
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    LogoFN.Visible = true
end)
LogoFN.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    LogoFN.Visible = false
end)

-- --- FUNGSI CREATE BUTTON ---
local function AddBtn(txt, cb)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(200, 200, 200)
    b.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() cb(b) end)
    return b
end

-- --- FITUR FLY MOBILE (Joystick Support) ---
local flying = false
local flySpeed = 50
local camera = workspace.CurrentCamera

AddBtn("Fly: OFF", function(b)
    flying = not flying
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    if flying then
        b.Text = "Fly: ON"
        b.TextColor3 = Color3.fromRGB(0, 255, 255)
        
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.Parent = root
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)

        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.Parent = root
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 9000
        
        task.spawn(function()
            while flying do
                RunService.RenderStepped:Wait()
                humanoid.PlatformStand = true
                
                -- Deteksi arah dari Joystick Mobile atau Keyboard PC
                local moveDir = humanoid.MoveDirection
                
                if moveDir.Magnitude > 0 then
                    -- Terbang ke arah joystick/kamera
                    bv.Velocity = (camera.CFrame.LookVector * moveDir.Z * -flySpeed) + (camera.CFrame.RightVector * moveDir.X * flySpeed)
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0)
                end
                
                bg.CFrame = camera.CFrame
            end
            
            -- Reset saat OFF
            bv:Destroy()
            bg:Destroy()
            humanoid.PlatformStand = false
        end)
    else
        b.Text = "Fly: OFF"
        b.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- --- FITUR SPEED ---
local sOn = false
AddBtn("Speed: OFF", function(b)
    sOn = not sOn
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = sOn and 100 or 16
    b.Text = sOn and "Speed: ON" or "Speed: OFF"
    b.TextColor3 = sOn and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
end)

-- --- FITUR INF JUMP ---
local ijOn = false
UserInputService.JumpRequest:Connect(function()
    if ijOn then game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)
AddBtn("InfJump: OFF", function(b)
    ijOn = not ijOn
    b.Text = ijOn and "InfJump: ON" or "InfJump: OFF"
    b.TextColor3 = ijOn and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
end)

-- --- FITUR NOCLIP ---
local ncOn = false
RunService.Stepped:Connect(function()
    if ncOn and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
AddBtn("Noclip: OFF", function(b)
    ncOn = not ncOn
    b.Text = ncOn and "Noclip: ON" or "Noclip: OFF"
    b.TextColor3 = ncOn and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
end)

-- --- FITUR ANTI-AFK ---
AddBtn("Anti-AFK", function(b)
    local vu = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    b.Text = "Anti-AFK: ACTIVE"
    b.TextColor3 = Color3.fromRGB(0, 255, 255)
end)
