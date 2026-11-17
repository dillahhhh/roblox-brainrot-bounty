--[[
    EconomyService.luau
    Lokasi: ServerScriptService > EconomyService
    100% GRATIS: Sistem Uang (Coins, Gems, Rebirth, Level) + Auto Save DataStore
]]

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EconomyDataStore = nil
pcall(function()
    EconomyDataStore = DataStoreService:GetDataStore("BrainrotEconomy_v1")
end)

local EconomyService = {}

-- Setup RemoteEvents di ReplicatedStorage biar Client bisa minta data
local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
if not eventsFolder then
    eventsFolder = Instance.new("Folder")
    eventsFolder.Name = "Events"
    eventsFolder.Parent = ReplicatedStorage
end

local function setupPlayer(player)
    -- Folder Leaderstats (tampil di kanan atas layar)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local coins = Instance.new("IntValue")
    coins.Name = "Coins 🪙"
    coins.Value = 250 -- Modal awal gratis buat beli telur pertama!
    coins.Parent = leaderstats

    local gems = Instance.new("IntValue")
    gems.Name = "Gems 💎"
    gems.Value = 10
    gems.Parent = leaderstats

    local rebirth = Instance.new("IntValue")
    rebirth.Name = "Rebirth 🔄"
    rebirth.Value = 0
    rebirth.Parent = leaderstats

    local level = Instance.new("IntValue")
    level.Name = "Level ⭐"
    level.Value = 1
    level.Parent = leaderstats

    -- Load Data dari DataStore
    if EconomyDataStore then
        local success, savedData = pcall(function()
            return EconomyDataStore:GetAsync(tostring(player.UserId))
        end)

        if success and savedData then
            coins.Value = savedData.Coins or coins.Value
            gems.Value = savedData.Gems or gems.Value
            rebirth.Value = savedData.Rebirth or rebirth.Value
            level.Value = savedData.Level or level.Value
            print("Data loaded buat " .. player.Name)
        end
    end
end

local function savePlayer(player)
    if not EconomyDataStore then return end
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    local dataToSave = {
        Coins = leaderstats:FindFirstChild("Coins 🪙") and leaderstats["Coins 🪙"].Value or 0,
        Gems = leaderstats:FindFirstChild("Gems 💎") and leaderstats["Gems 💎"].Value or 0,
        Rebirth = leaderstats:FindFirstChild("Rebirth 🔄") and leaderstats["Rebirth 🔄"].Value or 0,
        Level = leaderstats:FindFirstChild("Level ⭐") and leaderstats["Level ⭐"].Value or 1,
    }

    local success, err = pcall(function()
        EconomyDataStore:SetAsync(tostring(player.UserId), dataToSave)
    end)

    if success then
        print("Data sukses tersimpan buat " .. player.Name)
    else
        warn("Gagal save data " .. player.Name .. ": " .. tostring(err))
    end
end

-- Rebirth System
function EconomyService.DoRebirth(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return false end

    local coins = leaderstats:FindFirstChild("Coins 🪙")
    local rebirth = leaderstats:FindFirstChild("Rebirth 🔄")

    local cost = (rebirth.Value + 1) * 50000

    if coins.Value >= cost then
        coins.Value = 0 -- Reset koin
        rebirth.Value += 1
        print(player.Name .. " Berhasil Rebirth ke-" .. rebirth.Value)
        return true
    else
        return false, "Koin kurang! Butuh " .. cost .. " Koin."
    end
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(savePlayer)

-- Auto save saat server shutdown
game:BindToClose(function()
    for _, player in ipairs(Players:GetPlayers()) do
        savePlayer(player)
    end
end)

return EconomyService
