-- Load WindUI Library
local HttpService = game:GetService("HttpService")
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/XenonLoader/WindUI/refs/heads/main/dist/main.lua"))()
WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Plant")

local LPH_JIT_MAX = function(...) return(...) end
local LPH_NO_VIRTUALIZE = function(...) return(...) end
local LPH_CRASH = function(...) while task.wait() do game:GetService("ScriptContext"):SetTimeout(math.huge);while true do while true do while true do while true do while true do while true do while true do while true do print("noob") end end end end end end end end end end;
local LRM_UserNote = "Owner"
local LRM_ScriptVersion = "v06"
local ClonedPrint = print

if LPH_OBFUSCATED then
    ClonedPrint = print
    print = function(...)end
    warn = function(...)end

    local PreventSkidsToMakeGayThings = loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/InfiniX/a40a158d22fd4f4733beb2f67379866ccb17906f/Library/Anti/AntiDebug/main.lua", true))()

    if not (type(PreventSkidsToMakeGayThings) == "table") then
        LPH_CRASH()
    end
end

repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Gradient functions
local function interpolate_color(color1, color2, t)
    local r = math.floor((1 - t) * color1[1] + t * color2[1])
    local g = math.floor((1 - t) * color1[2] + t * color2[2])
    local b = math.floor((1 - t) * color1[3] + t * color2[3])
    return string.format("#%02x%02x%02x", r, g, b)
end

local function hex_to_rgb(hex)
    if hex:sub(1, 1) == "#" then
        hex = hex:sub(2)
    end

    return {
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
    }
end

local function gradient(word)
    if not word or #word == 0 then
        return "Error"
    end

    local start_color, end_color

    if getgenv and getgenv().GradientColor == nil then
        start_color = hex_to_rgb("ea00ff")
        end_color = hex_to_rgb("5700ff")
    elseif getgenv and getgenv().GradientColor then
        start_color = hex_to_rgb(getgenv().GradientColor.startingColor or "ea00ff")
        end_color = hex_to_rgb(getgenv().GradientColor.endingColor or "5700ff")
    else
        start_color = hex_to_rgb("ea00ff")
        end_color = hex_to_rgb("5700ff")
    end

    local gradient_word = ""
    local word_len = #word
    local step = 1.0 / math.max(word_len - 1, 1)

    for i = 1, word_len do
        local t = step * (i - 1)
        local color = interpolate_color(start_color, end_color, t)
        gradient_word = gradient_word .. string.format('<font color="%s">%s</font>', color, word:sub(i, i))
    end

    return gradient_word
end

