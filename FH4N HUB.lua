local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "FH4N Hub — Modern Edition",
    SubTitle = "by Gemini",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Membuat efek blur transparan yang modern
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Keybind default
})

-- [ FLOATING BUTTON UNTUK MOBILE ]
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "FH4N_MobileToggle"
ScreenGui.Parent = game.CoreGui

ToggleButton.Name = "GonIcon"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Image = "rbxassetid://15335131557"
ToggleButton.Draggable = true 

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
end)

-- [ VARIABLES ]
local lp = game.Players.LocalPlayer
local flying = false
local flySpeed = 50
local infJump = false
local noclip = false
local antiAfk = true

-- [ TABS ]
local Tabs = {
    Main = Window:AddTab({ Title = "Movement", Icon = "run" }),
    Visual = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- --- MOVEMENT TAB ---
Tabs.Main:AddParagraph({
    Title = "Player Physics",
    Content = "Atur pergerakan karakter kamu di sini."
})

local SpeedSlider = Tabs.Main:AddSlider("SpeedSlider", {
    Title = "Walk Speed",
    Description = "Mengatur kecepatan lari karakter",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.WalkSpeed = Value
        end
    end
})

local JumpSlider = Tabs.Main:AddSlider("JumpSlider", {
    Title = "Jump Power (High Jump)",
    Description = "Mengatur ketinggian lompatan",
    Default = 50,
    Min = 50,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.UseJumpPower = true
            lp.Character.Humanoid.JumpPower = Value
        end
    end
})

Tabs.Main:AddDivider()

local FlyToggle = Tabs.Main:AddToggle("FlyToggle", {Title = "Fly Mobile", Default = false })
FlyToggle:OnChanged(function()
    flying = FlyToggle.Value
    if flying then
        task.spawn(function()
            local root = lp.Character:WaitForChild("HumanoidRootPart")
            local bv = Instance.new("BodyVelocity", root)
            local bg = Instance.new("BodyGyro", root)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            while flying and lp.Character do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                bg.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
            bv:Destroy() bg:Destroy()
        end)
    end
end)

Tabs.Main:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Default = 50, Min = 10, Max = 300, Rounding = 0,
    Callback = function(v) flySpeed = v end
})

local InfJumpToggle = Tabs.Main:AddToggle("InfJump", {Title = "Infinite Jump", Default = false })
InfJumpToggle:OnChanged(function() infJump = InfJumpToggle.Value end)

local NoclipToggle = Tabs.Main:AddToggle("Noclip", {Title = "Noclip", Default = false })
NoclipToggle:OnChanged(function() noclip = NoclipToggle.Value end)

-- --- VISUAL TAB ---
local EspToggle = Tabs.Visual:AddToggle("EspToggle", {Title = "Player ESP (Name/Dist/Chams)", Default = false })
EspToggle:OnChanged(function()
    local val = EspToggle.Value
    if val then
        _G.ESP_Loop = game:GetService("RunService").RenderStepped:Connect(function()
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not p.Character:FindFirstChild("Highlight") then
                        local h = Instance.new("Highlight", p.Character)
                        h.FillColor = Color3.fromRGB(0, 255, 150)
                    end
                end
            end
        end)
    else
        if _G.ESP_Loop then _G.ESP_Loop:Disconnect() end
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then
                p.Character.Highlight:Destroy()
            end
        end
    end
end)

-- --- SETTINGS ---
Tabs.Settings:AddToggle("AntiAFK", {Title = "Anti-AFK System", Default = true }):OnChanged(function(v) antiAfk = v end)

Tabs.Settings:AddButton({
    Title = "Destroy Script",
    Callback = function()
        ScreenGui:Destroy()
        Window:Destroy()
    end
})

-- [ LOGIC HANDLERS ]
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

lp.Idled:Connect(function()
    if antiAfk then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

Fluent:Notify({
    Title = "FH4N Hub Modern",
    Content = "Script berhasil dijalankan!",
    Duration = 5
})
