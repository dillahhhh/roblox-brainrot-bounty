--[[
    PlotManager.luau
    Lokasi: ServerScriptService > PlotManager
    100% GRATIS: Sistem 8 Base Simetris (Auto Claim saat join, reset saat leave)
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local PlotManager = {}
PlotManager.OccupiedPlots = {} -- [PlotModel] = Player

local plotsFolder = Workspace:FindFirstChild("Plots")
if not plotsFolder then
    plotsFolder = Instance.new("Folder")
    plotsFolder.Name = "Plots"
    plotsFolder.Parent = Workspace
end

function PlotManager.GetPlayerPlot(player)
    for plot, owner in pairs(PlotManager.OccupiedPlots) do
        if owner == player then
            return plot
        end
    end
    return nil
end

local function onPlayerAdded(player)
    local assignedPlot = nil

    -- Loop dari Base1 sampai Base8
    for i = 1, 8 do
        local plot = plotsFolder:FindFirstChild("Base" .. i)
        if plot and not PlotManager.OccupiedPlots[plot] then
            assignedPlot = plot
            PlotManager.OccupiedPlots[plot] = player
            break
        end
    end

    if assignedPlot then
        print(string.format("[Base System] %s mengklaim %s", player.Name, assignedPlot.Name))

        -- Update Sign Papan Nama Base
        local sign = assignedPlot:FindFirstChild("Sign")
        if sign and sign:FindFirstChild("SurfaceGui") then
            local label = sign.SurfaceGui:FindFirstChildOfClass("TextLabel")
            if label then
                label.Text = "Base Milik: " .. player.DisplayName
                label.TextColor3 = Color3.fromRGB(0, 255, 127)
            end
        end

        -- Spawn player di base miliknya
        player.CharacterAdded:Connect(function(character)
            local root = character:WaitForChild("HumanoidRootPart")
            local spawnPart = assignedPlot:FindFirstChild("SpawnPoint")
            if spawnPart then
                task.wait(0.1)
                root.CFrame = spawnPart.CFrame + Vector3.new(0, 3, 0)
            end
        end)
    else
        warn("[Base System] Server penuh, tidak ada base kosong untuk " .. player.Name)
    end
end

local function onPlayerRemoving(player)
    for plot, owner in pairs(PlotManager.OccupiedPlots) do
        if owner == player then
            PlotManager.OccupiedPlots[plot] = nil
            print(string.format("[Base System] %s meninggalkan %s (Kosong)", player.Name, plot.Name))

            -- Reset Sign
            local sign = plot:FindFirstChild("Sign")
            if sign and sign:FindFirstChild("SurfaceGui") then
                local label = sign.SurfaceGui:FindFirstChildOfClass("TextLabel")
                if label then
                    label.Text = plot.Name .. " (Kosong)"
                    label.TextColor3 = Color3.fromRGB(220, 220, 220)
                end
            end
            break
        end
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

return PlotManager
