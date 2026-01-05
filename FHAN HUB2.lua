local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FH4N HUB | GAG Edition",
   LoadingTitle = "FH4N HUB - Loading Assets...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "FH4NHub",
      FileName = "GAG_Config"
   },
   KeySystem = false
})

-- TAB UTAMA (MAIN)
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateToggle({
   Name = "Pet Always in Center",
   CurrentValue = false,
   Flag = "PetCenter",
   Callback = function(Value)
      _G.PetCenter = Value
      task.spawn(function()
          while _G.PetCenter do
              pcall(function()
                  local Char = game.Players.LocalPlayer.Character
                  local Root = Char:FindFirstChild("HumanoidRootPart")
                  local Pets = Char:FindFirstChild("Pets") or workspace:FindFirstChild(game.Players.LocalPlayer.Name .. "Pets")
                  if Root and Pets then
                      for _, p in pairs(Pets:GetChildren()) do
                          p:PivotTo(Root.CFrame)
                      end
                  end
              end)
              task.wait(0.1)
          end
      end)
   end,
})

-- TAB AUTO BUY (SHOP)
local ShopTab = Window:CreateTab("Auto Buy", 4483362458)

local function AutoBuyItem(Category)
    -- Fungsi ini mencari Remote untuk beli item (sesuaikan dengan game-nya)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Events = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:FindFirstChild("Remotes")
    
    if Events then
        for _, v in pairs(Events:GetDescendants()) do
            -- Pola umum: mencari remote dengan nama 'Buy' atau 'Purchase'
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                if v.Name:lower():find("buy") or v.Name:lower():find("purchase") then
                    v:FireServer(Category) -- Mengirim sinyal beli kategori tertentu
                end
            end
        end
    end
end

ShopTab:CreateSection("Shop Category")

ShopTab:CreateToggle({
   Name = "Auto Buy All Seeds",
   CurrentValue = false,
   Callback = function(Value)
      _G.BuySeeds = Value
      while _G.BuySeeds do
          AutoBuyItem("Seed")
          task.wait(0.5)
      end
   end,
})

ShopTab:CreateToggle({
   Name = "Auto Buy All Eggs",
   CurrentValue = false,
   Callback = function(Value)
      _G.BuyEggs = Value
      while _G.BuyEggs do
          AutoBuyItem("Egg")
          task.wait(0.5)
      end
   end,
})

ShopTab:CreateToggle({
   Name = "Auto Buy All Gear",
   CurrentValue = false,
   Callback = function(Value)
      _G.BuyGear = Value
      while _G.BuyGear do
          AutoBuyItem("Gear")
          task.wait(0.5)
      end
   end,
})

ShopTab:CreateToggle({
   Name = "Auto Buy Event Items",
   CurrentValue = false,
   Callback = function(Value)
      _G.BuyEvent = Value
      while _G.BuyEvent do
          AutoBuyItem("Event")
          task.wait(0.5)
      end
   end,
})

-- TAB VISUAL (ESP)
local VisualTab = Window:CreateTab("Visuals", 4483362458)

local function CreateESP(Part, Name, Color)
    if not Part:FindFirstChild("FH4N_Tag") then
        local Bbg = Instance.new("BillboardGui", Part)
        Bbg.Name = "FH4N_Tag"
        Bbg.AlwaysOnTop = true
        Bbg.Size = UDim2.new(0, 100, 0, 50)
        Bbg.StudsOffset = Vector3.new(0, 3, 0)
        local Lbl = Instance.new("TextLabel", Bbg)
        Lbl.BackgroundTransparency = 1
        Lbl.Size = UDim2.new(1,0,1,0)
        Lbl.Text = Name
        Lbl.TextColor3 = Color
        Lbl.TextSize = 12
        Lbl.Font = Enum.Font.GothamBold
    end
end

VisualTab:CreateButton({
   Name = "Enable ESP (Player, Egg, Crate)",
   Callback = function()
       -- Pemain
       for _, p in pairs(game.Players:GetPlayers()) do
           if p ~= game.Players.LocalPlayer and p.Character then
               CreateESP(p.Character:WaitForChild("Head"), p.Name, Color3.fromRGB(255,255,255))
           end
       end
       -- Objek Dunia
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("BasePart") or v:IsA("Model") then
               local name = v.Name:lower()
               local target = v:IsA("Model") and v.PrimaryPart or v
               if target then
                   if name:find("egg") then CreateESP(target, "🥚 Egg", Color3.fromRGB(255, 255, 0))
                   elseif name:find("crate") or name:find("chest") then CreateESP(target, "📦 Crate", Color3.fromRGB(0, 255, 0)) end
               end
           end
       end
   end,
})

-- SETTINGS
local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateLabel("Logo FN Aktif")
SettingsTab:CreateLabel("Minimize Key: Right Control (RCTRL)")

Rayfield:Notify({
   Title = "FH4N HUB Loaded",
   Content = "Script siap digunakan!",
   Duration = 5,
   Image = 4483362458,
})