-- Format version function
function formatVersion(version)
    local formattedVersion = "  v" .. version:sub(2):gsub(".", "%0.")
    return formattedVersion:sub(1, #formattedVersion - 1)
end

-- Initialize main GUI
local Window = WindUI:CreateWindow({
    Title = 'Plants Vs Brainrots',
    Icon = "door-open",
    Author = gradient("Avantrix"),
    Folder = "PVB",
    Size = UDim2.fromOffset(580, 490),
    Theme = "Plant",
    HideSearchBar = false,
    SideBarWidth = 200,
    Acrylic = false,
})

Window:EditOpenButton({
    Title = "Open PVB",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"),
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

Window:DisableTopbarButtons({
    "Fullscreen",
})

Window:Tag({
    Title = formatVersion(LRM_ScriptVersion),
    Color = Color3.fromHex("#30ff6a")
})

-- Game Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local workspace = game:GetService("Workspace")

-- Variables
local LocalPlayer = Players.LocalPlayer

-- Remotes
local PlaceItem = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("PlaceItem")
local SpawnBrainrot = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SpawnBrainrot")
local RemoveItem = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RemoveItem")
local DeleteBrainrot = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DeleteBrainrot")
local BuyItem = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyItem")
local BuyGear = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyGear")

-- Setup PlaceItem success listener
local lastPlacedItem = nil
local placeItemConnection = PlaceItem.OnClientEvent:Connect(function()
    lastPlacedItem = tick()
end)

-- Setup DeleteBrainrot listener
local lastDeletedBrainrotID = nil
local deleteBrainrotConnection = DeleteBrainrot.OnClientEvent:Connect(function(brainrotID, data)
    lastDeletedBrainrotID = brainrotID

    -- Check if we're waiting for this specific brainrot to be deleted
    if waitingForDelete and brainrotID == currentBrainrotID then
        waitingForDelete = false
        currentBrainrotID = nil
    end
end)

-- Create Sections and Tabs
local Sections = {
    Main = Window:Section({ Title = "Features", Opened = true }),
}

local Tabs = {
    Welcome = Sections.Main:Tab({
        Title = "Information",
        Icon = "airplay",
        Desc = "Information about the script"
    }),
    Main = Sections.Main:Tab({
        Title = "Auto Plant",
        Icon = "flower",
        Desc = "Main auto plant features"
    }),
    Shop = Sections.Main:Tab({
        Title = "Shop",
        Icon = "shopping-cart",
        Desc = "Seeds and Gears shop"
    }),
}

-- WELCOME TAB
Tabs.Welcome:Section({
    Title = gradient("Welcome to PVB Hub!"),
    TextSize = 18,
})

Tabs.Welcome:Paragraph({
    Title = "Update Log",
    Desc = [[<font color="rgb(255,255,255)">NEWS:</font>
[+] NEW: Brainrot ID tracking from SpawnBrainrot event]],
})

Tabs.Welcome:Code({
    Title = "Discord",
    Code = [[https://discord.gg/cF8YeDPt2G]],
    OnCopy = function()
        setclipboard("https://discord.gg/cF8YeDPt2G")
        WindUI:Notify({
            Title = "Copied!",
            Content = "Discord link copied to clipboard",
            Duration = 2
        })
    end
})

-- Variables
local autoPlantEnabled = false
local selectedRarities = {}
local selectedPlants = {}
local rarityToBrainrotMap = {}

-- Brainrot spawn listener variables
local lastSpawnedBrainrotData = nil
local brainrotSpawnConnection = nil
local currentBrainrotID = nil
local waitingForDelete = false
local spawnQueue = {} -- Queue to track multiple spawns in order

-- NEW: Workspace monitoring variables
local workspaceMonitorActive = false
local workspaceMonitorConnection = nil

-- Manual Plant List (Static)
local availablePlants = {
    "Dragon Fruit",
    "Cactus",
    "Strawberry",
    "Sunflower",
    "Eggplant",
    "Watermelon",
    "Grape",
    "Cocotank",
    "Carnivorous",
    "Mr Carrot",
    "Tomatrio",
    "Shroombino"
}

-- Available Rarities
local availableRarities = {
    "Rare",
    "Epic",
    "Legendary",
    "Mythic",
    "Godly",
    "Secret",
    "Limited"
}

-- Shop Seeds List
local availableSeeds = {
    "Mr Carrot Seed",
    "Eggplant Seed",
    "Dragon Fruit Seed",
    "Cactus Seed",
    "Strawberry Seed",
    "Sunflower Seed",
    "Watermelon Seed",
    "Grape Seed",
    "Cocotank Seed",
    "Carnivorous Seed",
    "Tomatrio Seed",
    "Shroombino Seed",
    "Pumpkin Seed"
}

-- Shop Gears List
local availableGears = {
    "Water Bucket",
    "Banana Gun",
    "Frost Grenade",
    "Frost Blower",
    "Carrot Launcher"
}

-- Shop Variables
local selectedSeeds = {}
local selectedGears = {}
local seedPurchaseAmount = 0
local gearPurchaseAmount = 0
local autoBuySeedsEnabled = false
local autoBuyGearsEnabled = false

-- Shop Helper Functions
local function getSeedStock(seedName)
    local success, stock = pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return nil end

        local mainGui = playerGui:FindFirstChild("Main")
        if not mainGui then return nil end

        local seedsFrame = mainGui:FindFirstChild("Seeds")
        if not seedsFrame then return nil end

        local frame = seedsFrame:FindFirstChild("Frame")
        if not frame then return nil end

        local scrollFrame = frame:FindFirstChild("ScrollingFrame")
        if not scrollFrame then return nil end

        local seedItem = scrollFrame:FindFirstChild(seedName)
        if not seedItem then return nil end

        local stockLabel = seedItem:FindFirstChild("Stock")
        if not stockLabel then return nil end

        local stockText = stockLabel.Text or ""

        local stockNumber = string.match(stockText, "x(%d+)")
        if stockNumber then
            return tonumber(stockNumber)
        end

        stockNumber = tonumber(stockText)
        if stockNumber then
            return stockNumber
        end

        return 0
    end)

    if success and stock then
        return stock
    end
    return 0
end

local function getGearStock(gearName)
    local success, stock = pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return nil end

        local mainGui = playerGui:FindFirstChild("Main")
        if not mainGui then return nil end

        local gearsFrame = mainGui:FindFirstChild("Gears")
        if not gearsFrame then return nil end

        local frame = gearsFrame:FindFirstChild("Frame")
        if not frame then return nil end

        local scrollFrame = frame:FindFirstChild("ScrollingFrame")
        if not scrollFrame then return nil end

        local gearItem = scrollFrame:FindFirstChild(gearName)
        if not gearItem then return nil end

        local stockLabel = gearItem:FindFirstChild("Stock")
        if not stockLabel then return nil end

        local stockText = stockLabel.Text or ""

        local stockNumber = string.match(stockText, "x(%d+)")
        if stockNumber then
            return tonumber(stockNumber)
        end

        stockNumber = tonumber(stockText)
        if stockNumber then
            return stockNumber
        end

        return 0
    end)

    if success and stock then
        return stock
    end
    return 0
end

local function getRestockTime(shopType)
    local success, restockText = pcall(function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return nil end

        local mainGui = playerGui:FindFirstChild("Main")
        if not mainGui then return nil end

        local shopFrame = nil
        if shopType == "Seeds" then
            shopFrame = mainGui:FindFirstChild("Seeds")
        elseif shopType == "Gears" then
            shopFrame = mainGui:FindFirstChild("Gears")
        end

        if not shopFrame then return nil end

        local restockLabel = shopFrame:FindFirstChild("Restock")
        if not restockLabel then return nil end

        return restockLabel.Text
    end)

    if success and restockText then
        return restockText
    end
    return "Unknown"
end

local function buySeed(seedName, amount)
    if amount <= 0 then return 0 end

    local stock = getSeedStock(seedName)
    if not stock or stock <= 0 then
        return 0
    end

    local amountToBuy = math.min(amount, stock)

    for i = 1, amountToBuy do
        pcall(function()
            BuyItem:FireServer(seedName)
        end)
    end

    return amountToBuy
end

local function buyGear(gearName, amount)
    if amount <= 0 then return 0 end

    local stock = getGearStock(gearName)
    if not stock or stock <= 0 then
        return 0
    end

    local amountToBuy = math.min(amount, stock)
    for i = 1, amountToBuy do
        pcall(function()
            BuyGear:FireServer(gearName)
        end)
    end

    return amountToBuy
end

local function buySelectedSeeds()
    if #selectedSeeds == 0 then
        WindUI:Notify({
            Title = "Warning",
            Content = "No seeds selected!",
            Duration = 3
        })
        return false
    end

    local totalPurchased = 0
    local purchaseReport = {}
    local hasStock = false

    for _, seedName in pairs(selectedSeeds) do
        local stock = getSeedStock(seedName)

        if stock and stock > 0 then
            hasStock = true
            local amountToBuy = seedPurchaseAmount

            if amountToBuy == 0 then
                amountToBuy = stock
            else
                amountToBuy = math.min(amountToBuy, stock)
            end

            local purchased = buySeed(seedName, amountToBuy)

            if purchased > 0 then
                totalPurchased = totalPurchased + purchased
                table.insert(purchaseReport, seedName .. ": " .. purchased)
            end
        else
        end
    end

    if totalPurchased > 0 then
        local reportText = table.concat(purchaseReport, ", ")
        WindUI:Notify({
            Title = "Success",
            Content = "Purchased: " .. reportText,
            Duration = 5
        })
        return true
    else
        if not hasStock then
        end
        return false
    end
end

local function buySelectedGears()
    if #selectedGears == 0 then
        WindUI:Notify({
            Title = "Warning",
            Content = "No gears selected!",
            Duration = 3
        })
        return false
    end

    local totalPurchased = 0
    local purchaseReport = {}
    local hasStock = false

    for _, gearName in pairs(selectedGears) do
        local stock = getGearStock(gearName)

        if stock and stock > 0 then
            hasStock = true
            local amountToBuy = gearPurchaseAmount

            if amountToBuy == 0 then
                amountToBuy = stock
            else
                amountToBuy = math.min(amountToBuy, stock)
            end

            local purchased = buyGear(gearName, amountToBuy)

            if purchased > 0 then
                totalPurchased = totalPurchased + purchased
                table.insert(purchaseReport, gearName .. ": " .. purchased)
            end
        else
        end
    end

    if totalPurchased > 0 then
        local reportText = table.concat(purchaseReport, ", ")
        WindUI:Notify({
            Title = "Success",
            Content = "Purchased: " .. reportText,
            Duration = 5
        })
        return true
    else
        if not hasStock then
        end
        return false
    end
end

local function autoBuySeedsLoop()
    while autoBuySeedsEnabled do
        if #selectedSeeds == 0 then
            WindUI:Notify({
                Title = "Warning",
                Content = "No seeds selected! Please select seeds from dropdown.",
                Duration = 3
            })
            task.wait(5)
            continue
        end

        local hasAnyStock = false
        for _, seedName in pairs(selectedSeeds) do
            local stock = getSeedStock(seedName)
            if stock and stock > 0 then
                hasAnyStock = true
                break
            end
        end

        if hasAnyStock then
            buySelectedSeeds()
            task.wait(2)
        else
            local restockTime = getRestockTime("Seeds")
            task.wait(5)
        end
    end
end

local function autoBuyGearsLoop()
    while autoBuyGearsEnabled do
        if #selectedGears == 0 then
            WindUI:Notify({
                Title = "Warning",
                Content = "No gears selected! Please select gears from dropdown.",
                Duration = 3
            })
            task.wait(5)
            continue
        end

        local hasAnyStock = false
        for _, gearName in pairs(selectedGears) do
            local stock = getGearStock(gearName)
            if stock and stock > 0 then
                hasAnyStock = true
                break
            end
        end

        if hasAnyStock then
            buySelectedGears()
            task.wait(2)
        else
            local restockTime = getRestockTime("Gears")
            task.wait(5)
        end
    end
end

-- Helper Functions
local function getPlayerPlots()
    local plots = {}
    local success, result = pcall(function()
        local plotsFolder = workspace:FindFirstChild("Plots")
        if not plotsFolder then
            return {}
        end

        local foundPlots = {}
        for _, plot in pairs(plotsFolder:GetChildren()) do
            if plot:IsA("Model") or plot:IsA("Folder") then
                local owner = plot:GetAttribute("Owner") or
                             plot:GetAttribute("owner") or
                             plot:GetAttribute("PlotOwner") or
                             plot:GetAttribute("PlayerName")

                if owner == LocalPlayer.Name or
                   owner == LocalPlayer.DisplayName or
                   owner == LocalPlayer.UserId or
                   tostring(owner) == tostring(LocalPlayer.UserId) then
                    table.insert(foundPlots, plot)
                end
            end
        end
        return foundPlots
    end)

    if success then
        return result
    else
        return {}
    end
end

-- Detect Brainrot from workspace.ScriptedMap.Brainrots folder
local function detectBrainrotsByRarity()
    local rarityMap = {}
    local success, result = pcall(function()
        local scriptedMap = workspace:FindFirstChild("ScriptedMap")
        if not scriptedMap then
            return {}
        end

        local brainrotsFolder = scriptedMap:FindFirstChild("Brainrots")
        if not brainrotsFolder then
            return {}
        end

        local foundMap = {}
        local count = 0
        for _, brainrot in pairs(brainrotsFolder:GetChildren()) do
            if brainrot:IsA("Model") or brainrot:IsA("Folder") then
                local rarityAttr = brainrot:GetAttribute("Rarity")
                local plotAttr = brainrot:GetAttribute("Plot")
                if rarityAttr then
                    if not foundMap[rarityAttr] then
                        foundMap[rarityAttr] = {}
                    end

                    table.insert(foundMap[rarityAttr], {
                        Plot = plotAttr,
                        Model = brainrot,
                        ID = brainrot.Name,
                        Rarity = rarityAttr
                    })

                    count = count + 1
                else
                end
            end
        end

        return foundMap
    end)

    if success then
        rarityToBrainrotMap = result
        local totalCount = 0
        for rarity, list in pairs(result) do
            totalCount = totalCount + #list
        end
        return result
    else
        return {}
    end
end

-- Get brainrot data from selected rarity and player plot
local function getBrainrotFromRarity(rarity, playerPlotNumber)
    if rarityToBrainrotMap[rarity] and #rarityToBrainrotMap[rarity] > 0 then
        if playerPlotNumber then
            for _, brainrotData in pairs(rarityToBrainrotMap[rarity]) do
                if brainrotData.Plot == playerPlotNumber then
                    return brainrotData
                end
            end
        end
        return rarityToBrainrotMap[rarity][1]
    end
    return nil
end

-- Check if item is a seed
local function isSeed(item)
    if not item then return false end

    local itemNameAttribute = item:GetAttribute("ItemName")
    if itemNameAttribute and type(itemNameAttribute) == "string" then
        if string.find(string.lower(itemNameAttribute), "seed") then
            return true
        end
    end

    return false
end

-- Get SELECTED plant items from backpack (excluding seeds)
local function getSelectedPlantItemsFromBackpack(selectedPlants)
    local plantItems = {}
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return plantItems end
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            local plantAttribute = item:GetAttribute("Plant")
            local idAttribute = item:GetAttribute("ID")

            if plantAttribute and idAttribute and not isSeed(item) then
                for _, selectedPlant in pairs(selectedPlants) do
                    if plantAttribute == selectedPlant then
                        table.insert(plantItems, {
                            Tool = item,
                            Plant = plantAttribute,
                            ID = idAttribute
                        })
                        break
                    end
                end
            end
        end
    end

    return plantItems
end

-- Spawn Brainrot function (UPDATED: with ID parameter)
local function spawnBrainrot(rarity, plot, rowNumber, brainrotID)

    local success, err = pcall(function()
        firesignal(SpawnBrainrot.OnClientEvent, {
            Plot = plot,
            RowNo = rowNumber,
            ID = brainrotID -- Pass ID for tracking
        })
    end)

    if success then
        return true, "Spawned brainrot with ID: " .. brainrotID
    else
        return false, "Failed to spawn brainrot"
    end
end

-- Fixed equip tool function
local function equipTool(tool)
    if not tool then return false end

    local character = LocalPlayer.Character
    if not character then return false end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end

    if tool.Parent == LocalPlayer.Backpack then
        local success = pcall(function()
            humanoid:EquipTool(tool)
        end)

        if success then
            local startTime = tick()
            while tool.Parent ~= character and tick() - startTime < 2 do
                task.wait(0.1)
            end

            return tool.Parent == character
        else
            tool.Parent = character
            task.wait(0.2)
            return tool.Parent == character
        end
    elseif tool.Parent == character then
        return true
    end

    return false
end

-- Unequip tool function
local function unequipTool(tool)
    if not tool then return end

    local character = LocalPlayer.Character
    if not character then return end

    if tool.Parent == character then
        tool.Parent = LocalPlayer.Backpack
        task.wait(0.1)
    end
end

-- Function to remove existing plants and return their info
local function removeExistingPlants(selectedPlants, plot)
    local removedPlants = {}
    local plantsFolder = plot:FindFirstChild("Plants")

    if not plantsFolder then
        return removedPlants
    end

    for _, selectedPlant in pairs(selectedPlants) do
        for _, plantModel in pairs(plantsFolder:GetChildren()) do
            if plantModel:IsA("Model") and plantModel.Name == selectedPlant then
                local plantID = plantModel:GetAttribute("ID")

                if plantID then

                    local success = pcall(function()
                        RemoveItem:FireServer(plantID)
                    end)

                    if success then
                        table.insert(removedPlants, {
                            PlantName = selectedPlant,
                            ID = plantID
                        })
                    else
                    end
                end
            end
        end
    end

    return removedPlants
end

-- Get player plot number
local function getPlayerPlotNumber()
    local plots = getPlayerPlots()
    if #plots > 0 then
        local plotName = plots[1].Name
        local plotNumber = tonumber(plotName:match("%d+"))
        if plotNumber then
            return plotNumber
        end
    end
    return nil
end

-- NEW: Hook SpawnBrainrot event to detect brainrot spawns in real-time
local function setupBrainrotSpawnListener()
    if brainrotSpawnConnection then
        brainrotSpawnConnection:Disconnect()
        brainrotSpawnConnection = nil
    end
    brainrotSpawnConnection = SpawnBrainrot.OnClientEvent:Connect(function(data)

        local rarityFromModel = "Unknown"
        if data.Model then
            rarityFromModel = data.Model:GetAttribute("Rarity") or data.Model.Name or "Unknown"
        end

        local brainrotID = data.ID or "Unknown"

        local spawnData = {
            Plot = data.Plot,
            RowNo = data.RowNo,
            Rarity = rarityFromModel,
            ID = brainrotID,
            Timestamp = tick()
        }

        -- Add to spawn queue
        table.insert(spawnQueue, spawnData)

        -- Also set as last spawned for compatibility
        lastSpawnedBrainrotData = spawnData
    end)
end

-- NEW: Monitor workspace for brainrot ID existence
local function monitorWorkspaceBrainrot(brainrotID, onBrainrotRemoved)

    workspaceMonitorActive = true

    task.spawn(function()
        while workspaceMonitorActive and currentBrainrotID == brainrotID do
            local scriptedMap = workspace:FindFirstChild("ScriptedMap")
            if scriptedMap then
                local brainrotsFolder = scriptedMap:FindFirstChild("Brainrots")
                if brainrotsFolder then
                    local brainrotExists = brainrotsFolder:FindFirstChild(brainrotID)

                    if not brainrotExists then
                        workspaceMonitorActive = false
                        currentBrainrotID = nil

                        if onBrainrotRemoved then
                            onBrainrotRemoved()
                        end

                        break
                    end
                end
            end

            task.wait()
        end

    end)
end

-- Check if brainrot ID exists in workspace
local function brainrotExistsInWorkspace(brainrotID)
    local scriptedMap = workspace:FindFirstChild("ScriptedMap")
    if not scriptedMap then return false end

    local brainrotsFolder = scriptedMap:FindFirstChild("Brainrots")
    if not brainrotsFolder then return false end

    return brainrotsFolder:FindFirstChild(brainrotID) ~= nil
end

-- Clean spawn queue by removing non-existent brainrots
local function cleanSpawnQueue()
    local removedCount = 0
    local i = 1

    while i <= #spawnQueue do
        local data = spawnQueue[i]
        local existsInWorkspace = brainrotExistsInWorkspace(data.ID)

        if not existsInWorkspace then
            table.remove(spawnQueue, i)
            removedCount = removedCount + 1
        else
            i = i + 1
        end
    end

    if removedCount > 0 then
    end

    return removedCount
end

-- Wait for NEW brainrot using event listener with QUEUE PRIORITY (ANY selected rarity)
local function waitForNewBrainrotSpawn(playerPlotNumber, selectedRarities, maxWaitTime)
    local startTime = tick()
    maxWaitTime = maxWaitTime or 60
    while tick() - startTime < maxWaitTime do
        -- Clean queue first to remove expired brainrots
        cleanSpawnQueue()

        -- Check queue for matching spawn (prioritize FIRST spawn = oldest)
        for i, data in ipairs(spawnQueue) do

            -- Check if this rarity is in our selected list
            local rarityMatches = false
            for _, selectedRarity in pairs(selectedRarities) do
                if data.Rarity == selectedRarity then
                    rarityMatches = true
                    break
                end
            end

            if data.Plot == playerPlotNumber and rarityMatches then
                -- VALIDATE: Check if brainrot still exists in workspace
                local existsInWorkspace = brainrotExistsInWorkspace(data.ID)

                if not existsInWorkspace then
                    table.remove(spawnQueue, i)
                    -- Continue to next iteration (check next in queue)
                    break
                end
                table.remove(spawnQueue, i)
                return true, data.RowNo, data.ID, data.Rarity
            end
        end

        local elapsed = math.floor(tick() - startTime)
        if elapsed % 5 == 0 and elapsed > 0 then
        end

        task.wait()
    end

    return false, nil, nil, nil
end

-- Get grass positions from brainrot's row
local function getGrassPositionsFromRow(plot, rowNumber)
    local grassPositions = {}
    local rows = plot:FindFirstChild("Rows")
    if not rows then
        return grassPositions
    end

    local targetRow = rows:FindFirstChild(tostring(rowNumber))
    if not targetRow then
        return grassPositions
    end
    local grassContainer = targetRow:FindFirstChild("Grass")
    if not grassContainer then
        return grassPositions
    end

    for _, grassPart in pairs(grassContainer:GetChildren()) do
        if grassPart:IsA("BasePart") then
            local isEmpty = true
            local grassNumber = grassPart.Name
            local grassFolder = grassContainer:FindFirstChild(grassNumber)

            if grassFolder then
                for _, child in pairs(grassFolder:GetChildren()) do
                    if child:IsA("Model") and not child.Name:find("Brainrot") then
                        isEmpty = false
                        break
                    end
                end
            end

            if isEmpty then
                local grassCFrame = grassPart.CFrame

                table.insert(grassPositions, {
                    GrassPart = grassPart,
                    CFrame = grassCFrame,
                    GrassNumber = grassPart.Name
                })
            end
        end
    end

    if #grassPositions > 1 then
        for i = #grassPositions, 2, -1 do
            local j = math.random(1, i)
            grassPositions[i], grassPositions[j] = grassPositions[j], grassPositions[i]
        end
    end

    return grassPositions
end

-- UPDATED: Plant ALL items with workspace monitoring (ANY selected rarity)
local function plantAllItemsToNewBrainrot(plot, selectedRarities)
    local playerPlotNumber = getPlayerPlotNumber()
    if not playerPlotNumber then
        return false, "Could not determine player plot number"
    end

    local removedPlants = removeExistingPlants(selectedPlants, plot)
    if #removedPlants > 0 then
        task.wait()
    end

    lastSpawnedBrainrotData = nil

    local success, detectedRow, brainrotID, detectedRarity = waitForNewBrainrotSpawn(playerPlotNumber, selectedRarities, 60)
    if not success then
        return false, "Brainrot spawn event not detected (timeout 60s)"
    end

    currentBrainrotID = brainrotID
    local rowNumber = detectedRow
    local rarity = detectedRarity

    local selectedPlantItems = getSelectedPlantItemsFromBackpack(selectedPlants)
    if #selectedPlantItems == 0 then
        return false, "No selected plant items found in backpack"
    end

    local grassPositions = getGrassPositionsFromRow(plot, rowNumber)
    if #grassPositions == 0 then
        return false, "No grass positions found in Row " .. rowNumber
    end

    local planted = 0
    local failed = 0

    -- Use same CFrame for all items
    local sameCFrame = grassPositions[1] and grassPositions[1].CFrame or nil
    local sameFloor = grassPositions[1] and grassPositions[1].GrassPart or nil

    if not sameCFrame or not sameFloor then
        return false, "No valid grass position found"
    end
    for i, itemData in ipairs(selectedPlantItems) do
        local tool = itemData.Tool
        local plantName = itemData.Plant
        local plantID = itemData.ID
        local equipSuccess = equipTool(tool)
        if not equipSuccess then
            task.wait()
            equipSuccess = equipTool(tool)
            if not equipSuccess then
                failed = failed + 1
                continue
            end
        end

        task.wait()

        local placeData = {
            ID = plantID,
            CFrame = sameCFrame,
            Item = plantName,
            Floor = sameFloor
        }
        -- Reset lastPlacedItem before firing
        lastPlacedItem = nil
        local startTime = tick()

        local placeSuccess = pcall(function()
            PlaceItem:FireServer(placeData)
        end)

        if placeSuccess then
            -- Wait for PlaceItem.OnClientEvent confirmation
            local confirmed = false
            local timeout = 3
            while tick() - startTime < timeout do
                if lastPlacedItem and lastPlacedItem > startTime then
                    confirmed = true
                    break
                end
                task.wait()
            end

            if confirmed then
                planted = planted + 1
            else
                failed = failed + 1
            end
        else
            failed = failed + 1
        end

        unequipTool(tool)
        task.wait()
    end
    monitorWorkspaceBrainrot(brainrotID, function()
        task.wait()

        local removedForNext = removeExistingPlants(selectedPlants, plot)
        if #removedForNext > 0 then
            task.wait()
        end

    end)

    local message = "Planted " .. planted .. " items to Row " .. rowNumber
    if failed > 0 then
        message = message .. " (Failed: " .. failed .. ")"
    end
    message = message .. " | Rarity: " .. rarity .. " | Monitoring ID: " .. brainrotID

    return true, message
end

-- Auto plant loop (UPDATED: prioritize first spawn, ANY selected rarity)
local function autoPlantLoop()
    while autoPlantEnabled do
        local plots = getPlayerPlots()
        if #plots == 0 then
            WindUI:Notify({
                Title = "Warning",
                Content = "No plots found with your ownership!",
                Duration = 3
            })
            task.wait(5)
            continue
        end

        if #selectedPlants == 0 then
            WindUI:Notify({
                Title = "Info",
                Content = "No plants selected! Please select plants from dropdown.",
                Duration = 3
            })
            task.wait(5)
            continue
        end

        if #selectedRarities == 0 then
            WindUI:Notify({
                Title = "Info",
                Content = "No rarities selected! Please select rarities from dropdown.",
                Duration = 3
            })
            task.wait(5)
            continue
        end

        detectBrainrotsByRarity()

        local planted = false

        -- No longer loop through rarities - wait for ANY selected rarity to spawn first
        for _, plot in pairs(plots) do
            -- Wait for workspace monitor to finish before starting next cycle
            while workspaceMonitorActive do
                task.wait(1)
            end

            local success, message = plantAllItemsToNewBrainrot(plot, selectedRarities)

            if success then
                WindUI:Notify({
                    Title = "Success",
                    Content = message,
                    Duration = 3
                })
                planted = true
                while workspaceMonitorActive do
                    task.wait(0.5)
                end
                task.wait(2)
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = message,
                    Duration = 3
                })
            end
        end

        if not planted then
            task.wait(5)
        else
            task.wait(2)
        end
    end
end

-- AUTO PLANT TAB
Tabs.Main:Section({
    Title = "Auto Plant System",
    TextSize = 18,
})

-- Store UI element references for config


local DropdownPlants = Tabs.Main:Dropdown({
    Title = "Select Plants to Auto Plant",
    Values = availablePlants,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        selectedPlants = selected
        if #selectedPlants > 0 then
            local plantList = table.concat(selectedPlants, ", ")
            WindUI:Notify({
                Title = "Plants Selected",
                Content = plantList,
                Duration = 2
            })
        end
    end
})

local DropdownRarities = Tabs.Main:Dropdown({
    Title = "Select Rarities",
    Values = availableRarities,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        selectedRarities = selected
        if #selectedRarities > 0 then
            local rarityList = table.concat(selectedRarities, ", ")
            WindUI:Notify({
                Title = "Rarities Selected",
                Content = rarityList,
                Duration = 2
            })
        end
    end
})

local ToggleAutoPlant = Tabs.Main:Toggle({
    Title = "Auto Move Selected Plants",
    Desc = "Auto Move Plants",
    Value = false,
    Callback = function(value)
        autoPlantEnabled = value
        if value then
            if #selectedPlants > 0 and #selectedRarities > 0 then
                detectBrainrotsByRarity()
                local playerPlotNumber = getPlayerPlotNumber()
                if not playerPlotNumber then
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Could not determine your plot number!",
                        Duration = 3
                    })
                    autoPlantEnabled = false
                    return
                end
                local rarityList = table.concat(selectedRarities, ", ")
                WindUI:Notify({
                    Title = "Auto Plant Enabled",
                    Content = "Plot " .. playerPlotNumber .. " | Rarities: " .. rarityList,
                    Duration = 3
                })
                task.spawn(autoPlantLoop)
            elseif #selectedPlants == 0 then
                WindUI:Notify({
                    Title = "Warning",
                    Content = "Please select plants first!",
                    Duration = 3
                })
                autoPlantEnabled = false
            elseif #selectedRarities == 0 then
                WindUI:Notify({
                    Title = "Warning",
                    Content = "Please select rarities first!",
                    Duration = 3
                })
                autoPlantEnabled = false
            end
        else
            workspaceMonitorActive = false
            WindUI:Notify({
                Title = "Auto Plant Disabled",
                Content = "Stopped auto plant loop",
                Duration = 2
            })
        end
    end,
})

