
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

Header.Name = "Header"
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
Container.CanvasSize = UDim2.new(0, 0, 2, 0)
Container.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 10)

-- FUNGSI TOMBOL MINIMIZE
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- --- FITUR SPEED (DIPERBAIKI) ---
local SpeedTitle = Instance.new("TextLabel", Container)
SpeedTitle.Size = UDim2.new(1, 0, 0, 20)
SpeedTitle.Text = "Set WalkSpeed:"
SpeedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTitle.BackgroundTransparency = 1

local SpeedInput = Instance.new("TextBox", Container)
SpeedInput.Size = UDim2.new(1, 0, 0, 40)
SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedInput.PlaceholderText = "Ketik angka (Contoh: 100)"
SpeedInput.Text = ""
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SpeedInput)

SpeedInput.FocusLost:Connect(function(enter)
    if enter then
        local num = tonumber(SpeedInput.Text)
        if num then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num
        end
    end
end)

-- --- FITUR TELEPORT (DIPERBAIKI) ---
local TPTitle = Instance.new("TextLabel", Container)
TPTitle.Size = UDim2.new(1, 0, 0, 20)
TPTitle.Text = "Teleport Player:"
TPTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TPTitle.BackgroundTransparency = 1

local TPInput = Instance.new("TextBox", Container)
TPInput.Size = UDim2.new(1, 0, 0, 40)
TPInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TPInput.PlaceholderText = "Ketik Nama Player..."
TPInput.Text = ""
TPInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TPInput)

local function doTeleport(name)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():find(name:lower()) or v.DisplayName:lower():find(name:lower()) then
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
end

TPInput.FocusLost:Connect(function(enter)
    if enter and TPInput.Text ~= "" then
        doTeleport(TPInput.Text)
    end
end)

-- Tombol Reset Speed
local ResetBtn = Instance.new("TextButton", Container)
ResetBtn.Size = UDim2.new(1, 0, 0, 40)
ResetBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ResetBtn.Text = "Reset Speed (16)"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ResetBtn)
ResetBtn.MouseButton1Click:Connect(function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    SpeedInput.Text = ""
end)

-- Chat Command TP
game.Players.LocalPlayer.Chatted:Connect(function(msg)
    if msg:sub(1,3) == "tp:" then
        doTeleport(msg:sub(4))
    end
end)
