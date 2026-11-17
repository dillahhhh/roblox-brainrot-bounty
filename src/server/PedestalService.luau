--[[
    PedestalService.luau
    Lokasi: ServerScriptService > PedestalService
    100% GRATIS: Sistem Pajang Brainrot di Base & Generate Passive Income Koin/Detik
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local EggConfig = require(ReplicatedStorage:WaitForChild("EggConfig"))
local PlotManager = require(script.Parent:WaitForChild("PlotManager"))

local PedestalService = {}

-- Loop Passive Income tiap 1 detik
task.spawn(function()
    while true do
        task.wait(1)
        for _, player in ipairs(Players:GetPlayers()) do
            local plot = PlotManager.GetPlayerPlot(player)
            if plot then
                local pedestalsFolder = plot:FindFirstChild("Pedestals")
                if pedestalsFolder then
                    local totalMultiplier = 0

                    for _, stand in ipairs(pedestalsFolder:GetChildren()) do
                        local petValue = stand:FindFirstChild("EquippedPet")
                        if petValue and petValue.Value ~= "" then
                            local petData = EggConfig.Pets[petValue.Value]
                            if petData then
                                totalMultiplier += petData.Multiplier
                            end
                        end
                    end

                    if totalMultiplier > 0 then
                        local leaderstats = player:FindFirstChild("leaderstats")
                        if leaderstats and leaderstats:FindFirstChild("Coins 🪙") then
                            leaderstats["Coins 🪙"].Value += totalMultiplier
                        end
                    end
                end
            end
        end
    end
end)

-- Fungsi pasang pet ke pedestal base
function PedestalService.EquipPetToPedestal(player, pedestalNumber, petId)
    local plot = PlotManager.GetPlayerPlot(player)
    if not plot then return false, "Kamu belum punya base!" end

    local pedestals = plot:FindFirstChild("Pedestals")
    if not pedestals then return false, "Folder Pedestals tidak ditemukan di base!" end

    local targetStand = pedestals:FindFirstChild("Stand" .. pedestalNumber)
    if not targetStand then return false, "Pedestal tidak valid!" end

    local petValue = targetStand:FindFirstChild("EquippedPet")
    if not petValue then
        petValue = Instance.new("StringValue")
        petValue.Name = "EquippedPet"
        petValue.Parent = targetStand
    end

    petValue.Value = petId
    local petData = EggConfig.Pets[petId]

    -- Update Label Teks di Atas Stand
    local sign = targetStand:FindFirstChild("Sign")
    if sign and sign:FindFirstChild("SurfaceGui") then
        local label = sign.SurfaceGui:FindFirstChildOfClass("TextLabel")
        if label and petData then
            label.Text = petData.DisplayName .. "\n(+" .. petData.Multiplier .. " Koin/dtk)"
            label.TextColor3 = Color3.fromRGB(255, 215, 0)
        end
    end

    print(string.format("[Pedestal] %s memajang %s di Stand %d!", player.Name, petData.DisplayName, pedestalNumber))
    return true
end

return PedestalService
