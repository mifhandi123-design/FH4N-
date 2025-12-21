-- FH4N HUB - Tabbed System (Paling Rapi)
if game.CoreGui:FindFirstChild("FH4N_FINAL") then game.CoreGui.FH4N_FINAL:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local Header = Instance.new("Frame", MainFrame)
local Title = Instance.new("TextLabel", Header)
local TabContainer = Instance.new("Frame", MainFrame) -- Tempat tombol Tab
local ContentFrame = Instance.new("Frame", MainFrame) -- Tempat isi fitur
local PlayerPage = Instance.new("ScrollingFrame", ContentFrame)
local VisualPage = Instance.new("ScrollingFrame", ContentFrame)
local MinimizeBtn = Instance.new("TextButton", ScreenGui)

-- --- UTAMA ---
MainFrame.Size = UDim2.new(0, 280, 0, 350)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
Instance.new("UICorner", Header)

Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "FH4N HUB | TAB SYSTEM"
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

-- --- TAB NAVIGATION ---
TabContainer.Size = UDim2.new(1, 0, 0, 35)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local function CreateTabBtn(name, pos, page)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0.5, 0, 1, 0)
    btn.Position = pos
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    
    btn.MouseButton1Click:Connect(function()
        PlayerPage.Visible = false
        VisualPage.Visible = false
        page.Visible = true
    end)
    return btn
end

-- --- CONTENT PAGES ---
ContentFrame.Size = UDim2.new(1, -20, 1, -85)
ContentFrame.Position = UDim2.new(0, 10, 0, 75)
ContentFrame.BackgroundTransparency = 1

local function SetupPage(page)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.CanvasSize = UDim2.new(0, 0, 0, 600)
    page.ScrollBarThickness = 2
    local ly = Instance.new("UIListLayout", page)
    ly.Padding = UDim.new(0, 8)
    page.Visible = false
end

SetupPage(PlayerPage)
SetupPage(VisualPage)
PlayerPage.Visible = true -- Default page

CreateTabBtn("PLAYER", UDim2.new(0,0,0,0), PlayerPage)
CreateTabBtn("VISUAL", UDim2.new(0.5,0,0,0), VisualPage)

-- --- HELPER FUNCTIONS ---
local function CreateToggle(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", btn)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 80, 255) or Color3.fromRGB(40, 40, 40)
        callback(state)
    end)
end

-- ==========================================
-- ISI TAB PLAYER
-- ==========================================
local SpeedInput = Instance.new("TextBox", PlayerPage)
SpeedInput.Size = UDim2.new(1, 0, 0, 38)
SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedInput.PlaceholderText = "Set Speed (Enter)"
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SpeedInput)

local CurrentFlySpeed = 50
SpeedInput.FocusLost:Connect(function(e)
    if e then CurrentFlySpeed = tonumber(SpeedInput.Text) or 50; game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = CurrentFlySpeed end
end)

CreateToggle("Fly Analog", PlayerPage, function(state)
    Flying = state
    local char = game.Players.LocalPlayer.Character
    if Flying and char then
        local root = char.HumanoidRootPart
        local hum = char.Humanoid
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        local bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while Flying do
                local cam = workspace.CurrentCamera
                if hum.MoveDirection.Magnitude > 0 then
                    bv.Velocity = (cam.CFrame.LookVector * hum.MoveDirection.Magnitude) * CurrentFlySpeed
                else bv.Velocity = Vector3.new(0,0.1,0) end
                bg.CFrame = cam.CFrame
                task.wait()
            end
            bv:Destroy(); bg:Destroy()
        end)
    end
end)

CreateToggle("Noclip", PlayerPage, function(s) NoclipEnabled = s end)
CreateToggle("Infinite Jump", PlayerPage, function(s) InfJumpEnabled = s end)

local TPInput = Instance.new("TextBox", PlayerPage)
TPInput.Size = UDim2.new(1, 0, 0, 38)
TPInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TPInput.PlaceholderText = "TP Player Name (Enter)"
TPInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", TPInput)

TPInput.FocusLost:Connect(function(e)
    if e then
        local t = TPInput.Text:lower()
        for _,v in pairs(game.Players:GetPlayers()) do
            if v.Name:lower():find(t) then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame end
        end
    end
end)

-- ==========================================
-- ISI TAB VISUAL
-- ==========================================
CreateToggle("RTX 5080 Effects", VisualPage, function(state)
    local L = game.Lighting
    if state then
        local b = Instance.new("BloomEffect", L); b.Name = "RTXB"
        local c = Instance.new("ColorCorrectionEffect", L); c.Name = "RTXC"; c.Contrast = 0.2
    else
        if L:FindFirstChild("RTXB") then L.RTXB:Destroy() end
        if L:FindFirstChild("RTXC") then L.RTXC:Destroy() end
    end
end)

CreateToggle("PC Port (Extreme)", VisualPage, function(state)
    local L = game.Lighting
    if state then
        local a = Instance.new("Atmosphere", L); a.Name = "PCP"; a.Density = 0.3
        L.Brightness = 2.5
    else
        if L:FindFirstChild("PCP") then L.PCP:Destroy() end
        L.Brightness = 1
    end
end)

CreateToggle("Dynamic Shadows", VisualPage, function(state)
    game.Lighting.GlobalShadows = state
    game.Lighting.EnvironmentDiffuseScale = state and 1 or 0
    game.Lighting.EnvironmentSpecularScale = state and 1 or 0
end)

CreateToggle("ESP Player Name", VisualPage, function(s) ESP_Enabled = s end)

-- --- MINIMIZE & LOOPS ---
MinimizeBtn.Size = UDim2.new(0, 70, 0, 40)
MinimizeBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
MinimizeBtn.Text = "FN —"
Instance.new("UICorner", MinimizeBtn)
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled then game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping") end
end)

task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local tag = p.Character.Head:FindFirstChild("FN_ESP")
                if ESP_Enabled and not tag then
                    local bb = Instance.new("BillboardGui", p.Character.Head)
                    bb.Name = "FN_ESP"; bb.Size = UDim2.new(0, 100, 0, 50); bb.AlwaysOnTop = true; bb.ExtentsOffset = Vector3.new(0, 3, 0)
                    local lbl = Instance.new("TextLabel", bb); lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(255, 255, 255); lbl.TextStrokeTransparency = 0; lbl.Text = p.DisplayName or p.Name; lbl.Font = Enum.Font.SourceSansBold; lbl.TextSize = 12
                elseif not ESP_Enabled and tag then tag:Destroy() end
            end
        end
    end
end)
