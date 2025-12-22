-- SCRIPT INI TIDAK PAKAI MENU (LANGSUNG AKTIF)
-- TEKAN TOMBOL DI KEYBOARD ATAU GUNAKAN COMMAND

print("FH4N HUB LOADED!")

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")
local Mouse = Player:GetMouse()

-- 1. SPEED & JUMP (LANGSUNG SET)
Humanoid.WalkSpeed = 100
Humanoid.JumpPower = 100
Humanoid.UseJumpPower = true

-- 2. FLY & NOCLIP (TEKAN 'E' UNTUK TERBANG)
local Flying = false
Mouse.KeyDown:Connect(function(key)
    if key:lower() == "e" then
        Flying = not Flying
        if Flying then
            local bv = Instance.new("BodyVelocity", Root)
            bv.Name = "FlyV"
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            task.spawn(function()
                while Flying do
                    bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                    task.wait()
                end
                bv:Destroy()
            end)
        end
    end
end)

-- 3. NOCLIP OTOMATIS (LANGSUNG AKTIF)
game:GetService("RunService").Stepped:Connect(function()
    for _, v in pairs(Character:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
end)

-- 4. REALISTIC VISUAL MAX (LANGSUNG AKTIF)
local Lighting = game.Lighting
local Bloom = Instance.new("BloomEffect", Lighting)
Bloom.Intensity = 1
local Color = Instance.new("ColorCorrectionEffect", Lighting)
Color.Saturation = 0.5
Lighting.Brightness = 2
Lighting.ClockTime = 14

-- 5. ESP PLAYER (LANGSUNG AKTIF)
for _, p in pairs(game.Players:GetPlayers()) do
    if p ~= Player and p.Character then
        local h = Instance.new("Highlight", p.Character)
        h.FillColor = Color3.fromRGB(255, 0, 0)
    end
end

-- 6. FREECAM (TEKAN 'V' UNTUK FREECAM)
local Freecamming = false
local CamPart
Mouse.KeyDown:Connect(function(key)
    if key:lower() == "v" then
        Freecamming = not Freecamming
        if Freecamming then
            CamPart = Instance.new("Part", workspace)
            CamPart.Anchored = true; CamPart.Transparency = 1; CamPart.CFrame = workspace.CurrentCamera.CFrame
            workspace.CurrentCamera.CameraSubject = CamPart
            task.spawn(function()
                while Freecamming do
                    CamPart.CFrame = CamPart.CFrame * CFrame.new(Humanoid.MoveDirection * 2.5)
                    workspace.CurrentCamera.CFrame = CamPart.CFrame
                    task.wait()
                end
            end)
        else
            workspace.CurrentCamera.CameraSubject = Humanoid
            if CamPart then CamPart:Destroy() end
        end
    end
end)

print("FH4N HUB: Speed 100 Active, Noclip Active, Press E to Fly, Press V for Freecam")
