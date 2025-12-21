-- Memastikan jika ada UI lama akan terhapus
if game.CoreGui:FindFirstChild("FH4NHUB_Mobile") then
    game.CoreGui.FH4NHUB_Mobile:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Header = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Setup UI Utama
ScreenGui.Name = "FH4NHUB_Mobile"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser di layar

-- Header Biru dengan Logo FN
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- BIRU
Header.Size = UDim2.new(1, 0, 0, 45)

Title.Name = "Title"
Title.Parent = Header
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "FN BIGRONE | FH4N HUB" -- Nama Sesuai Permintaan
Title.TextColor3 = Color3.fromRGB(0, 0, 0) -- TULISAN FN HITAM (Sesuai Permintaan)
Title.TextSize = 20

Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 5, 0, 50)
Container.Size = UDim2.new(0, 240, 0, 260)
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Container.ScrollBarThickness = 4

UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Fungsi Membuat Button
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Font = Enum.Font.SourceSansSemibold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Variabel Fitur
local Player = game.Players.LocalPlayer
local Flying = false
local Noclip = false
local InfJump = false
local SpeedActive = false

-- FITUR 1: SPEED
CreateButton("Speed: 100 (Toggle)", function()
    SpeedActive = not SpeedActive
    if SpeedActive then
        Player.Character.Humanoid.WalkSpeed = 100
    else
        Player.Character.Humanoid.WalkSpeed = 16
    end
end)

-- FITUR 2: FLY MOBILE
CreateButton("Fly (Mobile)", function()
    Flying = not Flying
    local Root = Player.Character.HumanoidRootPart
    if Flying then
        local bv = Instance.new("BodyVelocity", Root)
        bv.Name = "FN_Fly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while Flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 70
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- FITUR 3: NOCLIP
CreateButton("Noclip (Tembus)", function()
    Noclip = not Noclip
end)

game:GetService("RunService").Stepped:Connect(function()
    if Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- FITUR 4: INF JUMP
CreateButton("Infinite Jump", function()
    InfJump = not InfJump
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump then Player.Character.Humanoid:ChangeState("Jumping") end
end)

-- FITUR 5: TELEPORT CHAT
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

-- Tombol Close / Minimize
local Close = Instance.new("TextButton", Header)
Close.Text = "_"
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.MouseButton1Click:Connect(function()
    Container.Visible = not Container.Visible
    if Container.Visible then MainFrame.Size = UDim2.new(0, 250, 0, 320) else MainFrame.Size = UDim2.new(0, 250, 0, 45) end
end)
