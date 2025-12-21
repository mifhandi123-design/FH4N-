local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FH4N HUB",
   LoadingTitle = "FN BIGRONE",
   LoadingSubtitle = "", -- Menghapus tulisan "by Gemini"
   ConfigurationSaving = {
      Enabled = false
   },
   CustomTheme = {
       HeaderColor = Color3.fromRGB(0, 0, 255), -- Header Biru
       AccentColor = Color3.fromRGB(0, 0, 255),
   }
})

-- Variabel Fitur
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false

-- TAB UTAMA (Logo FN)
local MainTab = Window:CreateTab("FN | Features", 4483362458)

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

MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) InfJump = Value end,
})

-- TAB EXTRA
local ExtraTab = Window:CreateTab("FN | Extra", 4483362458)

ExtraTab:CreateInput({
   Name = "Teleport Player",
   PlaceholderText = "Username...",
   Callback = function(Text)
       local target = Text:lower()
       for _, v in pairs(game.Players:GetPlayers()) do
           if v.Name:lower():sub(1, #target) == target or v.DisplayName:lower():sub(1, #target) == target then
               Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
           end
       end
   end,
})

-- Chat Command TP (tp:nama)
Player.Chatted:Connect(function(msg)
    local split = msg:split(":")
    if split[1]:lower() == "tp" and split[2] then
        local target = split[2]:lower()
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Name:lower():sub(1, #target) == target then
                Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- Loop Fitur
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
