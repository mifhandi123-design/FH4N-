--[[
    FH4N HUB V4 - FLY DIRECTIONAL UPDATE
    Fitur: Fly (Directional), Speed, InfJump, Noclip, Anti-AFK
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LogoFN = Instance.new("TextButton")
local Container = Instance.new("ScrollingFrame")

-- Setup UI Utama
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "FH4N_V4"

-- --- LOGO FN (MINIMIZE) ---
LogoFN.Name = "LogoFN"
LogoFN.Parent = ScreenGui
LogoFN.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LogoFN.Position = UDim2.new(0.05, 0, 0.4, 0)
LogoFN.Size = UDim2.new(0, 60, 0, 60)
LogoFN.Visible = false
LogoFN.Text = "FN"
LogoFN.TextColor3 = Color3.fromRGB(0, 255, 255)
LogoFN.TextSize = 24
LogoFN.Font = Enum.Font.GothamBold
Instance.new("UICorner", LogoFN).CornerRadius = UDim.new(1, 0)
local lStroke = Instance.new("UIStroke", LogoFN)
lStroke.Color = Color3.fromRGB(0, 255, 255)
lStroke.Thickness = 2

-- --- MAIN FRAME ---
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
local mStroke = Instance.new("UIStroke", MainFrame)
mStroke.Color = Color3.fromRGB(45, 45, 45)

-- Header & Close
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "FH4N HUB V4"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.Text = "-"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundTransparency = 1

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)

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
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(200, 200, 200)
    b.Font = Enum.Font.Gotham
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function() cb(b) end)
    return b
end

-- --- FITUR FLY DIRECTIONAL ---
local flying = false
local flySpeed = 50
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastCtrl = {f = 0, b = 0, l = 0, r = 0}

local function flyLogic()
    local p = game.Players.LocalPlayer
    local c = p.Character or p.CharacterAdded:Wait()
    local root = c:WaitForChild("HumanoidRootPart")
    local bg = Instance.new("BodyGyro", root)
    local bv = Instance.new("BodyVelocity", root)
    
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = root.CFrame
    
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.new(0, 0.1, 0)
    
    task.spawn(function()
        repeat wait()
            p.Character.Humanoid.PlatformStand = true
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                bv.Velocity = ((workspace.CurrentCamera.CFrame.LookVector * (ctrl.f + ctrl.b)) + ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - workspace.CurrentCamera.CFrame.p)) * flySpeed
                lastCtrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
            else
                bv.Velocity = Vector3.new(0, 0.1, 0)
            end
            bg.CFrame = workspace.CurrentCamera.CFrame
        until not flying
        ctrl = {f = 0, b = 0, l = 0, r = 0}
        lastCtrl = {f = 0, b = 0, l = 0, r = 0}
        p.Character.Humanoid.PlatformStand = false
        bg:Destroy()
        bv:Destroy()
    end)
end

-- Input Fly
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then ctrl.f = 1
    elseif input.KeyCode == Enum.KeyCode.S then ctrl.b = -1
    elseif input.KeyCode == Enum.KeyCode.A then ctrl.l = -1
    elseif input.KeyCode == Enum.KeyCode.D then ctrl.r = 1 end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then ctrl.f = 0
    elseif input.KeyCode == Enum.KeyCode.S then ctrl.b = 0
    elseif input.KeyCode == Enum.KeyCode.A then ctrl.l = 0
    elseif input.KeyCode == Enum.KeyCode.D then ctrl.r = 0 end
end)

AddBtn("Fly: OFF", function(b)
    flying = not flying
    if flying then
        b.Text = "Fly: ON"
        b.TextColor3 = Color3.fromRGB(0, 255, 255)
        flyLogic()
    else
        b.Text = "Fly: OFF"
        b.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end)

-- --- FITUR LAINNYA ---
local sOn = false
AddBtn("Speed: OFF", function(b)
    sOn = not sOn
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = sOn and 100 or 16
    b.Text = sOn and "Speed: ON" or "Speed: OFF"
    b.TextColor3 = sOn and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
end)

local ijOn = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if ijOn then game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)
AddBtn("InfJump: OFF", function(b)
    ijOn = not ijOn
    b.Text = ijOn and "InfJump: ON" or "InfJump: OFF"
    b.TextColor3 = ijOn and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
end)

local ncOn = false
game:GetService("RunService").Stepped:Connect(function()
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

AddBtn("Anti-AFK", function(b)
    local vu = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    b.Text = "Anti-AFK: ON"
    b.TextColor3 = Color3.fromRGB(0, 255, 255)
end)
