local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FH4N HUB",
   LoadingTitle = "FN BIGRONE",
   LoadingSubtitle = "", -- Menghapus tulisan 'by Gemini'
   ConfigurationSaving = { Enabled = false },
   CustomTheme = {
       HeaderColor = Color3.fromRGB(0, 0, 255), -- Header Biru
       AccentColor = Color3.fromRGB(0, 0, 255),
   }
})

-- --- FITUR MINIMIZE PERBAIKAN (LOGO FN) ---
local ScreenGui = Instance.new("ScreenGui")
local MinimizeButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "FN_Minimize_UI"
ScreenGui.Parent = game.CoreGui

MinimizeButton.Name = "FN_Btn"
MinimizeButton.Parent = ScreenGui
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
MinimizeButton.Position = UDim2.new(0.1, 0, 0.15, 0)
MinimizeButton.Size = UDim2.new(0, 50, 0, 50)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Text = "FN"
MinimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0) -- Logo FN Hitam
MinimizeButton.TextSize = 24
MinimizeButton.Active = true
MinimizeButton.Draggable = true -- Tombol FN bisa digeser

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MinimizeButton

MinimizeButton.MouseButton1Click:Connect(function()
    local targetUI = game:GetService("CoreGui"):FindFirstChild("Rayfield")
    if targetUI then
        targetUI.Enabled = not targetUI.Enabled
    end
end)

-- --- VARIABEL FITUR ---
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false
local ESP_Enabled = false

-- --- TABS ---
local MainTab = Window:CreateTab("FN | Main", 4483362458)
local ExtraTab = Window:CreateTab("FN | Extra", 4483362458)

-- --- FITUR MAIN ---
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      if Player.Character and Player.Character:FindFirstChild("Humanoid") then
         Player.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

MainTab:CreateToggle({
   Name = "Fly (Mobile)",
   CurrentValue = false,
   Callback = function(Value)
      Flying = Value
      local Root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
      if Flying and Root then
         local bv = Instance.new("BodyVelocity", Root)
         bv.Name = "FN_FlyBV"
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         local bg = Instance.new("BodyGyro", Root)
         bg.Name = "FN_FlyBG"
         bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
         task.spawn(function()
            while Flying and Root.Parent do
               bv.Velocity = Camera.CFrame.LookVector * FlySpeed
               bg.CFrame = Camera.CFrame
               RunService.RenderStepped:Wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
         end)
      end
   end,
})

MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value) Noclip = Value end
})

MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) InfJump = Value end,
})

-- --- FITUR EXTRA (ESP & TP) ---
ExtraTab:CreateToggle({
   Name = "Player ESP (Name)",
   CurrentValue = false,
   Callback = function(Value) ESP_Enabled = Value end,
})

-- ESP Logic (Name Only)
task.spawn(function()
    while task.wait(1) do
        if ESP_Enabled then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("Head") then
                    if not p.Character.Head:FindFirstChild("FN_NameTag") then
                        local billboard = Instance.new("BillboardGui", p.Character.Head)
                        billboard.Name = "FN_NameTag"
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.AlwaysOnTop = true
                        billboard.ExtentsOffset = Vector3.new(0, 3, 0)
                        local label = Instance.new("TextLabel", billboard)
                        label.BackgroundTransparency = 1
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.Text = p.Name
                        label.Font = Enum.Font.SourceSansBold
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.TextSize = 14
                    end
                end
            end
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character.Head:FindFirstChild("FN_NameTag") then
                    p.Character.Head.FN_NameTag:Destroy()
                end
            end
        end
    end
end)

ExtraTab:CreateInput({
   Name = "TP Player",
   PlaceholderText = "Ketik Nama...",
   Callback = function(Text)
       local target = Text:lower()
       for _, v in pairs(game.Players:GetPlayers()) do
           if v.Name:lower():find(target) then
               Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
           end
       end
   end,
})

-- Chat Command TP (tp:nama)
Player.Chatted:Connect(function(msg)
    if msg:sub(1,3) == "tp:" then
        local target = msg:sub(4):lower()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Name:lower():find(target) then
                Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- --- LOOP SISTEM ---
RunService.Stepped:Connect(function()
    if Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid:ChangeState("Jumping")
    end
end)
