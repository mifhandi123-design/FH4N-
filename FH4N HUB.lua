--[[
    FH4N HUB - OFFICIAL
    Features: Fly, Speed, InfJump, Noclip, Anti-AFK, Server Finder, Anti-Hit, TP Search
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
local flying, sOn, ijOn, ncOn, ahOn = false, false, false, false, false
local flySpeed = 60

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
Instance.new("UIStroke", LogoFN).Color = Color3.fromRGB(0, 255, 255)

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -100)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 6)

-- --- UI HELPERS ---
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

-- --- FITUR TELEPORT SEARCH ---
AddLabel("TELEPORT")
local TPSearch = Instance.new("TextBox", Container)
TPSearch.Size = UDim2.new(1, 0, 0, 38)
TPSearch.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TPSearch.PlaceholderText = "[tp:nama player]"
TPSearch.Text = ""
TPSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
TPSearch.Font = Enum.Font.GothamMedium
TPSearch.TextSize = 14
Instance.new("UICorner", TPSearch).CornerRadius = UDim.new(0, 8)
local tpStroke = Instance.new("UIStroke", TPSearch)
tpStroke.Color = Color3.fromRGB(0, 255, 255)
tpStroke.Thickness = 1

TPSearch.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local targetName = TPSearch.Text:lower()
        -- Menghapus [tp:] jika user mengetiknya manual
        targetName = targetName:gsub("%[tp:", ""):gsub("%]", "")
        
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():sub(1, #targetName) == targetName or player.DisplayName:lower():sub(1, #targetName) == targetName then
                local myChar = Players.LocalPlayer.Character
                local targetChar = player.Character
                if myChar and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    TPSearch.Text = "Teleported to " .. player.DisplayName
                    task.wait(2)
                    TPSearch.Text = ""
                    break
                end
            end
        end
    end
end)

-- --- CATEGORIES LAIN ---
AddLabel("COMBAT")
AddBtn("Anti-Hit: OFF", nil, function(b)
    ahOn = not ahOn
    b.Text = ahOn and "Anti-Hit: ON" or "Anti-Hit: OFF"
    b.TextColor3 = ahOn and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
end)

AddLabel("MOVEMENT")
AddBtn("Fly: OFF", nil, function(b)
    flying = not flying
    b.Text = flying and "Fly: ON" or "Fly: OFF"
    local p = Players.LocalPlayer
    if flying and p.Character then
        local root = p.Character:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            while flying do
                RunService.RenderStepped:Wait()
                p.Character.Humanoid.PlatformStand = true
                local move = p.Character.Humanoid.MoveDirection
                bv.Velocity = (move.Magnitude > 0) and ((workspace.CurrentCamera.CFrame.LookVector * move.Z * -flySpeed) + (workspace.CurrentCamera.CFrame.RightVector * move.X * flySpeed)) or Vector3.new(0, 0.1, 0)
                bg.CFrame = workspace.CurrentCamera.CFrame
            end
            bv:Destroy() bg:Destroy() p.Character.Humanoid.PlatformStand = false
        end)
    end
end)

AddBtn("Speed: OFF", nil, function(b)
    sOn = not sOn
    Players.LocalPlayer.Character.Humanoid.WalkSpeed = sOn and 100 or 16
    b.Text = sOn and "Speed: ON" or "Speed: OFF"
end)

AddLabel("SERVER")
AddBtn("Join Small Server", Color3.fromRGB(0, 120, 200), function(b)
    b.Text = "Searching..."
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local raw = game:HttpGet(Api)
    local decoded = HttpService:JSONDecode(raw)
    if decoded and decoded.data then
        for _, s in pairs(decoded.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, Players.LocalPlayer)
                break
            end
        end
    end
end)

AddLabel("UTILITY")
AddBtn("Noclip: OFF", nil, function(b)
    ncOn = not ncOn
    b.Text = ncOn and "Noclip: ON" or "Noclip: OFF"
end)

AddBtn("CLOSE HUB", Color3.fromRGB(120, 0, 0), function()
    flying = false
    sOn = false
    ahOn = false
    if Players.LocalPlayer.Character then Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 end
    ScreenGui:Destroy()
end)

-- --- BACKGROUND LOGIC ---
RunService.Stepped:Connect(function()
    local char = Players.LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                if ncOn then v.CanCollide = false end
                if ahOn and v.Name ~= "HumanoidRootPart" then v.CanTouch = false end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if ijOn then Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping") end
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
