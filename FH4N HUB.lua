--[[
    FH4N HUB - OFFICIAL
    Fitur: Fly, Speed, InfJump, Noclip, Anti-AFK, Server Finder
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LogoFN = Instance.new("TextButton")
local Container = Instance.new("ScrollingFrame")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "FH4N_Hub"

-- Global States
local flying, sOn, ijOn, ncOn = false, false, false, false
local flySpeed = 60

-- --- LOGO FN (MINIMIZE) ---
LogoFN.Parent = ScreenGui
LogoFN.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LogoFN.Position = UDim2.new(0.05, 0, 0.4, 0)
LogoFN.Size = UDim2.new(0, 60, 0, 60)
LogoFN.Visible = false
LogoFN.Text = "FN"
LogoFN.TextColor3 = Color3.fromRGB(0, 255, 255)
LogoFN.TextSize = 24
LogoFN.Font = Enum.Font.GothamBold
Instance.new("UICorner", LogoFN).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", LogoFN).Color = Color3.fromRGB(0, 255, 255)

-- --- MAIN FRAME ---
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 220, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(45, 45, 45)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "FH4N HUB"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 7)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.TextSize = 25

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 50)
Container.Size = UDim2.new(1, -20, 1, -100)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 6)

-- --- FUNGSI RESET ---
local function Shutdown()
    flying = false
    sOn = false
    ncOn = false
    local char = game.Players.LocalPlayer.Character
    if char then
        char.Humanoid.WalkSpeed = 16
        char.Humanoid.PlatformStand = false
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
    ScreenGui:Destroy()
end

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

-- --- FEATURES ---

AddLabel("SERVER")
AddBtn("Join Small Server", Color3.fromRGB(0, 120, 200), function(b)
    b.Text = "Searching..."
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local raw = game:HttpGet(Api)
    local decoded = HttpService:JSONDecode(raw)
    if decoded and decoded.data then
        for _, s in pairs(decoded.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, game.Players.LocalPlayer)
                break
            end
        end
    end
end)

AddLabel("MOVEMENT")
AddBtn("Fly: OFF", nil, function(b)
    flying = not flying
    b.Text = flying and "Fly: ON" or "Fly: OFF"
    b.TextColor3 = flying and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
    local p = game.Players.LocalPlayer
    local c = p.Character
    if flying and c then
        local root = c:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 9000
        task.spawn(function()
            while flying do
                RunService.RenderStepped:Wait()
                c.Humanoid.PlatformStand = true
                local move = c.Humanoid.MoveDirection
                bv.Velocity = (move.Magnitude > 0) and ((workspace.CurrentCamera.CFrame.LookVector * move.Z * -flySpeed) + (workspace.CurrentCamera.CFrame.RightVector * move.X * flySpeed)) or Vector3.new(0, 0.1, 0)
                bg.CFrame = workspace.CurrentCamera.CFrame
            end
            bv:Destroy() bg:Destroy() c.Humanoid.PlatformStand = false
        end)
    end
end)

AddBtn("Speed: OFF", nil, function(b)
    sOn = not sOn
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = sOn and 100 or 16
    b.Text = sOn and "Speed: ON" or "Speed: OFF"
    b.TextColor3 = sOn and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
end)

AddBtn("InfJump: OFF", nil, function(b)
    ijOn = not ijOn
    b.Text = ijOn and "InfJump: ON" or "InfJump: OFF"
    b.TextColor3 = ijOn and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
end)

AddLabel("UTILITY")
AddBtn("Noclip: OFF", nil, function(b)
    ncOn = not ncOn
    b.Text = ncOn and "Noclip: ON" or "Noclip: OFF"
    b.TextColor3 = ncOn and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
end)

AddBtn("Anti-AFK", nil, function(b)
    game.Players.LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    b.Text = "Anti-AFK: ON"
end)

local Close = AddBtn("CLOSE HUB", Color3.fromRGB(120, 0, 0), function()
    Shutdown()
end)

-- Noclip Logic
RunService.Stepped:Connect(function()
    if ncOn and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Jump Logic
UserInputService.JumpRequest:Connect(function()
    if ijOn then game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping") end
end)

-- Minimize Logic
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false LogoFN.Visible = true end)
LogoFN.MouseButton1Click:Connect(function() MainFrame.Visible = true LogoFN.Visible = false end)