-- SHOP TAB - SEEDS SECTION
Tabs.Shop:Section({
    Title = "Seeds Shop",
    TextSize = 18,
})

Tabs.Shop:Button({
    Title = "Check Seeds Stock",
    Desc = "View current stock for all seeds",
    Icon = "package",
    Callback = function()
        local stockInfo = {}
        local totalStock = 0

        for _, seedName in pairs(availableSeeds) do
            local stock = getSeedStock(seedName)
            if stock then
                totalStock = totalStock + stock
            end
        end

        local restockTime = getRestockTime("Seeds")

        WindUI:Notify({
            Title = "Seeds Stock Status",
            Content = "Total Stock: " .. totalStock .. " | Restock: " .. restockTime,
            Duration = 3
        })
    end,
})

local DropdownSeeds = Tabs.Shop:Dropdown({
    Title = "Select Seeds to Buy",
    Values = availableSeeds,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        selectedSeeds = selected
        if #selectedSeeds > 0 then
            local seedList = table.concat(selectedSeeds, ", ")
            WindUI:Notify({
                Title = "Seeds Selected",
                Content = seedList,
                Duration = 2
            })
        end
    end
})

local SliderSeedAmount = Tabs.Shop:Slider({
    Title = "Purchase Amount",
    Desc = "0 = Buy all available stock",
    Value = { Min = 0, Max = 20, Default = 0 },
    Callback = function(value)
        seedPurchaseAmount = value
        if value == 0 then
            WindUI:Notify({
                Title = "Amount Set",
                Content = "Buy ALL available stock",
                Duration = 1
            })
        else
            WindUI:Notify({
                Title = "Amount Set",
                Content = tostring(value),
                Duration = 1
            })
        end
    end
})

