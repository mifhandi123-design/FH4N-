local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FH4N HUB", -- Nama lengkap tetap FH4N HUB
   LoadingTitle = "FN HUB LOADING...", -- Menggunakan logo FN saat loading
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false },
   
   -- Kustomisasi Tema agar FN menonjol
   CustomTheme = {
       HeaderColor = Color3.fromRGB(0, 0, 255), -- Latar belakang Biru
       TextColor = Color3.fromRGB(255, 255, 255), -- Teks Putih
       AccentColor = Color3.fromRGB(0, 0, 255),
   },
})

-- Menambahkan Tab dengan Logo FN di depan nama tab (opsional untuk gaya)
local MainTab = Window:CreateTab("FN | Main", "rbxassetid://4483362458")
local VisualTab = Window:CreateTab("FN | Visuals", "rbxassetid://4483362458")
local TeleportTab = Window:CreateTab("FN | Teleport", "rbxassetid://4483362458")

-- Variabel Global
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false
local ESP_Enabled = false

-- FUNGSI TELEPORT
local function teleportToPlayer(targetName)
    targetName = targetName:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():sub(1, #targetName) == targetName or v.DisplayName:lower():sub(1, #targetName) == targetName then
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                return
            end
        end
    end
end

-- FITUR ESP
local ESP_Drawings = {}
local function CreateESP(TargetPlayer)
    if ESP_Drawings[TargetPlayer] then return end
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 0, 0)
    Box.Thickness = 1
    Box.Filled = false

    local Connection
    Connection = RunService.RenderStepped:Connect(function()
        if ESP_Enabled and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") and TargetPlayer ~= Player then
            local RootPart = TargetPlayer.Character.HumanoidRootPart
            local Position, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)
            if OnScreen then
                local HeadPos = Camera:WorldToViewportPoint(RootPart.Position + Vector3.new(0, 2.6, 0))
                local FootPos = Camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3, 0))
                local Height = FootPos.Y - HeadPos.Y
                Box.Size = Vector2.new(Height * 0.6, Height)
                Box.Position = Vector2.new(Position.X - Box.Size.X / 2, HeadPos.Y)
                Box.Visible = true
            else Box.Visible = false end
        else
            Box.Visible = false
            if not ESP_Enabled and Connection then
                Connection:Disconnect()
                Box:Remove()
                ESP_Drawings[TargetPlayer] = nil
            end
        end
    end)
    ESP_Drawings[TargetPlayer] = Box
end

-- TAB VISUALS
VisualTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(Value)
      ESP_Enabled = Value
      if Value then
          for _, p in pairs(game.Players:GetPlayers()) do
              if p ~= Player then CreateESP(p) end
          end
      end
   end,
})

-- TAB MAIN
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

MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 300},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value) FlySpeed = Value end,
})

MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value) Noclip = Value end
})

RunService.Stepped:Connect(function()
    if Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) InfJump = Value end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- TAB TELEPORT
TeleportTab:CreateInput({
   Name = "Teleport Player",
   PlaceholderText = "Username...",
   Callback = function(Text) teleportToPlayer(Text) end,
})

-- Chat Command (tp:nama)
Player.Chatted:Connect(function(msg)
    local split = msg:split(":")
    if split[1]:lower() == "tp" and split[2] then teleportToPlayer(split[2]) end
end)

Rayfield:Notify({Title = "FH4N HUB (FN) Loaded", Content = "Script siap digunakan!", Duration = 5})
