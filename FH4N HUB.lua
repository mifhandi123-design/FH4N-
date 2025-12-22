local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("FH4N HUB FINAL", "DarkTheme")

-- CATEGORY PLAYER
local PlayerTab = Window:NewTab("Player")
local PlayerSection = PlayerTab:NewSection("Player Features")

PlayerSection:NewSlider("WalkSpeed", "Jalan Cepat", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

PlayerSection:NewButton("Fly (Normal)", "Terbang", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end) -- Menggunakan IY untuk Fly paling stabil

-- CATEGORY VISUAL
local VisualTab = Window:NewTab("Visual")
local VisualSection = VisualTab:NewSection("Realistic Max")

VisualSection:NewButton("Realistic RTX", "Grafik HD", function()
    local b = Instance.new("BloomEffect", game.Lighting); b.Intensity = 1
    local c = Instance.new("ColorCorrectionEffect", game.Lighting); c.Saturation = 0.5
    game.Lighting.Brightness = 2
end)

VisualSection:NewButton("Full Bright", "Anti Gelap", function()
    game.Lighting.Ambient = Color3.new(1,1,1)
end)
