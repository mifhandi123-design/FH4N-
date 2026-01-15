-- [[ SETTINGS RARITY & CHANCE ]]
local RarityTable = {
	{Name = "Common",   Chance = 50,      Color = Color3.fromRGB(170, 170, 170), SpeedMod = 1},
	{Name = "Uncommon", Chance = 25,      Color = Color3.fromRGB(0, 255, 0),     SpeedMod = 2},
	{Name = "Rare",     Chance = 12,      Color = Color3.fromRGB(0, 170, 255),   SpeedMod = 5},
	{Name = "Epic",     Chance = 7,       Color = Color3.fromRGB(170, 0, 255),   SpeedMod = 10},
	{Name = "Mitos",    Chance = 4,       Color = Color3.fromRGB(255, 0, 0),     SpeedMod = 25},
	{Name = "Kosmik",   Chance = 1.5,     Color = Color3.fromRGB(0, 255, 255),   SpeedMod = 50},
	{Name = "Secret",   Chance = 0.4,     Color = Color3.fromRGB(255, 255, 0),   SpeedMod = 150},
	{Name = "Ilahi",    Chance = 0.1,     Color = Color3.fromRGB(255, 255, 255), SpeedMod = 500}
}
-- [[ FH4N HUB TSB - ULTIMATE EDITION ]]
-- Nama: FH4N HUB TSB | Logo: FH
-- Keybind: "-" (Minus) untuk Buka/Tutup Menu

local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Bersihkan UI lama
if CoreGui:FindFirstChild("FH4NHub_Final") then CoreGui.FH4NHub_Final:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FH4NHub_Final"
ScreenGui.Parent = CoreGui

-- [[ GLOBAL SETTINGS ]]
_G.AutoCollect = false
_G.DupeMode = false
_G.AutoJump = false
_G.AutoRebirth = false
_G.Fly = false
_G.RainbowTrail = false
_G.SpeedPower = 16

-- [[ UI DESIGN ]]
local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.Position = UDim2.new(0.5, -165, 0.5, -200)
Main.Size = UDim2.new(0, 330, 0, 450)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Transparency = 0.4

-- [[ HEADER & LOGO ]]
local Logo = Instance.new("TextLabel", Main)
Logo.Text = "FH"
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 55
Logo.TextColor3 = Color3.fromRGB(0, 170, 255)
Logo.Size = UDim2.new(1, 0, 0, 70)

local Title = Instance.new("TextLabel", Main)
Title.Text = "FH4N HUB TSB OFFICIAL"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Position = UDim2.new(0, 0, 0, 65)
Title.Size = UDim2.new(1, 0, 0, 20)

-- [[ SCROLLING MENU ]]
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, 0, 1, -110)
Scroll.Position = UDim2.new(0, 0, 0, 100)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Scroll.ScrollBarThickness = 0

local UIList = Instance.new("UIListLayout", Scroll)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 10)

-- [[ FUNCTION: CREATE TOGGLE ]]
local function NewToggle(text, varName)
    local Btn = Instance.new("TextButton", Scroll)
    Btn.Size = UDim2.new(0, 280, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Btn.Text = text
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 14
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    
    Btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        local active = _G[varName]
        TweenService:Create(Btn, TweenInfo.new(0.3), {
            BackgroundColor3 = active and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(25, 25, 30),
            TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        }):Play()
    end)
end

-- [[ MENAMBAHKAN SEMUA FITUR ]]
NewToggle("Auto Collect Brainrot", "AutoCollect")
NewToggle("2x Dupe Brainrot", "DupeMode")
NewToggle("Auto Rebirth (On Max)", "AutoRebirth")
NewToggle("Auto Jump (Anti-Die)", "AutoJump")
NewToggle("Fly Mode (Terbang)", "Fly")
NewToggle("Rainbow Trail (Aesthetic)", "RainbowTrail")

-- [[ CORE ENGINE LOGIC ]]
task.spawn(function()
    while task.wait(0.3) do
        local char = Player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if _G.AutoCollect and hum then
            local gain = _G.DupeMode and 150 or 50
            _G.SpeedPower = _G.SpeedPower + gain
            hum.WalkSpeed = _G.SpeedPower
        end
        
        if _G.AutoRebirth and _G.SpeedPower > 15000 then
            _G.SpeedPower = 16
            hum.WalkSpeed = 16
            print("Rebirth Active!")
        end
        
        if _G.AutoJump and hum and hum.MoveDirection.Magnitude > 0 then
            hum.Jump = true
        end

        if _G.Fly and root then
            root.Velocity = Vector3.new(0, 50, 0)
        end
    end
end)

-- [[ RAINBOW TRAIL EFFECT ]]
local Trail = Instance.new("Trail")
Trail.Enabled = false
RunService.RenderStepped:Connect(function()
    if _G.RainbowTrail and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local root = Player.Character.HumanoidRootPart
        -- Logika warna pelangi
        Trail.Parent = root
        Trail.Enabled = true
        Trail.Color = ColorSequence.new(Color3.fromHSV(tick() % 5 / 5, 1, 1))
        local a0 = root:FindFirstChild("A0") or Instance.new("Attachment", root)
        a0.Name = "A0"
        a0.Position = Vector3.new(0, 1, 0)
        local a1 = root:FindFirstChild("A1") or Instance.new("Attachment", root)
        a1.Name = "A1"
        a1.Position = Vector3.new(0, -1, 0)
        Trail.Attachment0 = a0
        Trail.Attachment1 = a1
    else
        Trail.Enabled = false
    end
end)

