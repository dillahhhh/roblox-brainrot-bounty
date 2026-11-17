--[[
    EggShopClient.luau
    Lokasi: StarterPlayer > StarterPlayerScripts > EggShopClient (atau StarterGui)
    UI Belanja & Gacha Telur Brainrot di Pasar Tengah
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local EggConfig = require(ReplicatedStorage:WaitForChild("EggConfig"))
local eventsFolder = ReplicatedStorage:WaitForChild("Events")
local buyEggFunc = eventsFolder:WaitForChild("BuyEgg")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EggShopGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Tombol Buka Toko di Kiri Layar (Ikon Toko ala Pasar Nusantara)
local openButton = Instance.new("TextButton")
openButton.Name = "OpenShopButton"
openButton.Size = UDim2.new(0, 70, 0, 70)
openButton.Position = UDim2.new(0, 20, 0.4, 0)
openButton.BackgroundColor3 = Color3.fromRGB(240, 140, 30)
openButton.Text = "🛒\nTOKO"
openButton.Font = Enum.Font.FredokaOne
openButton.TextSize = 18
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 16)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(255, 215, 0)
openStroke.Thickness = 3
openStroke.Parent = openButton

-- Frame Modal Toko (Pop-up di Tengah)
local shopFrame = Instance.new("Frame")
shopFrame.Name = "ShopModal"
shopFrame.Size = UDim2.new(0, 650, 0, 380)
shopFrame.Position = UDim2.new(0.5, -325, 0.5, -190)
shopFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
shopFrame.Visible = false
shopFrame.BorderSizePixel = 0
shopFrame.Parent = screenGui

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0, 20)
modalCorner.Parent = shopFrame

local modalStroke = Instance.new("UIStroke")
modalStroke.Color = Color3.fromRGB(255, 170, 0)
modalStroke.Thickness = 3
modalStroke.Parent = shopFrame

-- Header Toko
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundTransparency = 1
header.Text = "🥚 LAPAK TELUR BRAINROT NUSANTARA 🥚"
header.Font = Enum.Font.FredokaOne
header.TextSize = 22
header.TextColor3 = Color3.fromRGB(255, 215, 0)
header.Parent = shopFrame

-- Tombol Close
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeButton.Text = "X"
closeButton.Font = Enum.Font.FredokaOne
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = shopFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

-- Grid Kartu Telur
local eggGrid = Instance.new("ScrollingFrame")
eggGrid.Size = UDim2.new(0.95, 0, 0, 300)
eggGrid.Position = UDim2.new(0.025, 0, 0, 60)
eggGrid.BackgroundTransparency = 1
eggGrid.ScrollBarThickness = 6
eggGrid.CanvasSize = UDim2.new(0, 600, 0, 0)
eggGrid.Parent = shopFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 140, 0, 260)
gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
gridLayout.Parent = eggGrid

-- Buat Kartu Telur untuk tiap jenis telur di EggConfig
local eggOrder = { "TelurOhio", "TelurRizz", "TelurSkibidi", "TelurSigma" }

for _, eggKey in ipairs(eggOrder) do
    local eggData = EggConfig.Eggs[eggKey]
    if eggData then
        local card = Instance.new("Frame")
        card.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        card.Parent = eggGrid

        local cardCorner = Instance.new("UICorner")
        cardCorner.CornerRadius = UDim.new(0, 12)
        cardCorner.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.BackgroundTransparency = 1
        title.Text = eggData.DisplayName
        title.Font = Enum.Font.FredokaOne
        title.TextSize = 14
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextWrapped = true
        title.Parent = card

        local eggIcon = Instance.new("TextLabel")
        eggIcon.Size = UDim2.new(1, 0, 0, 70)
        eggIcon.Position = UDim2.new(0, 0, 0, 40)
        eggIcon.BackgroundTransparency = 1
        eggIcon.Text = "🥚"
        eggIcon.TextSize = 48
        eggIcon.Parent = card

        local priceLabel = Instance.new("TextLabel")
        priceLabel.Size = UDim2.new(1, 0, 0, 30)
        priceLabel.Position = UDim2.new(0, 0, 0, 120)
        priceLabel.BackgroundTransparency = 1
        priceLabel.Text = "🪙 " .. eggData.Cost
        priceLabel.Font = Enum.Font.FredokaOne
        priceLabel.TextSize = 16
        priceLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        priceLabel.Parent = card

        local hatchBtn = Instance.new("TextButton")
        hatchBtn.Size = UDim2.new(0.85, 0, 0, 40)
        hatchBtn.Position = UDim2.new(0.075, 0, 0, 160)
        hatchBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        hatchBtn.Text = "TETASKAN!"
        hatchBtn.Font = Enum.Font.FredokaOne
        hatchBtn.TextSize = 14
        hatchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        hatchBtn.Parent = card

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = hatchBtn

        hatchBtn.MouseButton1Click:Connect(function()
            hatchBtn.Text = "MEMBUKA..."
            local success, result = buyEggFunc:InvokeServer(eggKey)
            if success and result then
                hatchBtn.Text = "BERHASIL!"
                if _G.ShowHatchNotification then
                    _G.ShowHatchNotification(result.Name, result.Rarity, result.Multiplier)
                end
            else
                hatchBtn.Text = "GAGAL!"
                warn(tostring(result))
            end
            task.delay(1, function()
                hatchBtn.Text = "TETASKAN!"
            end)
        end)
    end
end

-- Toggle Toko
openButton.MouseButton1Click:Connect(function()
    shopFrame.Visible = not shopFrame.Visible
end)

closeButton.MouseButton1Click:Connect(function()
    shopFrame.Visible = false
end)
