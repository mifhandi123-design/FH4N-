--[[
    FH4N HUB V7 - AUTO OFF & DESTROY SYSTEM
    Fitur: Fly, Speed, InfJump, Noclip, Anti-AFK
    Update: Auto-off all features on close
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LogoFN = Instance.new("TextButton")
local Container = Instance.new("ScrollingFrame")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "FH4N_V7"

-- State Global agar bisa dimatikan saat close
local flying = false
local sOn = false
local ijOn = false
local ncOn = false
local flySpeed = 50

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
Instance.new("UIStroke", LogoFN).Color = Color3.fromRGB(0, 255, 255)

-- --- MAIN FRAME ---
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 220, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(45, 45, 45)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "FH4N HUB V7"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.TextSize = 25

Container.Parent = MainFrame
Container.Position = UDim2.new(0, 10, 0, 45)
Container.Size = UDim2.new(1, -20, 1, -90)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 5)

-- --- FUNGSI RESET SEMUA FITUR ---
local function ResetAllFeatures()
    flying = false
    sOn = false
    ijOn = false
    ncOn = false
    
    local plr = game.Players.LocalPlayer
    local char = plr.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.PlatformStand = false
        end
        -- Reset Noclip
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
        -- Hapus BodyObjects Fly
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            if root:FindFirstChild("FlyVelocity") then root.FlyVelocity:Destroy() end
            if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
        end
    end
end

-- Tombol Tutup (Minimize)
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    LogoFN.Visible = true
end)

LogoFN.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    LogoFN.Visible = false
end)

-- Tombol DESTROY (Close & Auto Off)
local DestroyBtn = Instance.new("TextButton", MainFrame)
DestroyBtn.Size = UDim2.new(1, -20, 0, 35)
DestroyBtn.Position = UDim2.new(0, 10, 1, -40)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
DestroyBtn.Text = "CLOSE & STOP SCRIPT"
DestroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", DestroyBtn).CornerRadius = UDim.new(0, 8)

DestroyBtn.MouseButton1Click:Connect(function()
    ResetAllFeatures()
    ScreenGui:Destroy() -- Hapus UI Permanen
end)

-- --- FUNGSI HELPER UI ---
local function AddLabel(txt)
    local lbl = Instance.new("TextLabel", Container)
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = "--- " .. txt .. " ---"
    lbl.TextColor3 = Color3.fromRGB(100, 100, 100)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
end

local function AddBtn(txt, cb)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(200, 200, 200)
    b.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() cb(b) end)
    return b
end

-- --- LOGIKA FITUR ---

AddLabel("MOVEMENT")

-- Fly Mobile/PC
AddBtn("Fly: OFF", function(b)
    flying = not flying
    b.Text = flying and "Fly: ON" or "Fly: OFF"
    b.TextColor3 = flying and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
    
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    if flying then
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 9000

        task.spawn(function()
            while flying do
                RunService.RenderStepped:Wait()
                hum.PlatformStand = true
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    bv.Velocity = ((workspace.CurrentCamera.CFrame.LookVector * moveDir.Z * -flySpeed) + (workspace.CurrentCamera.CFrame.RightVector * moveDir.X * flySpeed))
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0)
                end
                bg.CFrame = workspace.CurrentCamera.CFrame
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            hum.PlatformStand = false
        end)
    end
end)

-- Speed
AddBtn("Speed: OFF", function(b)
    sOn = not sOn
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = sOn and 100 or 16
    b.Text = sOn and "Speed: ON" or "Speed: OFF"
    b.TextColor3 = sOn and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if ijOn and game.Players.LocalPlayer.Character then 
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") 
    end
end)
AddBtn("InfJump: OFF", function(b)
    ijOn = not ijOn
    b.Text = ijOn and "InfJump: ON" or "InfJump: OFF"
    b.TextColor3 = ijOn and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
end)

AddLabel("UTILITY")

-- Noclip
RunService.Stepped:Connect(function()
    if ncOn and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
AddBtn("Noclip: OFF", function(b)
    ncOn = not ncOn
    if not ncOn then -- Reset collision saat off
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
    b.Text = ncOn and "Noclip: ON" or "Noclip: OFF"
    b.TextColor3 = ncOn and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
end)

-- Anti-AFK
AddBtn("Anti-AFK", function(b)
    local vu = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        if ScreenGui.Parent then -- Hanya aktif jika script masih ada
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)
    b.Text = "Anti-AFK: ACTIVE"
    b.TextColor3 = Color3.fromRGB(0, 255, 255)
end)
