--[[
    FH4N HUB - OFFICIAL (GOD MODE V4)
    Metode: Position Spoofing & Gravity Bypass
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LogoFN = Instance.new("TextButton")
local Container = Instance.new("ScrollingFrame")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "FH4N_Hub_Official"

-- Global States
local flying, sOn, ijOn, ncOn, ahOn, adOn, espOn = false, false, false, false, false, false, false
local flySpeed = 60

-- --- UI SETUP (Sama seperti sebelumnya) ---
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 220, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(45, 45, 45)

LogoFN.Parent = ScreenGui
LogoFN.Visible = false
LogoFN.Text = "FN"
LogoFN.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LogoFN.Size = UDim2.new(0, 60, 0, 60)
LogoFN.Position = UDim2.new(0.05, 0, 0.4, 0)
LogoFN.TextColor3 = Color3.fromRGB(0, 255, 255)
LogoFN.Font = Enum.Font.GothamBold
Instance.new("UICorner", LogoFN).CornerRadius = UDim.new(1, 0)

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -60)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 6)

local function AddLabel(txt)
    local lbl = Instance.new("TextLabel", Container)
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = "--- " .. txt .. " ---"
    lbl.TextColor3 = Color3.fromRGB(120, 120, 120)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
end

local function AddBtn(txt, color, cb)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = color or Color3.fromRGB(30, 30, 30)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function() cb(b) end)
    return b
end

-- --- RGB TAG & IDENTITY ---
local function CreateRGBTag(player)
    if not player.Character then return end
    local head = player.Character:WaitForChild("Head", 5)
    if head:FindFirstChild("FH4N_Tag") then head.FH4N_Tag:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "FH4N_Tag"
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.AlwaysOnTop = true
    bb.ExtentsOffset = Vector3.new(0, 3, 0)
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "FH4N\n" .. player.DisplayName
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    task.spawn(function()
        while bb and lbl do
            lbl.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
            task.wait()
        end
    end)
end
CreateRGBTag(Players.LocalPlayer)

-- --- BUTTONS ---
AddLabel("COMBAT")
AddBtn("ULTIMATE ANTI-HIT: OFF", nil, function(b)
    ahOn = not ahOn
    b.Text = ahOn and "ULTIMATE ANTI-HIT: ON" or "ULTIMATE ANTI-HIT: OFF"
    b.TextColor3 = ahOn and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
end)

AddBtn("Auto Dodge: OFF", nil, function(b)
    adOn = not adOn
    b.Text = adOn and "Auto Dodge: ON" or "Auto Dodge: OFF"
    b.TextColor3 = adOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

AddLabel("VISUAL")
AddBtn("ESP Highlight: OFF", nil, function(b)
    espOn = not espOn
    b.Text = espOn and "ESP Highlight: ON" or "ESP Highlight: OFF"
end)

AddLabel("MOVEMENT")
AddBtn("Speed: OFF", nil, function(b)
    sOn = not sOn
    Players.LocalPlayer.Character.Humanoid.WalkSpeed = sOn and 100 or 16
end)

AddLabel("SERVER")
AddBtn("Join Small Server", Color3.fromRGB(0, 120, 200), function()
    -- Join Small Server Logic
end)

-- --- ULTIMATE LOGIC LOOP ---
RunService.Stepped:Connect(function()
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        
        -- ANTI-HIT V4 (SPOOFING)
        if ahOn then
            -- Ini akan membuat Hitbox kamu "bergetar" sangat ekstrem antara posisi asli dan 1000 kaki di udara
            -- Server akan bingung menentukan posisi aslimu untuk memberikan damage
            local originalCF = char.HumanoidRootPart.CFrame
            char.HumanoidRootPart.CFrame = originalCF * CFrame.new(0, 1000, 0)
            RunService.RenderStepped:Wait()
            char.HumanoidRootPart.CFrame = originalCF
            
            -- Menghapus semua TouchInterest musuh secara paksa
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanTouch = false
                end
            end
        end

        -- AUTO DODGE
        if adOn then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 35 then
                        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, 10)
                    end
                end
            end
        end

        -- ESP
        if espOn then
            -- ESP Logic
        end
    end
end)

-- Minimize
local minBtn = Instance.new("TextButton", MainFrame)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 7)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 1
minBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false LogoFN.Visible = true end)
LogoFN.MouseButton1Click:Connect(function() MainFrame.Visible = true LogoFN.Visible = false end)
