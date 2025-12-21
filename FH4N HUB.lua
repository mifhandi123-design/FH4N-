local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FH4N HUB",
   LoadingTitle = "FN BIGRONE",
   LoadingSubtitle = "", 
   ConfigurationSaving = { Enabled = false },
   CustomTheme = {
       HeaderColor = Color3.fromRGB(0, 0, 255), -- Header Biru
       AccentColor = Color3.fromRGB(0, 0, 255),
   }
})

-- --- SISTEM MINIMIZE "FN —" PERBAIKAN TOTAL ---
local ScreenGui = Instance.new("ScreenGui")
local MinimizeBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "FN_System_Fixed"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MinimizeBtn.Name = "FN_Toggle"
MinimizeBtn.Parent = ScreenGui
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Latar Biru
MinimizeBtn.Position = UDim2.new(0.05, 0, 0.4, 0) -- Posisi kiri tengah agar tidak mengganggu
MinimizeBtn.Size = UDim2.new(0, 70, 0, 40)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Text = "FN —" 
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Tulisan Hitam
MinimizeBtn.TextSize = 20
MinimizeBtn.Active = true
MinimizeBtn.Draggable = true 

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MinimizeBtn

UIStroke.Parent = MinimizeBtn
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 255, 255)

-- Fungsi Toggle yang Memperbaiki Masalah "Sama Saja"
MinimizeBtn.MouseButton1Click:Connect(function()
    local rayfieldUI = game:GetService("CoreGui"):FindFirstChild("Rayfield")
    if rayfieldUI then
        -- Mencari Frame utama Rayfield untuk disembunyikan secara manual
        for _, v in pairs(rayfieldUI:GetChildren()) do
            if v:IsA("Frame") or v:IsA("CanvasGroup") then
                v.Visible = not v.Visible
            end
        end
    end
end)

-- --- FITUR SCRIPT ---
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local FlySpeed = 50
local Flying = false
local Noclip = false
local InfJump = false
local ESP_Enabled = false

local MainTab = Window:CreateTab("FN | Features", 4483362458)
local ExtraTab = Window:CreateTab("FN | Visual & TP", 4483362458)

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
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         task.spawn(function()
            while Flying and Root.Parent do
               bv.Velocity = Camera.CFrame.LookVector * FlySpeed
               RunService.RenderStepped:Wait()
            end
            if bv then bv:Destroy() end
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

ExtraTab:CreateToggle({
   Name = "Player ESP (Nama)",
   CurrentValue = false,
   Callback = function(Value) ESP_Enabled = Value end,
})

-- ESP Logic
task.spawn(function()
    while task.wait(1) do
        if ESP_Enabled then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("Head") then
                    if not p.Character.Head:FindFirstChild("FN_Tag") then
                        local bb = Instance.new("BillboardGui", p.Character.Head)
                        bb.Name = "FN_Tag"
                        bb.Size = UDim2.new(0, 200, 0, 50)
                        bb.AlwaysOnTop = true
                        bb.ExtentsOffset = Vector3.new(0, 3, 0)
                        local lbl = Instance.new("TextLabel", bb)
                        lbl.BackgroundTransparency = 1
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.Text = p.Name
                        lbl.Font = Enum.Font.SourceSansBold
                        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                        lbl.TextSize = 14
                    end
                end
            end
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character.Head:FindFirstChild("FN_Tag") then
                    p.Character.Head.FN_Tag:Destroy()
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

-- Sistem Noclip & Jump Loop
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