-- [[ DRAGGABLE & TOGGLE ]]
local drag, start, startPos
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true start = i.Position startPos = Main.Position end end)
UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - start Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.Minus then Main.Visible = not Main.Visible end end)

print("FH4N HUB TSB: ULTIMATE LOADED! Keybind: '-'")
-- [[ FUNGSI ROLL ]]
local function rollSCP()
	local roll = math.random() * 100
	local cumulative = 0
	-- Roll dari yang paling langka (Ilahi) ke bawah
	for i = #RarityTable, 1, -1 do
		if roll <= RarityTable[i].Chance then-- [[ CONFIGURATION ]]
local DUPE_ENABLED = true
local DUPE_AMOUNT = 2 -- Ubah jadi 10 atau 100 kalau mau gila-gilaan
local AUTO_JUMP = true -- Biar otomatis loncat kalau ada rintangan

-- [[ DATABASE RARITY ]]
local Rarities = {
    {Name = "Common",   Chance = 50,  Speed = 2,    Color = Color3.fromRGB(170, 170, 170)},
    {Name = "Uncommon", Chance = 25,  Speed = 5,    Color = Color3.fromRGB(0, 255, 0)},
    {Name = "Rare",     Chance = 12,  Speed = 15,   Color = Color3.fromRGB(0, 170, 255)},
    {Name = "Epic",     Chance = 7,   Speed = 35,   Color = Color3.fromRGB(170, 0, 255)},
    {Name = "Mitos",    Chance = 4,   Speed = 80,   Color = Color3.fromRGB(255, 0, 0)},
    {Name = "Kosmik",   Chance = 1.5, Speed = 200,  Color = Color3.fromRGB(0, 255, 255)},
    {Name = "Secret",   Chance = 0.4, Speed = 500,  Color = "Rainbow"},
    {Name = "Ilahi",    Chance = 0.1, Speed = 2000, Color = "Rainbow"}
}

-- [[ SERVICES ]]
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Hum = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

-- [[ FUNCTIONS ]]
local function getRoll()
    local r = math.random() * 100
    for i = #Rarities, 1, -1 do
        if r <= Rarities[i].Chance then return Rarities[i] end
    end
    return Rarities[1]
end

local function notify(title, text, color)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2,
        Button1 = "OK"
    })
end

-- [[ MAIN LOOP ]]
print("--- BRAINROT EXECUTOR LOADED ---")
notify("SYSTEM ACTIVE", "Auto Collect & Dupe Started!", Color3.fromRGB(255, 255, 255))

task.spawn(function()
    while task.wait(0.3) do -- Kecepatan kencang
        local res = getRoll()
        local multiplier = DUPE_ENABLED and DUPE_AMOUNT or 1
        
        -- Update Speed
        local speedGain = res.Speed * multiplier
        Hum.WalkSpeed = Hum.WalkSpeed + speedGain
        
        -- Efek Spesial untuk Secret/Ilahi
        if res.Color == "Rainbow" then
            print("!!! ILAHI DROPPED !!!")
            notify("JACKPOT!", "Kamu dapat Rarity " .. res.Name .. "!", Color3.fromRGB(255, 255, 0))
        end
        
        -- Auto Jump Feature (Biar gak nyangkut pas lari dari tsunami)
        if AUTO_JUMP and Hum.MoveDirection.Magnitude > 0 then
            Hum.Jump = true
        end
    end
end)

-- [[ ANTI-LAG / OPTIMIZATION ]]
-- Menghapus part tsunami lama (visual saja) agar tidak lag saat lari kencang
task.spawn(function()
    while task.wait(5) do
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA("Part") and v.Name == "Tsunami" and (v.Position - Root.Position).Magnitude > 500 then
                -- v:Destroy() -- Opsional: Hapus kalau mau super ringan
            end
        end
    end
end)
			return RarityTable[i]
		end
	end
	return RarityTable[1]
end

-- [[ LOGIKA UTAMA ]]
game.Players.PlayerAdded:Connect(function(player)
	-- 1. Create Leaderstats
	local ls = Instance.new("Folder", player)
	ls.Name = "leaderstats"
	
	local brainrots = Instance.new("IntValue", ls)
	brainrots.Name = "Brainrots"
	
	local speedStat = Instance.new("NumberValue", ls)
	speedStat.Name = "Speed (m/s)"
	speedStat.Value = 16 -- Kecepatan awal Roblox
	
	-- 2. Value untuk Fitur Dupe (Bisa diubah script lain/gamepass)
	local dupeMultiplier = Instance.new("NumberValue", player)
	dupeMultiplier.Name = "DupeMultiplier"
	dupeMultiplier.Value = 1 -- Ubah ke 2 untuk Double Brainrot
	
	-- 3. Loop Auto Collect & Auto Speed
	task.spawn(function()
		while task.wait(1) do -- Setiap 1 detik otomatis dapet
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				local hum = player.Character.Humanoid
				local scp = rollSCP()
				
				-- Fitur Dupe Applied
				local finalGain = 1 * dupeMultiplier.Value
				brainrots.Value += finalGain
				
				-- Update Speed berdasarkan Rarity yang didapat
				hum.WalkSpeed += (scp.SpeedMod * dupeMultiplier.Value)
				speedStat.Value = hum.WalkSpeed
				
				-- Notif di Output (Bisa diganti UI)
				if scp.Chance < 5 then
					print("!!! " .. player.Name .. " dapet " .. scp.Name .. " !!!")
				end
			end
		end
	end)
end)
