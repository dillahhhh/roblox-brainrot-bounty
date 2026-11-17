--[[
    MarketChest.luau
    Lokasi: ServerScriptService > MarketChest
    100% GRATIS: Peti Harta Karun Pasar Tengah (Tempat farming Koin gratis untuk beli Telur)
]]

local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local MarketChest = {}

local CHEST_RESPAWN_TIME = 45 -- Respawn tiap 45 detik
local CHEST_HEALTH = 15       -- Butuh 15x sentuhan / pukulan buat hancur

local function createChest(position)
    local chest = Instance.new("Part")
    chest.Name = "MarketChest"
    chest.Size = Vector3.new(4, 4, 4)
    chest.Position = position
    chest.Anchored = true
    chest.Material = Enum.Material.Neon
    chest.Color = Color3.fromRGB(255, 170, 0) -- Warna Emas
    chest.Parent = Workspace

    -- BillboardGui buat nampilin Darah Peti
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = chest

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.FredokaOne
    label.Text = "📦 PETI PASAR\nHP: " .. CHEST_HEALTH
    label.Parent = billboard

    local currentHP = CHEST_HEALTH
    local isDestroyed = false

    chest.Touched:Connect(function(hit)
        if isDestroyed then return end
        local character = hit.Parent
        local player = game.Players:GetPlayerFromCharacter(character)

        if player then
            currentHP -= 1
            label.Text = "📦 PETI PASAR\nHP: " .. math.max(0, currentHP)

            -- Efek visual kena pukul
            chest.Color = Color3.fromRGB(255, 255, 255)
            task.delay(0.1, function()
                if not isDestroyed then
                    chest.Color = Color3.fromRGB(255, 170, 0)
                end
            end)

            -- Kalau HP habis, beri hadiah Koin & Gems ke player yang menghancurkan
            if currentHP <= 0 then
                isDestroyed = true
                label.Text = "💥 TERBUKA!"

                local leaderstats = player:FindFirstChild("leaderstats")
                if leaderstats then
                    local coinsReward = math.random(300, 800)
                    local gemsReward = math.random(5, 15)

                    leaderstats["Coins 🪙"].Value += coinsReward
                    leaderstats["Gems 💎"].Value += gemsReward

                    print(string.format("[Peti Pasar] %s menghancurkan peti! Dapet +%d Koin & +%d Gems!", player.Name, coinsReward, gemsReward))
                end

                chest.Transparency = 1
                chest.CanCollide = false
                task.wait(1)
                chest:Destroy()

                -- Tunggu waktu respawn, lalu spawn peti baru lagi
                task.wait(CHEST_RESPAWN_TIME)
                createChest(position)
            end
        end
    end)
end

-- Posisi peti tepat di tengah Plaza Pasar Nusantara
local centerPosition = Vector3.new(0, 5, 0)
task.spawn(function()
    createChest(centerPosition)
end)

return MarketChest
