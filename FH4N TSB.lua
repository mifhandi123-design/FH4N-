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
