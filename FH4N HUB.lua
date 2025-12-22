-- SCRIPT INI HANYA MENGUBAH VALUE YANG SUDAH ADA
-- TANPA MEMBUAT OBJEK BARU (ANTY-CRASH / ANTI-PATCH)

-- 1. SPEED & JUMP (Langsung Aktif)
local p = game:GetService("Players").LocalPlayer
local char = p.Character or p.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

hum.WalkSpeed = 100
hum.JumpPower = 100
hum.UseJumpPower = true

-- 2. MAX REALISTIC (Mengubah Lighting Bawaan)
local l = game:GetService("Lighting")
l.Brightness = 3
l.GlobalShadows = true
l.ClockTime = 14
l.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
l.ExposureCompensation = 0.5

-- 3. UNLOCK ZOOM
p.CameraMaxZoomDistance = 10000

-- 4. NOCLIP (Metode Paling Ringan)
game:GetService("RunService").Stepped:Connect(function()
    char.HumanoidRootPart.CanCollide = false
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

-- 5. FPS UNLOCKER (Jika didukung executor)
if setfpscap then
    setfpscap(999)
end

print("FH4N HUB: SEMUA AKTIF!")
