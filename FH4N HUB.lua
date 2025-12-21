-- FH4N HUB - No Library Version (Pasti Jalan)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FlyBtn = Instance.new("TextButton")
local SpeedBtn = Instance.new("TextButton")
local NoclipBtn = Instance.new("TextButton")
local InfJumpBtn = Instance.new("TextButton")
local TPInput = Instance.new("TextBox")

-- Properti UI
ScreenGui.Parent = game.CoreGui
MainFrame.Name = "FH4NHUB"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Header Biru
Title.Text = "FH4N HUB (FN)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

-- Tombol Fly
FlyBtn.Parent = MainFrame
FlyBtn.Position = UDim2.new(0, 10, 0, 50)
FlyBtn.Size = UDim2.new(0, 180, 0, 40)
FlyBtn.Text = "Fly: OFF"
FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tombol Speed
SpeedBtn.Parent = MainFrame
SpeedBtn.Position = UDim2.new(0, 10, 0, 100)
SpeedBtn.Size = UDim2.new(0, 180, 0, 40)
SpeedBtn.Text = "Speed: 100"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tombol Noclip
NoclipBtn.Parent = MainFrame
NoclipBtn.Position = UDim2.new(0, 10, 0, 150)
NoclipBtn.Size = UDim2.new(0, 180, 0, 40)
NoclipBtn.Text = "Noclip: OFF"
NoclipBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Tombol InfJump
InfJumpBtn.Parent = MainFrame
InfJumpBtn.Position = UDim2.new(0, 10, 0, 200)
InfJumpBtn.Size = UDim2.new(0, 180, 0, 40)
InfJumpBtn.Text = "InfJump: OFF"
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InfJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Input Teleport
TPInput.Parent = MainFrame
TPInput.Position = UDim2.new(0, 10, 0, 250)
TPInput.Size = UDim2.new(0, 180, 0, 40)
TPInput.PlaceholderText = "TP Nama Player..."
TPInput.Text = ""

-- FUNGSI FITUR
local Player = game.Players.LocalPlayer
local Flying = false
local Noclip = false
local InfJump = false

-- Speed Function
SpeedBtn.MouseButton1Click:Connect(function()
    if Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = 100
        SpeedBtn.Text = "Speed: ACTIVE"
    end
end)

-- InfJump Function
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)
InfJumpBtn.MouseButton1Click:Connect(function()
    InfJump = not InfJump
    InfJumpBtn.Text = "InfJump: " .. (InfJump and "ON" or "OFF")
end)

-- Noclip Function
game:GetService("RunService").Stepped:Connect(function()
    if Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
NoclipBtn.MouseButton1Click:Connect(function()
    Noclip = not Noclip
    NoclipBtn.Text = "Noclip: " .. (Noclip and "ON" or "OFF")
end)

-- Fly Function (Mobile Camera)
FlyBtn.MouseButton1Click:Connect(function()
    Flying = not Flying
    FlyBtn.Text = "Fly: " .. (Flying and "ON" or "OFF")
    local Root = Player.Character.HumanoidRootPart
    if Flying then
        local bv = Instance.new("BodyVelocity", Root)
        bv.Name = "FN_Fly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while Flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- Teleport Chat & Input
local function tpTo(name)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():find(name:lower()) then
            Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
        end
    end
end

TPInput.FocusLost:Connect(function() tpTo(TPInput.Text) end)
Player.Chatted:Connect(function(msg)
    if msg:sub(1,3) == "tp:" then tpTo(msg:sub(4)) end
end)