Tabs.Shop:Button({
    Title = "Buy Selected Seeds",
    Desc = "Purchase the selected seeds one time",
    Icon = "shopping-bag",
    Callback = function()
        buySelectedSeeds()
    end,
})

local ToggleAutoBuySeeds = Tabs.Shop:Toggle({
    Title = "Auto Buy Seeds",
    Desc = "Auto-buy seeds when stock available. Pauses when no stock.",
    Value = false,
    Callback = function(value)
        autoBuySeedsEnabled = value
        if value then
            if #selectedSeeds > 0 then
                WindUI:Notify({
                    Title = "Auto Buy Seeds Enabled",
                    Content = "Waiting for stock...",
                    Duration = 2
                })
                task.spawn(autoBuySeedsLoop)
            else
                WindUI:Notify({
                    Title = "Warning",
                    Content = "Please select seeds first!",
                    Duration = 3
                })
                autoBuySeedsEnabled = false
            end
        else
            WindUI:Notify({
                Title = "Auto Buy Seeds Disabled",
                Content = "Stopped auto buy loop",
                Duration = 2
            })
        end
    end,
})

-- SHOP TAB - GEARS SECTION
Tabs.Shop:Section({
    Title = "Gears Shop",
    TextSize = 18,
})

Tabs.Shop:Button({
    Title = "Check Gears Stock",
    Desc = "View current stock for all gears",
    Icon = "package",
    Callback = function()
        local stockInfo = {}
        local totalStock = 0

        for _, gearName in pairs(availableGears) do
            local stock = getGearStock(gearName)
            if stock then
                totalStock = totalStock + stock
            end
        end

        local restockTime = getRestockTime("Gears")

        WindUI:Notify({
            Title = "Gears Stock Status",
            Content = "Total Stock: " .. totalStock .. " | Restock: " .. restockTime,
            Duration = 3
        })
    end,
})

