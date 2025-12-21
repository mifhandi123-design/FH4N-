local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "FH4N Hub 📱",
   LoadingTitle = "FH4N Hub Loading...",
   LoadingSubtitle = "Gon Freecss Edition",
   ConfigurationSaving = { Enabled = true, FolderName = "FH4N_Configs", FileName = "Main" },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Variables
local lp = game.Players.LocalPlayer
local flying = false
local flySpeed = 50
local InfJumpEnabled = false
local Noclip = false

-- [ TAB CONFIG ]
local MainTab = Window:CreateTab("Main Hacks", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- [ FLOATING BUTTON SETUP ]
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")

ScreenGui.Name = "GonFloatingButton"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.1, 0, 0.2, 0) -- Posisi awal tombol
ImageButton.Size = UDim2.new(0, 60, 0, 60) -- Ukuran tombol
ImageButton.Image = "rbxassetid://15335131557" -- Gambar Gon
ImageButton.Draggable = true -- Bisa digeser-geser di layar HP

-- Fungsi Klik Tombol untuk Buka/Tutup Menu
ImageButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    -- Rayfield biasanya menggunakan LeftControl sebagai default bind, 
    -- tombol ini akan memicu toggle menu.
end)

-- [ FEATURES ]

-- WalkSpeed & Fly Speed
MainTab:CreateSlider({
   Name = "Speed (Walk & Fly)",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      flySpeed = Value
      if lp.Character and lp.Character:FindFirstChild("Humanoid") then
          lp.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- Fly Mobile (Follow Camera)
local function toggleFly()
    if flying then flying = false else
        flying = true
        task.spawn(function()
            local root = lp.Character:WaitForChild("HumanoidRootPart")
            local bv = Instance.new("BodyVelocity", root)
            local bg = Instance.new("BodyGyro", root)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            while flying and lp.Character do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                bg.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
            bv:Destroy() bg:Destroy()
        end)
    end
end

MainTab:CreateToggle({
   Name = "Fly (Mobile)",
   CurrentValue = false,
   Callback = function(Value) toggleFly() end,
})

-- Noclip
game:GetService("RunService").Stepped:Connect(function()
    if Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

MainTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value) Noclip = Value end,
})

-- Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled then
        lp.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
    end
end)

MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) InfJumpEnabled = Value end,
})

-- ESP
MainTab:CreateButton({
   Name = "Player ESP",
   Callback = function()
      for _, player in pairs(game.Players:GetPlayers()) do
          if player ~= lp and player.Character then
              local h = Instance.new("Highlight", player.Character)
              h.FillColor = Color3.fromRGB(0, 255, 0)
          end
      end
   end,
})

-- Close Button
SettingsTab:CreateButton({
   Name = "Destroy Script (×)",
   Callback = function()
      ScreenGui:Destroy()
      Rayfield:Destroy()
   end,
})
