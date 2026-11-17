--[[
    EggConfig.luau
    Lokasi: ReplicatedStorage > EggConfig
    100% GRATIS: Konfigurasi Telur Brainrot, Drop Rate (%), dan Stat Pet
]]

local EggConfig = {}

-- Roster Pet Brainrot yang bisa ditetaskan dari Telur
EggConfig.Pets = {
    -- Tier Common
    ["Noob"] = { Rarity = "Common", Multiplier = 1, DisplayName = "Noob Ohio 😐" },
    ["BabyGronk"] = { Rarity = "Common", Multiplier = 2, DisplayName = "Baby Gronk 👶" },
    ["GrimaceCup"] = { Rarity = "Common", Multiplier = 3, DisplayName = "Gelas Grimace 🥤" },

    -- Tier Rare
    ["Capybara"] = { Rarity = "Rare", Multiplier = 5, DisplayName = "Capybara Santuy 🦫" },
    ["SmurfCat"] = { Rarity = "Rare", Multiplier = 8, DisplayName = "Smurf Cat Biru 🍄" },
    ["Rizzler"] = { Rarity = "Rare", Multiplier = 12, DisplayName = "The Rizzler 😎" },

    -- Tier Epic
    ["SkibidiBasic"] = { Rarity = "Epic", Multiplier = 25, DisplayName = "Skibidi Toilet 🚽" },
    ["FanumTaxer"] = { Rarity = "Epic", Multiplier = 40, DisplayName = "Fanum Taxer 🍔" },
    ["TitanSpeaker"] = { Rarity = "Epic", Multiplier = 65, DisplayName = "Titan Speaker 🔊" },

    -- Tier Legendary / Mythic
    ["TungTungHamster"] = { Rarity = "Legendary", Multiplier = 150, DisplayName = "Tung Tung Hamster 🐹" },
    ["SigmaMewing"] = { Rarity = "Legendary", Multiplier = 300, DisplayName = "Sigma Mewing 🤫🧏" },
    ["GoldenGigaChad"] = { Rarity = "Mythic", Multiplier = 1000, DisplayName = "GOLDEN GIGACHAD 🗿👑" },
}

-- Daftar Telur yang ada di Pasar Tengah
EggConfig.Eggs = {
    ["TelurOhio"] = {
        DisplayName = "Telur Ohio 🥚",
        Cost = 100,
        Currency = "Coins",
        Drops = {
            { Pet = "Noob", Chance = 60 },
            { Pet = "BabyGronk", Chance = 30 },
            { Pet = "GrimaceCup", Chance = 10 },
        }
    },
    ["TelurRizz"] = {
        DisplayName = "Telur Rizz 🟣",
        Cost = 1200,
        Currency = "Coins",
        Drops = {
            { Pet = "Capybara", Chance = 55 },
            { Pet = "SmurfCat", Chance = 35 },
            { Pet = "Rizzler", Chance = 10 },
        }
    },
    ["TelurSkibidi"] = {
        DisplayName = "Telur Skibidi 🔴",
        Cost = 10000,
        Currency = "Coins",
        Drops = {
            { Pet = "SkibidiBasic", Chance = 60 },
            { Pet = "FanumTaxer", Chance = 30 },
            { Pet = "TitanSpeaker", Chance = 10 },
        }
    },
    ["TelurSigma"] = {
        DisplayName = "Telur Divine Sigma 🗿",
        Cost = 75000,
        Currency = "Coins",
        Drops = {
            { Pet = "TungTungHamster", Chance = 75 },
            { Pet = "SigmaMewing", Chance = 24 },
            { Pet = "GoldenGigaChad", Chance = 1 }, -- 1% Mythic!
        }
    }
}

return EggConfig
