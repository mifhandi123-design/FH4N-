local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FH4N HUB | DELTA V2",
   LoadingTitle = "Loading FH4N HUB...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

-- Variabel Global
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false

-- FUNGSI TELEPORT
local function teleportToPlayer(targetName)
    targetName = targetName:lower()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name:lower():sub(1, #targetName) == targetName or v.DisplayName:lower():sub(1, #targetName) == targetName then
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                Rayfield:Notify({Title = "Teleport", Content = "Berhasil ke: " .. v.Name, Duration = 3})
                return
            end
        end
    end
    Rayfield:Notify({Title = "Error", Content = "Player tidak ditemukan!", Duration = 3})
end

-- FITUR CHAT COMMAND (Ketik di Chat: tp:nama)
Player.Chatted:Connect(function(msg)
    local split = msg:split(":")
    if split[1]:lower() == "tp" and split[2] then
        teleportToPlayer(split[2])
    end
end)

-- UI TELEPORT TAB
TeleportTab:CreateInput({
   Name = "Teleport ke Player",
   PlaceholderText = "Ketik Nama Player...",
   RemoveTextAfterFocusLost = true,
   Callback = function(Text)
      teleportToPlayer(Text)
   end,
})

TeleportTab:CreateLabel("Gunakan format 'tp:nama' di chat Roblox")

-- MAIN FEATURES (Speed, Jump, Noclip, Fly)
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
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) InfJump = Value end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid:ChangeState("Jumping")
    end
end)

MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value) Noclip = Value end,
})

RunService.Stepped:Connect(function()
    if Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

MainTab:CreateToggle({
   Name = "Fly (Mobile)",
   CurrentValue = false,
   Callback = function(Value)
      Flying = Value
      local Root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
      if not Root then return end
      if Flying then
         local bv = Instance.new("BodyVelocity", Root)
         bv.Name = "DeltaFly_BV"
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         local bg = Instance.new("BodyGyro", Root)
         bg.Name = "DeltaFly_BG"
         bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
         task.spawn(function()
            while Flying and Root.Parent do
               bv.Velocity = Camera.CFrame.LookVector * FlySpeed
               bg.CFrame = Camera.CFrame
               RunService.RenderStepped:Wait()
            end
            bv:Destroy() bg:Destroy()
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

Rayfield:Notify({
   Title = "FH4N HUB V2 Loaded",
   Content = "Ketik 'tp:nama' di chat untuk teleport!",
   Duration = 5,
})