local DropdownGears = Tabs.Shop:Dropdown({
    Title = "Select Gears to Buy",
    Values = availableGears,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        selectedGears = selected
        if #selectedGears > 0 then
            local gearList = table.concat(selectedGears, ", ")
            WindUI:Notify({
                Title = "Gears Selected",
                Content = gearList,
                Duration = 2
            })
        end
    end
})

local SliderGearAmount = Tabs.Shop:Slider({
    Title = "Purchase Amount",
    Desc = "0 = Buy all available stock",
    Value = { Min = 0, Max = 20, Default = 0 },
    Callback = function(value)
        gearPurchaseAmount = value
        if value == 0 then
            WindUI:Notify({
                Title = "Amount Set",
                Content = "Buy ALL available stock",
                Duration = 1
            })
        else
            WindUI:Notify({
                Title = "Amount Set",
                Content = tostring(value),
                Duration = 1
            })
        end
    end
})

Tabs.Shop:Button({
    Title = "Buy Selected Gears",
    Desc = "Purchase the selected gears one time",
    Icon = "shopping-bag",
    Callback = function()
        buySelectedGears()
    end,
})

local ToggleAutoBuyGears = Tabs.Shop:Toggle({
    Title = "Auto Buy Gears",
    Desc = "Auto-buy gears when stock available. Pauses when no stock.",
    Value = false,
    Callback = function(value)
        autoBuyGearsEnabled = value
        if value then
            if #selectedGears > 0 then
                WindUI:Notify({
                    Title = "Auto Buy Gears Enabled",
                    Content = "Waiting for stock...",
                    Duration = 2
                })
                task.spawn(autoBuyGearsLoop)
            else
                WindUI:Notify({
                    Title = "Warning",
                    Content = "Please select gears first!",
                    Duration = 3
                })
                autoBuyGearsEnabled = false
            end
        else
            WindUI:Notify({
                Title = "Auto Buy Gears Disabled",
                Content = "Stopped auto buy loop",
                Duration = 2
            })
        end
    end,
})

