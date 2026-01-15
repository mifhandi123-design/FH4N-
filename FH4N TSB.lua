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
		if roll <= RarityTable[i].Chance then
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
