--[[
    FH4N TSB - KABUR TSUNAMI HUB (NO KEY)
    Logo: FN | Fitur: ESP, Fly, Auto Farm, Item Dupe
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FH4N TSB | LOGO: FN", "DarkTheme")

-- ================= MAIN TAB =================
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Auto Farm & Dupe")

MainSection:NewButton("Item Dupe (Hold Item)", "Pegang item lalu klik ini", function()
    -- Logika: Mencoba memicu RemoteEvent untuk memunculkan item kembali
    local player = game.Players.LocalPlayer
    local character = player.Character
    local item = character:FindFirstChildOfClass("Tool")
    
    if item then
        -- Mencari Remote yang berhubungan dengan Item/Inventory (Eksperimental)
        for _, remote in pairs(game.ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") and (remote.Name:lower():find("item") or remote.Name:lower():find("drop")) then
                remote:FireServer(item) -- Mencoba meniru perintah server
            end
        end
        print("Dupe Attempt Sent for: " .. item.Name)
    else
        print("Pegang item terlebih dahulu!")
    end
end)

MainSection:NewToggle("Auto Win", "Teleport otomatis ke finish", function(state)
    _G.AutoWin = state
    while _G.AutoWin do
        task.wait(0.5)
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "Finish" or v.Name == "WinPart" then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                break
            end
        end
    end
end)

-- ================= PLAYER TAB =================
local Player = Window:NewTab("Player")
local PlayerSection = Player:NewSection("Movement")

-- Fitur Fly (Terbang)
PlayerSection:NewToggle("Fly", "Terbang di udara", function(state)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local mouse = player:GetMouse()
    local flying = state
    local speed = 50
    
    if flying then
        local bg = Instance.new("BodyGyro", character.HumanoidRootPart)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = character.HumanoidRootPart.CFrame
        local bv = Instance.new("BodyVelocity", character.HumanoidRootPart)
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while flying do
                task.wait()
                character.Humanoid.PlatformStand = true
                bv.velocity = (workspace.CurrentCamera.CFrame.LookVector * speed)
                bg.cframe = workspace.CurrentCamera.CFrame
                if not flying then break end
            end
            bg:Destroy()
            bv:Destroy()
            character.Humanoid.PlatformStand = false
        end)
    else
        flying = false
    end
end)

PlayerSection:NewSlider("WalkSpeed", "Kecepatan", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- ================= VISUAL TAB =================
local Visual = Window:NewTab("Visuals")
local VisualSection = Visual:NewSection("ESP")

VisualSection:NewToggle("Player ESP", "Lihat nama pemain", function(state)
    _G.ESP = state
    while _G.ESP do
        task.wait(1)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and not p.Character.Head:FindFirstChild("FN_ESP") then
                local bbg = Instance.new("BillboardGui", p.Character.Head)
                bbg.Name = "FN_ESP"
                bbg.Size = UDim2.new(0, 100, 0, 50)
                bbg.AlwaysOnTop = true
                local lbl = Instance.new("TextLabel", bbg)
                lbl.Text = p.Name
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
        end
    end
end)

-- ================= MISC TAB =================
local Misc = Window:NewTab("Misc")
local MiscSection = Misc:NewSection("Tools")

MiscSection:NewButton("Anti-AFK", "Cegah Disconnect", function()
    local vu = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)tat.Name = "Speed (m/s)"
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