setupBrainrotSpawnListener()

-- CONFIGURATION SYSTEM
local ConfigManager = Window.ConfigManager
local configFile = nil
local configName = "default"
local selectedConfig = ""
local configList = {}

-- Create Configuration Tab
local ConfigTab = Sections.Main:Tab({
    Title = "Configuration",
    Icon = "settings",
    Desc = "Save and load settings"
})

-- Function to get list of configs from folder
local function getConfigList()
    if not ConfigManager then
        return {}
    end

    local configs = {}
    local success, result = pcall(function()
        if ConfigManager.AllConfigs then
            configs = ConfigManager:AllConfigs()
        elseif ConfigManager.Path and listfiles then
            if isfolder and isfolder(ConfigManager.Path) then
                local files = listfiles(ConfigManager.Path)
                for _, filePath in ipairs(files) do
                    if filePath:match("%.json$") then
                        local configName = filePath:match("([^/\\]+)%.json$")
                        if configName then
                            table.insert(configs, configName)
                        end
                    end
                end
            end
        end
    end)

    if not success then
        return {}
    end

    table.sort(configs)
    return configs
end

-- Custom Auto Load Functions
local autoLoadFilePath = nil

local function SetAutoLoadConfig(configName)
    if not autoLoadFilePath then
        autoLoadFilePath = ConfigManager.Path .. "_autoload.txt"
    end

    if writefile then
        writefile(autoLoadFilePath, configName or "")
        return true
    end
    return false
