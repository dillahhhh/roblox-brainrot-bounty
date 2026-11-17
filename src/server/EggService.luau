--[[
    EggService.luau
    Lokasi: ServerScriptService > EggService
    100% GRATIS: Logika Gacha Telur Brainrot, Roll RNG, Simpan ke Inventory Player
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local EggConfig = require(ReplicatedStorage:WaitForChild("EggConfig"))

local EggService = {}
local PlayerInventories = {} -- [Player] = { "Noob", "SkibidiBasic", ... }

-- Siapkan RemoteFunction buat Client minta Beli Telur
local eventsFolder = ReplicatedStorage:WaitForChild("Events")
local buyEggFunc = eventsFolder:FindFirstChild("BuyEgg")
if not buyEggFunc then
    buyEggFunc = Instance.new("RemoteFunction")
    buyEggFunc.Name = "BuyEgg"
    buyEggFunc.Parent = eventsFolder
end

-- Algoritma Roll Telur (Weighted Random)
local function rollEgg(eggName, rebirthLevel)
    local eggData = EggConfig.Eggs[eggName]
    if not eggData then return nil end

    -- Hitung total chance
    local totalWeight = 0
    for _, drop in ipairs(eggData.Drops) do
        totalWeight += drop.Chance
    end

    local randomNum = math.random() * totalWeight
    local currentWeight = 0

    for _, drop in ipairs(eggData.Drops) do
        currentWeight += drop.Chance
        if randomNum <= currentWeight then
            return drop.Pet
        end
    end

    return eggData.Drops[1].Pet
end

function EggService.HatchEgg(player, eggName)
    local eggData = EggConfig.Eggs[eggName]
    if not eggData then
        return false, "Telur tidak ditemukan!"
    end

    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        return false, "Data player belum siap!"
    end

    local coins = leaderstats:FindFirstChild("Coins 🪙")
    local rebirth = leaderstats:FindFirstChild("Rebirth 🔄")
    local rebirthVal = rebirth and rebirth.Value or 0

    -- Cek uang cukup atau tidak
    if coins.Value < eggData.Cost then
        return false, "Koin tidak cukup! Butuh " .. eggData.Cost .. " Koin."
    end

    -- Potong uang
    coins.Value -= eggData.Cost

    -- Roll Pet
    local hatchedPetId = rollEgg(eggName, rebirthVal)
    local petInfo = EggConfig.Pets[hatchedPetId]

    -- Masukkan ke Inventory
    if not PlayerInventories[player] then
        PlayerInventories[player] = {}
    end
    table.insert(PlayerInventories[player], hatchedPetId)

    print(string.format("[Gacha Telur] %s berhasil menetaskan %s (%s)!", player.Name, petInfo.DisplayName, petInfo.Rarity))

    return true, {
        PetId = hatchedPetId,
        Name = petInfo.DisplayName,
        Rarity = petInfo.Rarity,
        Multiplier = petInfo.Multiplier
    }
end

-- Handle panggilan dari Client GUI
buyEggFunc.OnServerInvoke = function(player, eggName)
    return EggService.HatchEgg(player, eggName)
end

Players.PlayerRemoving:Connect(function(player)
    PlayerInventories[player] = nil
end)

return EggService
