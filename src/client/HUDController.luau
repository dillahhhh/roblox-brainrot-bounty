--[[
    HUDController.luau
    Lokasi: StarterPlayer > StarterPlayerScripts > HUDController (atau StarterGui)
    Nampilin Koin, Gems, Level, Rebirth di layar secara real-time & animasi notifikasi gacha
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Bikin ScreenGui HUD
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame Stats di Kiri Atas
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(0, 220, 0, 140)
statsFrame.Position = UDim2.new(0, 20, 0, 20)
statsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
statsFrame.BorderSizePixel = 0
statsFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = statsFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(80, 80, 120)
uiStroke.Thickness = 2
uiStroke.Parent = statsFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
listLayout.Parent = statsFrame

local function createStatLabel(name, text, color)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = UDim2.new(0.9, 0, 0, 26)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 18
    label.TextColor3 = color
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.Parent = statsFrame
    return label
end

local coinsLabel = createStatLabel("CoinsLabel", "🪙 Koin: 0", Color3.fromRGB(255, 215, 0))
local gemsLabel = createStatLabel("GemsLabel", "💎 Gems: 0", Color3.fromRGB(0, 220, 255))
local levelLabel = createStatLabel("LevelLabel", "⭐ Level: 1", Color3.fromRGB(255, 170, 0))
local rebirthLabel = createStatLabel("RebirthLabel", "🔄 Rebirth: 0", Color3.fromRGB(200, 100, 255))

-- Update otomatis pas stats berubah
local function bindStats()
    local leaderstats = player:WaitForChild("leaderstats", 10)
    if not leaderstats then return end

    local coins = leaderstats:WaitForChild("Coins 🪙", 5)
    local gems = leaderstats:WaitForChild("Gems 💎", 5)
    local level = leaderstats:WaitForChild("Level ⭐", 5)
    local rebirth = leaderstats:WaitForChild("Rebirth 🔄", 5)

    if coins then
        coinsLabel.Text = "🪙 Koin: " .. coins.Value
        coins.Changed:Connect(function(val)
            coinsLabel.Text = "🪙 Koin: " .. val
        end)
    end

    if gems then
        gemsLabel.Text = "💎 Gems: " .. gems.Value
        gems.Changed:Connect(function(val)
            gemsLabel.Text = "💎 Gems: " .. val
        end)
    end

    if level then
        levelLabel.Text = "⭐ Level: " .. level.Value
        level.Changed:Connect(function(val)
            levelLabel.Text = "⭐ Level: " .. val
        end)
    end

    if rebirth then
        rebirthLabel.Text = "🔄 Rebirth: " .. rebirth.Value
        rebirth.Changed:Connect(function(val)
            rebirthLabel.Text = "🔄 Rebirth: " .. val
        end)
    end
end

task.spawn(bindStats)

-- Banner Notifikasi Hasil Gacha (Popup Tengah Layar)
local notifBanner = Instance.new("Frame")
notifBanner.Name = "NotifBanner"
notifBanner.Size = UDim2.new(0, 400, 0, 100)
notifBanner.Position = UDim2.new(0.5, -200, 0.2, 0)
notifBanner.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
notifBanner.BorderSizePixel = 0
notifBanner.Visible = false
notifBanner.Parent = screenGui

local bannerCorner = Instance.new("UICorner")
bannerCorner.CornerRadius = UDim.new(0, 16)
bannerCorner.Parent = notifBanner

local bannerStroke = Instance.new("UIStroke")
bannerStroke.Color = Color3.fromRGB(255, 215, 0)
bannerStroke.Thickness = 3
bannerStroke.Parent = notifBanner

local bannerTitle = Instance.new("TextLabel")
bannerTitle.Size = UDim2.new(1, 0, 0.4, 0)
bannerTitle.BackgroundTransparency = 1
bannerTitle.Font = Enum.Font.FredokaOne
bannerTitle.TextSize = 20
bannerTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
bannerTitle.Text = "🎉 TELUR MENETAS!"
bannerTitle.Parent = notifBanner

local bannerDesc = Instance.new("TextLabel")
bannerDesc.Position = UDim2.new(0, 0, 0.4, 0)
bannerDesc.Size = UDim2.new(1, 0, 0.5, 0)
bannerDesc.BackgroundTransparency = 1
bannerDesc.Font = Enum.Font.FredokaOne
bannerDesc.TextSize = 24
bannerDesc.TextColor3 = Color3.fromRGB(255, 255, 255)
bannerDesc.Text = "Mendapatkan: Pet"
bannerDesc.Parent = notifBanner

-- Global function buat nampilin popup
_G.ShowHatchNotification = function(petName, rarity, multiplier)
    bannerDesc.Text = petName .. " (" .. rarity .. ")\n+" .. multiplier .. " Koin/dtk!"
    notifBanner.Visible = true
    notifBanner.Position = UDim2.new(0.5, -200, 0.15, 0)
    TweenService:Create(notifBanner, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -200, 0.2, 0)
    }):Play()

    task.delay(3, function()
        notifBanner.Visible = false
    end)
end
