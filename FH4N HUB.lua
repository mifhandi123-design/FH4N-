--[[
    FH4N HUB - OFFICIAL
    Features: Fly, Speed, InfJump, Noclip, Anti-Hit V3, Auto Dodge, Anti-Lag, ESP, RGB Tag
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
local Lighting = game:GetService("Lighting")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "FH4N_Hub_Official"

-- Global States
local flying, sOn, ijOn, ncOn, ahOn, adOn, espOn = false, false, false, false, false, false, false
local flySpeed = 60
local dodgeRadius = 35 

-- --- UI SETUP ---
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

-- --- RGB TAG LOGIC (SPECIAL FOR USERS) ---
local function CreateRGBTag(player)
    local char = player.Character or player.CharacterAdded:Wait()
    local head = char:WaitForChild("Head")
    
    if head:FindFirstChild("FH4N_Tag") then head.FH4N_Tag:Destroy() end
    
    local billboard = Instance.new("BillboardGui", head)
    billboard.Name = "FH4N_Tag"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.ExtentsOffset = Vector3.new(0, 3, 0)
    
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "FH4N\n" .. player.DisplayName
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    
    task.spawn(function()
        while billboard and label do
            local hue = tick() % 5 / 5
            label.TextColor3 = Color3.fromHSV(hue, 1, 1)
            task.wait()
        end
    end)
end

-- Terapkan RGB ke diri sendiri saat script jalan
CreateRGBTag(Players.LocalPlayer)

-- --- FEATURES ---
AddLabel("TELEPORT")
local TPSearch = Instance.new("TextBox", Container)
TPSearch.Size = UDim2.new(1, 0, 0, 38)
TPSearch.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TPSearch.PlaceholderText = "[tp:nama player]"
TPSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
TPSearch.Font = Enum.Font.GothamMedium
Instance.new("UICorner", TPSearch).CornerRadius = UDim.new(0, 8)
TPSearch.FocusLost:Connect(function(ep)
    if ep then
        local target = TPSearch.Text:lower()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer and p.Name:lower():find(target) then
                Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                break
            end
        end
    end
end)

AddLabel("COMBAT")
AddBtn("Anti-Hit: OFF", nil, function(b)
    ahOn = not ahOn
    b.Text = ahOn and "Anti-Hit: ON" or "Anti-Hit: OFF"
    b.TextColor3 = ahOn and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
end)

AddBtn("Auto Dodge: OFF", nil, function(b)
    adOn = not adOn
    b.Text = adOn and "Auto Dodge: ON" or "Auto Dodge: OFF"
    b.TextColor3 = adOn and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

AddLabel("VISUAL")
AddBtn("ESP Player: OFF", nil, function(b)
    espOn = not espOn
    b.Text = espOn and "ESP Player: ON" or "ESP Player: OFF"
    if not espOn then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
        end
    end
end)

AddLabel("MOVEMENT")
AddBtn("Fly: OFF", nil, function(b)
    flying = not flying
    b.Text = flying and "Fly: ON" or "Fly: OFF"
    -- (Logic Fly tetap sama seperti sebelumnya)
end)

AddBtn("Speed: OFF", nil, function(b)
    sOn = not sOn
    Players.LocalPlayer.Character.Humanoid.WalkSpeed = sOn and 100 or 16
    b.Text = sOn and "Speed: ON" or "Speed: OFF"
end)

AddLabel("UTILITY")
AddBtn("Anti-Lag", Color3.fromRGB(80, 80, 80), function()
    -- (Logic Anti-Lag tetap sama)
end)

AddBtn("Infinite Jump: OFF", nil, function(b)
    ijOn = not ijOn
    b.Text = ijOn and "InfJump: ON" or "InfJump: OFF"
end)

AddLabel("SERVER")
AddBtn("Join Small Server", Color3.fromRGB(0, 120, 200), function()
    -- (Logic Server Finder tetap sama)
end)

-- --- MAIN LOGICS ---
RunService.RenderStepped:Connect(function()
    local lp = Players.LocalPlayer
    
    -- ESP Logic
    if espOn then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not p.Character:FindFirstChild("Highlight") then
                    local high = Instance.new("Highlight", p.Character)
                    high.FillColor = Color3.fromRGB(255, 0, 0)
                    high.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end

    -- Combat Logics (Anti-Hit & Auto Dodge)
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        if ahOn then
            lp.Character.HumanoidRootPart.Velocity = Vector3.new(0, -100, 0)
        end
        
        if adOn then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 13 then
                        local dir = (lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Unit
                        lp.Character.HumanoidRootPart.CFrame += dir * 15
                    end
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function() if ijOn then Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)

-- Minimize Logic
local minBtn = Instance.new("TextButton", MainFrame)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 7)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 1
minBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false LogoFN.Visible = true end)
LogoFN.MouseButton1Click:Connect(function() MainFrame.Visible = true LogoFN.Visible = false end)