end

local function GetAutoLoadConfig()
    if not autoLoadFilePath then
        autoLoadFilePath = ConfigManager.Path .. "_autoload.txt"
    end

    if isfile and isfile(autoLoadFilePath) then
        local content = readfile(autoLoadFilePath)
        if content then
            content = content:gsub("^%s*(.-)%s*$", "%1")
        end
        return content
    end
    return nil
end

if ConfigManager then
    ConfigManager:Init(Window)
    autoLoadFilePath = ConfigManager.Path .. "_autoload.txt"
    configList = getConfigList()

    ConfigTab:Section({ Title = "Load Configuration", Icon = "folder-open" })

    local configDropdown
    local configFiles = {}

    configDropdown = ConfigTab:Dropdown({
        Title = "Select Config",
        Multi = false,
        AllowNone = true,
        Values = configFiles,
        Callback = function(selectedFile)
            selectedConfig = selectedFile
        end
    })

    ConfigTab:Button({
        Title = "Refresh Config List",
        Desc = "Refresh the dropdown list",
        Icon = "refresh-cw",
        Callback = function()
            local updatedConfigs = getConfigList()
            configDropdown:Refresh(updatedConfigs)
            WindUI:Notify({
                Title = "Refreshed",
                Content = "Config list updated (" .. #updatedConfigs .. " configs found)",
                Duration = 2,
            })
        end
    })

    ConfigTab:Section({ Title = "Save Configuration", Icon = "save" })

    local configName = ""
    ConfigTab:Input({
        Title = "Config Name",
        PlaceholderText = "Enter config name",
        Callback = function(text)
            configName = text
        end
    })

    ConfigTab:Button({
        Title = "Save New Config",
        Desc = "Save current settings as new config",
        Callback = function()
            if configName ~= "" and configName ~= " " then
                local success, err = pcall(function()
                    configFile = ConfigManager:CreateConfig(configName)

                    -- Register PVB elements
                    configFile:Register("ToggleAutoPlant", ToggleAutoPlant)
                    configFile:Register("DropdownPlants", DropdownPlants)
                    configFile:Register("DropdownRarities", DropdownRarities)
                    configFile:Register("DropdownSeeds", DropdownSeeds)
                    configFile:Register("SliderSeedAmount", SliderSeedAmount)
                    configFile:Register("ToggleAutoBuySeeds", ToggleAutoBuySeeds)
                    configFile:Register("DropdownGears", DropdownGears)
                    configFile:Register("SliderGearAmount", SliderGearAmount)
                    configFile:Register("ToggleAutoBuyGears", ToggleAutoBuyGears)

                    configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
                    configFile:Save()
                end)

                if success then
                    selectedConfig = configName

                    WindUI:Notify({
                        Title = "Config Saved",
                        Content = "Config '" .. configName .. "' saved successfully! Click 'Refresh Config List' to update dropdown.",
                        Duration = 3,
                    })
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Failed to save config: " .. tostring(err),
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Please enter a valid config name!",
                    Duration = 3,
                })
            end
        end
    })

    ConfigTab:Button({
        Title = "Load Config",
        Desc = "Load selected configuration",
        Callback = function()
            if selectedConfig ~= "" and selectedConfig ~= nil then
                local success, err = pcall(function()
                    configFile = ConfigManager:CreateConfig(selectedConfig)

                    -- Register PVB elements before loading
                    configFile:Register("ToggleAutoPlant", ToggleAutoPlant)
                    configFile:Register("DropdownPlants", DropdownPlants)
                    configFile:Register("DropdownRarities", DropdownRarities)
                    configFile:Register("DropdownSeeds", DropdownSeeds)
                    configFile:Register("SliderSeedAmount", SliderSeedAmount)
                    configFile:Register("ToggleAutoBuySeeds", ToggleAutoBuySeeds)
                    configFile:Register("DropdownGears", DropdownGears)
                    configFile:Register("SliderGearAmount", SliderGearAmount)
                    configFile:Register("ToggleAutoBuyGears", ToggleAutoBuyGears)

                    configFile:Load()
                end)

                if success then
                    task.wait(0.1)
                    configDropdown:Select(selectedConfig)

                    WindUI:Notify({
                        Title = "Config Loaded",
                        Content = "Config '" .. selectedConfig .. "' loaded successfully!",
                        Duration = 3,
                    })
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Failed to load config: " .. tostring(err),
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Please select a config from the dropdown!",
                    Duration = 3,
                })
            end
        end
    })

    ConfigTab:Button({
        Title = "Overwrite Config",
        Desc = "Save current settings to selected config",
        Callback = function()
            if selectedConfig ~= "" then
                configFile = ConfigManager:CreateConfig(selectedConfig)

                -- Register PVB elements
                    configFile:Register("ToggleAutoPlant", ToggleAutoPlant)
                    configFile:Register("DropdownPlants", DropdownPlants)
                    configFile:Register("DropdownRarities", DropdownRarities)
                    configFile:Register("DropdownSeeds", DropdownSeeds)
                    configFile:Register("SliderSeedAmount", SliderSeedAmount)
                    configFile:Register("ToggleAutoBuySeeds", ToggleAutoBuySeeds)
                    configFile:Register("DropdownGears", DropdownGears)
                    configFile:Register("SliderGearAmount", SliderGearAmount)
                    configFile:Register("ToggleAutoBuyGears", ToggleAutoBuyGears)

                configFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))

                if configFile:Save() then
                    WindUI:Notify({
                        Title = "Config Saved",
                        Content = "Config '" .. selectedConfig .. "' overwritten!",
                        Duration = 3,
                    })
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Failed to save config!",
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Please select a config to overwrite!",
                    Duration = 3,
                })
            end
        end
    })

    ConfigTab:Button({
        Title = "Delete Config",
        Desc = "Delete selected config file",
        Callback = function()
            if selectedConfig ~= "" and selectedConfig ~= nil then
                local filePath = ConfigManager.Path .. selectedConfig .. ".json"

                if isfile(filePath) then
                    delfile(filePath)

                    WindUI:Notify({
                        Title = "Config Deleted",
                        Content = "Config '" .. selectedConfig .. "' deleted! Click 'Refresh Config List' to update dropdown.",
                        Duration = 3,
                    })
                    selectedConfig = ""
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Config file not found!",
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "Please select a config to delete!",
                    Duration = 3,
                })
            end
        end
    })

    ConfigTab:Section({ Title = "Auto Load", Icon = "zap" })

    local function getAutoLoadStatusText()
        local currentAutoLoad = GetAutoLoadConfig()

        if currentAutoLoad and currentAutoLoad ~= "" and currentAutoLoad ~= "nil" then
            return currentAutoLoad
        else
            return "None"
        end
    end

    local AutoLoadStatusParagraph = ConfigTab:Paragraph({
        Title = "Auto Load Status",
        Desc = "Current: None",
    })

    local function updateAutoLoadStatus()
        local status = getAutoLoadStatusText()
        if status ~= "None" then
            AutoLoadStatusParagraph:SetDesc("Current: " .. status .. "")
        else
            AutoLoadStatusParagraph:SetDesc("Current: None")
        end
    end

    updateAutoLoadStatus()

    ConfigTab:Button({
        Title = "Set Auto Load",
        Icon = "zap",
        Callback = function()
            if selectedConfig and selectedConfig ~= "" then
                local success = SetAutoLoadConfig(selectedConfig)

                if success then
                    task.wait(0.3)
                    local verifyConfig = GetAutoLoadConfig()

                    updateAutoLoadStatus()

                    WindUI:Notify({
                        Title = "Auto Load Set",
                        Content = "Config "..selectedConfig.." will auto load on startup",
                        Duration = 3,
                    })
                else
                    WindUI:Notify({
                        Title = "Error",
                        Content = "Failed to write auto load file",
                        Duration = 3,
                    })
                end
            else
                WindUI:Notify({
                    Title = "Info",
                    Content = "Please select a config from dropdown first",
                    Duration = 3,
                })
            end
        end
    })
    -- AUTO LOAD CONFIG ON STARTUP
    task.spawn(function()
        -- Wait for all UI elements to be fully initialized
        task.wait(2)

        local autoLoadConfig = GetAutoLoadConfig()

        if autoLoadConfig and autoLoadConfig ~= "" and autoLoadConfig ~= "nil" then
            -- Get the list of configs without auto-refreshing dropdown
            local currentConfigs = getConfigList()

            -- Check if the auto load config exists in the list
            local configExists = false
            for _, configName in ipairs(currentConfigs) do
                if configName == autoLoadConfig then
                    configExists = true
                    break
                end
            end

            if not configExists then
                WindUI:Notify({
                    Title = "Auto Load Failed",
                    Content = "Config "..autoLoadConfig.." not found",
                    Duration = 3,
                })
                return
            end

            -- Set the selected config BEFORE loading
            selectedConfig = autoLoadConfig

            -- Refresh and select in dropdown
            if configDropdown then
                pcall(function()
                    configDropdown:Refresh(currentConfigs)
                    task.wait(0.2)
                    configDropdown:Select(autoLoadConfig)
                end)
            end

            -- Now create and load the config
            local loadSuccess, loadErr = pcall(function()
                configFile = ConfigManager:CreateConfig(autoLoadConfig)

                if not configFile then
                    error("Failed to create config object")
                end

                -- Register all elements before loading
                    configFile:Register("ToggleAutoPlant", ToggleAutoPlant)
                    configFile:Register("DropdownPlants", DropdownPlants)
                    configFile:Register("DropdownRarities", DropdownRarities)
                    configFile:Register("DropdownSeeds", DropdownSeeds)
                    configFile:Register("SliderSeedAmount", SliderSeedAmount)
                    configFile:Register("ToggleAutoBuySeeds", ToggleAutoBuySeeds)
                    configFile:Register("DropdownGears", DropdownGears)
                    configFile:Register("SliderGearAmount", SliderGearAmount)
                    configFile:Register("ToggleAutoBuyGears", ToggleAutoBuyGears)

                configFile:Load()
            end)

            task.wait(0.5)

            if loadSuccess then
                task.wait(0.3)

                updateAutoLoadStatus()

                WindUI:Notify({
                    Title = "Auto Loaded",
                    Content = "Config "..autoLoadConfig.." loaded!",
                    Duration = 3,
                })
            else
                WindUI:Notify({
                    Title = "Auto Load Failed",
                    Content = "Error: "..tostring(loadErr),
                    Duration = 3,
                })
            end
        end
    end)
else
    Tabs.Configuration:Paragraph({
        Title = "Config Manager Not Available",
        Desc = "This feature requires ConfigManager",
        Image = "alert-triangle",
        ImageSize = 20,
    })
end

Window:SelectTab(1)