
if game.CoreGui:FindFirstChild("FH4N_Fixed") then game.CoreGui.FH4N_Fixed:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FH4N_Fixed"

local MainFrame = Instance.new("Frame", ScreenGui)
local Header = Instance.new("Frame", MainFrame)
local Title = Instance.new("TextLabel", Header)
local Container = Instance.new("ScrollingFrame", MainFrame)
local MinimizeBtn = Instance.new("TextButton", ScreenGui)

-- 1. SETUP TOMBOL MINIMIZE (FN —)
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 70, 0, 40)
MinimizeBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Biru
MinimizeBtn.Text = "FN —"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Hitam
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Draggable = true
MinimizeBtn.Active = true
local CornerBtn = Instance.new("UICorner", MinimizeBtn)

-- 2. SETUP MENU UTAMA (Bisa Digeser)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
local CornerMain = Instance.new("UICorner", MainFrame)

Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Biru
local CornerHead = Instance.new("UICorner", Header)

Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "FH4N HUB | FN BIGRONE"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1

Container.Size = UDim2.new(1, -10, 1, -50)
Container.Position = UDim2.new(0, 5, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 5)

-- 3. FUNGSI TOGGLE (MINIMIZE)
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 4. FITUR SCRIPT
local function CreateButton(txt, cb)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSans
    b.TextSize = 16
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

local Player = game.Players.LocalPlayer
local Noclip = false
local InfJump = false

CreateButton("Speed 100", function() Player.Character.Humanoid.WalkSpeed = 100 end)
CreateButton("Normal Speed", function() Player.Character.Humanoid.WalkSpeed = 16 end)
CreateButton("Noclip: OFF", function(b) 
    Noclip = not Noclip 
    script.Parent.Text = "Noclip: " .. (Noclip and "ON" or "OFF")
end)
CreateButton("Infinite Jump", function() InfJump = not InfJump end)
CreateButton("TP Player (Cek Chat)", function() 
    print("Gunakan chat 'tp:nama'")
end)

-- LOGIC LOOP
game:GetService("RunService").Stepped:Connect(function()
    if Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump then Player.Character.Humanoid:ChangeState("Jumping") end
end)

Player.Chatted:Connect(function(msg)
    if msg:sub(1,3) == "tp:" then
        local t = msg:sub(4):lower()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Name:lower():find(t) then
                Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)
