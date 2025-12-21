-- FH4N HUB (Versi Perbaikan Speed & TP)
if game.CoreGui:FindFirstChild("FH4N_Final") then game.CoreGui.FH4N_Final:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FH4N_Final"

-- 1. TOMBOL MINIMIZE (FN —)
local MinimizeBtn = Instance.new("TextButton", ScreenGui)
MinimizeBtn.Size = UDim2.new(0, 70, 0, 40)
MinimizeBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
MinimizeBtn.Text = "FN —"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Draggable = true
MinimizeBtn.Active = true
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 10)

-- 2. MENU UTAMA
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 320)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Draggable = true
MainFrame.Active = true
Instance.new("UICorner", MainFrame)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "FH4N HUB | FN BIGRONE"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1

local Container = Instance.new("ScrollingFrame", MainFrame)
Container.Size = UDim2.new(1, -10, 1, -50)
Container.Position = UDim2.new(0, 5, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.8, 0)
Container.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 10)

-- 3. FUNGSI TOGGLE MINIMIZE
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 4. FITUR SPEED (BISA DIATUR)
local SpeedLabel = Instance.new("TextLabel", Container)
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Text = "WalkSpeed: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.BackgroundTransparency = 1

local SpeedInput = Instance.new("TextBox", Container)
SpeedInput.Size = UDim2.new(1, -10, 0, 35)
SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedInput.PlaceholderText = "Masukkan Angka (16-500)..."
SpeedInput.Text = ""
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SpeedInput)

SpeedInput.FocusLost:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
        SpeedLabel.Text = "WalkSpeed: " .. val
    end
end)

-- 5. FITUR TELEPORT (PERBAIKAN)
local TPLabel = Instance.new("TextLabel", Container)
TPLabel.Size = UDim2.new(1, 0, 0, 20)
TPLabel.Text = "Teleport Player"
TPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TPLabel.BackgroundTransparency = 1

local TPInput = Instance.new("TextBox", Container)
TPInput.Size = UDim2.new(1, -10, 0, 35)
TPInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TPInput.PlaceholderText = "Masukkan Nama Player..."
TPInput.Text = ""
TPInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TPInput)

local function teleportTo(targetName)
    targetName = targetName:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and (v.Name:lower():find(targetName) or v.DisplayName:lower():find(targetName)) then
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                return
            end
        end
    end
end

TPInput.FocusLost:Connect(function()
    if TPInput.Text ~= "" then
        teleportTo(TPInput.Text)
    end
end)

-- 6. FITUR LAINNYA
local function CreateToggle(txt, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = txt .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = txt .. (state and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(45, 45, 45)
        callback(state)
    end)
end

local Noclip = false
CreateToggle("Noclip", function(v) Noclip = v end)

local InfJump = false
CreateToggle("Infinite Jump", function(v) InfJump = v end)

-- LOGIC LOOP
game:GetService("RunService").Stepped:Connect(function()
    if Noclip and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump then game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping") end
end)

-- CHAT COMMAND TP
game.Players.LocalPlayer.Chatted:Connect(function(msg)
    if msg:sub(1,3) == "tp:" then
        teleportTo(msg:sub(4))
    end
end)
