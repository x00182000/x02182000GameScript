-- ShopAutoBuy.lua - Complete Shop Auto-Purchase Module with UI
local ShopAutoBuy = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Configuration
local PURCHASE_DELAY = 0.01
local CHECK_INTERVAL = 0.3
local VERIFY_DELAY = 0.05
local DEFAULT_ICON = "rbxassetid://0"

-- State
local autoPurchaseEnabled = false
local selectedItems = {
    Seed = {},
    DailySeed = {},
    Gear = {},
    Egg = {},
    SeasonPass = {},
    CosmeticCrate = {},
    CosmeticItem = {},
    EventShop = {},
    TravelingMerchant = {}
}
local lastCheckTime = 0
local heartbeatConnection = nil

-- UI References
local ShopParagraph = nil
local WindUI = nil

-- Data Modules (will be initialized)
local Data = ReplicatedStorage.Data
local SeedData = require(Data.SeedData)
local GearData = require(Data.GearData)
local PetRegistry = require(Data.PetRegistry)
local PetEggRegistry = PetRegistry.PetEggs
local PetList = PetRegistry.PetList
local CosmeticRegistry = require(Data.CosmeticRegistry)
local CosmeticList = CosmeticRegistry.CosmeticList
local CosmeticCrateRegistry = require(Data.CosmeticCrateRegistry)
local CosmeticCrates = CosmeticCrateRegistry.CosmeticCrates
local SeasonPassData = require(Data.SeasonPass.SeasonPassData)
local TravelingMerchantData = require(Data.TravelingMerchant.TravelingMerchantData)
local EventShopData = require(Data.EventShopData)

local ShopModules = {
    Seed      = require(Data.SeedShopData),
    DailySeed = require(Data.DailySeedShopData),
    Gear      = require(Data.GearShopData),
    Egg       = require(Data.PetEggData),
    SeasonPass = SeasonPassData.ShopItems,
    CosmeticCrate = require(Data.CosmeticCrateShopData),
    CosmeticItem  = require(Data.CosmeticItemShopData)
}

-- DataService
local DataService = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("DataService"))

-- Remote Events
local BuyCosmeticItem = ReplicatedStorage.GameEvents.BuyCosmeticItem
local BuyCosmeticCrate = ReplicatedStorage.GameEvents.BuyCosmeticCrate
local BuyGearStock = ReplicatedStorage.GameEvents.BuyGearStock
local BuySeedStock = ReplicatedStorage.GameEvents.BuySeedStock
local BuyEventShopStock = ReplicatedStorage.GameEvents.BuyEventShopStock
local BuyPetEgg = ReplicatedStorage.GameEvents.BuyPetEgg
local BuySeasonPassStock = ReplicatedStorage.GameEvents.SeasonPass.BuySeasonPassStock
local BuyDailySeedShopStock = ReplicatedStorage.GameEvents.BuyDailySeedShopStock
local BuyTravelingMerchantShopStock = ReplicatedStorage.GameEvents.BuyTravelingMerchantShopStock

-- Helper Functions
local function getPlayerData()
    local playerData = DataService:GetData()
    if not playerData then
        warn("❌ DataService:GetData() returned nil. Retrying...")
        wait(0.5)
        playerData = DataService:GetData()
    end
    return playerData
end

local function isItemSelected(category, itemName)
    if not selectedItems[category] then return false end
    
    for _, selected in ipairs(selectedItems[category]) do
        if selected == "All" then
            return true
        end
    end
    
    for _, selected in ipairs(selectedItems[category]) do
        if selected == itemName then
            return true
        end
    end
    
    return false
end

local function checkAndBuySelected()
    if not autoPurchaseEnabled then return 0, 0 end
    
    local playerData = getPlayerData()
    if not playerData then return 0, 0 end
    
    local purchasesMade = 0
    local failedPurchases = 0
    
    -- Buy Gear Stock
    if playerData.GearStock and playerData.GearStock.Stocks then
        for itemName, itemData in pairs(playerData.GearStock.Stocks) do
            if isItemSelected("Gear", itemName) and itemData.Stock and itemData.Stock > 0 then
                local stockCount = itemData.Stock
                for i = 1, stockCount do
                    BuyGearStock:FireServer(itemName)
                    purchasesMade = purchasesMade + 1
                end
            end
        end
    end
    
    -- Buy Seed Stock
    if playerData.SeedStocks and playerData.SeedStocks.Shop and playerData.SeedStocks.Shop.Stocks then
        for itemName, itemData in pairs(playerData.SeedStocks.Shop.Stocks) do
            if isItemSelected("Seed", itemName) and itemData.Stock and itemData.Stock > 0 then
                local stockCount = itemData.Stock
                for i = 1, stockCount do
                    BuySeedStock:FireServer("Shop", itemName)
                    purchasesMade = purchasesMade + 1
                end
            end
        end
    end
    
    -- Buy Daily Deals
    if playerData.SeedStocks and playerData.SeedStocks["Daily Deals"] and playerData.SeedStocks["Daily Deals"].Stocks then
        for itemName, itemData in pairs(playerData.SeedStocks["Daily Deals"].Stocks) do
            if isItemSelected("DailySeed", itemName) and itemData.Stock and itemData.Stock > 0 then
                local stockCount = itemData.Stock
                for i = 1, stockCount do
                    BuyDailySeedShopStock:FireServer(itemName)
                    purchasesMade = purchasesMade + 1
                end
            end
        end
    end
    
    -- Buy Pet Eggs
    if playerData.PetEggStock and playerData.PetEggStock.Stocks then
        for index, eggData in pairs(playerData.PetEggStock.Stocks) do
            if eggData.EggName and isItemSelected("Egg", eggData.EggName) and eggData.Stock and eggData.Stock > 0 then
                local stockCount = eggData.Stock
                for i = 1, stockCount do
                    BuyPetEgg:FireServer(eggData.EggName)
                    purchasesMade = purchasesMade + 1
                end
            end
        end
    end
    
    -- Buy Season Pass Items
    if playerData.SeasonPass and playerData.SeasonPass["Season 3"] and playerData.SeasonPass["Season 3"].Stocks then
        for itemName, itemData in pairs(playerData.SeasonPass["Season 3"].Stocks) do
            if isItemSelected("SeasonPass", itemName) and itemData.Stock and itemData.Stock > 0 then
                local stockCount = itemData.Stock
                for i = 1, stockCount do
                    BuySeasonPassStock:FireServer(itemName)
                    purchasesMade = purchasesMade + 1
                end
            end
        end
    end
    
    -- Buy Cosmetic Items
    if playerData.CosmeticStock and playerData.CosmeticStock.TabStocks and playerData.CosmeticStock.TabStocks.Cosmetics then
        local cosmetics = playerData.CosmeticStock.TabStocks.Cosmetics
        
        if cosmetics.ItemStocks then
            for itemName, itemData in pairs(cosmetics.ItemStocks) do
                if isItemSelected("CosmeticItem", itemName) and itemData.Stock and itemData.Stock > 0 then
                    local stockCount = itemData.Stock
                    for i = 1, stockCount do
                        BuyCosmeticItem:FireServer(itemName, "Cosmetics")
                        purchasesMade = purchasesMade + 1
                    end
                end
            end
        end
        
        if cosmetics.CrateStocks then
            for crateName, crateData in pairs(cosmetics.CrateStocks) do
                if isItemSelected("CosmeticCrate", crateName) and crateData.Stock and crateData.Stock > 0 then
                    local stockCount = crateData.Stock
                    for i = 1, stockCount do
                        BuyCosmeticCrate:FireServer(crateName, "Cosmetics")
                        purchasesMade = purchasesMade + 1
                    end
                end
            end
        end
    end
    
    -- Buy Event Shop Items
    if playerData.EventShopStock and playerData.EventShopStock["Santa's Stash"] and playerData.EventShopStock["Santa's Stash"].Stocks then
        for itemName, itemData in pairs(playerData.EventShopStock["Santa's Stash"].Stocks) do
            if isItemSelected("EventShop", itemName) and itemData.Stock and itemData.Stock > 0 then
                local stockCount = itemData.Stock
                for i = 1, stockCount do
                    BuyEventShopStock:FireServer(itemName, "Santa's Stash")
                    purchasesMade = purchasesMade + 1
                end
            end
        end
    end
    
    -- Buy Traveling Merchant Items
    -- Auto-buys from whichever merchant currently has the selected item in stock

if playerData.TravelingMerchantStock then
    for _, merchantData in pairs(playerData.TravelingMerchantStock) do
        if type(merchantData) == "table" and merchantData.Stocks then
            for itemName, itemData in pairs(merchantData.Stocks) do
                if isItemSelected("TravelingMerchant", itemName)
                and itemData.Stock
                and itemData.Stock > 0 then
                    for i = 1, itemData.Stock do
                        BuyTravelingMerchantShopStock:FireServer(itemName)
                        purchasesMade += 1
                    end
                end
            end
        end
    end
end

    
    return purchasesMade, failedPurchases
end

local function setEnabled(enabled)
    autoPurchaseEnabled = enabled
    
    if enabled and not heartbeatConnection then
        heartbeatConnection = RunService.Heartbeat:Connect(function()
            local currentTime = tick()
            
            if currentTime - lastCheckTime >= CHECK_INTERVAL then
                lastCheckTime = currentTime
                
                local ok, err = pcall(checkAndBuySelected)
                if not ok then
                    warn("❌ [AUTO-BUY ERROR]:", err)
                end
            end
        end)
    elseif not enabled and heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
end

-- UI Helper Functions
local function processShopData(shopType, rawData)
    local results = {}

    for key, item in pairs(rawData) do
        local entry = { Name = key, LayoutOrder = item.LayoutOrder or 0, Icon = DEFAULT_ICON, Asset = nil }

        if shopType == "Seed" or shopType == "DailySeed" then
            if item.SpecialCurrencyType then continue end
            local data = SeedData[key]
            entry.Icon = data and data.Asset or DEFAULT_ICON
            entry.Asset = entry.Icon

        elseif shopType == "Gear" then
            local gearInfo = item.Gear
            if not gearInfo then continue end
            local gearKey = gearInfo.Name or key
            local assetData = GearData[gearKey]
            entry.Name = gearInfo.SeedName or gearKey
            entry.Icon = assetData and assetData.Asset or DEFAULT_ICON
            entry.Asset = entry.Icon

        elseif shopType == "Egg" then
            if type(item) ~= "table" then continue end
            local eggName = item.EggName or key
            local reg = PetEggRegistry[eggName]
            entry.Name = eggName
            entry.Icon = reg and reg.Icon or DEFAULT_ICON
            entry.Asset = entry.Icon

        elseif shopType == "CosmeticCrate" then
            if type(item) ~= "table" then continue end
            local crateName = item.DisplayName or key
            local crateInfo = CosmeticCrates and CosmeticCrates[crateName]
            entry.Name = crateName
            entry.Icon = crateInfo and crateInfo.Icon or DEFAULT_ICON
            entry.Asset = entry.Icon

        elseif shopType == "SeasonPass" then
            if type(item) ~= "table" then continue end
            local itemName = key
            entry.Name = itemName
            entry.LayoutOrder = item.LayoutOrder or 0

            local resolvedIcon
            local seedInfo = SeedData[itemName]
            if seedInfo and seedInfo.Asset then
                resolvedIcon = seedInfo.Asset
            end

            if not resolvedIcon then
                local gearInfo = GearData[itemName]
                if gearInfo and gearInfo.Asset then
                    resolvedIcon = gearInfo.Asset
                end
            end

            if not resolvedIcon and PetList then
                local petInfo = PetList[itemName]
                if petInfo and petInfo.Icon then
                    resolvedIcon = petInfo.Icon
                end
            end

            if not resolvedIcon and CosmeticCrates then
                local crateInfo = CosmeticCrates[itemName]
                if crateInfo and crateInfo.Icon then
                    resolvedIcon = crateInfo.Icon
                end
            end

            if not resolvedIcon and CosmeticList then
                local cosmeticInfo = CosmeticList[itemName]
                if cosmeticInfo and cosmeticInfo.Icon then
                    resolvedIcon = cosmeticInfo.Icon
                end
            end

            entry.Icon = resolvedIcon or item.Icon or DEFAULT_ICON
            entry.Asset = entry.Icon

        elseif shopType == "CosmeticItem" then
            if type(item) ~= "table" then continue end
            local cosmeticName = key
            local cosmeticInfo = CosmeticList and CosmeticList[cosmeticName]
            entry.Name = cosmeticName
            entry.Icon = cosmeticInfo and cosmeticInfo.Icon or DEFAULT_ICON
            entry.Asset = entry.Icon
        end

        table.insert(results, entry)
    end

    table.sort(results, function(a, b) 
        return a.LayoutOrder == b.LayoutOrder and a.Name < b.Name or a.LayoutOrder < b.LayoutOrder 
    end)
    return results
end

local function getDropdownOptions(items)
    local options = {
        {
            Title = "All",
            Icon = "shopping-cart",
            Asset = "shopping-cart"
        }
    }
    for _, item in ipairs(items) do
        table.insert(options, {
            Title = item.Name,
            Icon = item.Icon,
            Asset = item.Asset
        })
    end
    return options
end

local function handleSelection(category, selected)
    selectedItems[category] = selectedItems[category] or {}

    if #selected == 0 then
        selectedItems[category] = {}
        return
    end

    for _, option in ipairs(selected) do
        if option.Title == "All" then
            selectedItems[category] = { "All" }
            return
        end
    end

    local newList = {}
    for _, option in ipairs(selected) do
        table.insert(newList, option.Title)
    end

    selectedItems[category] = newList
end


local function resolveIconFromAllSources(itemName)
    local seedInfo = SeedData[itemName]
    if seedInfo and seedInfo.Asset then
        return seedInfo.Asset
    end

    local gearInfo = GearData[itemName]
    if gearInfo and gearInfo.Asset then
        return gearInfo.Asset
    end

    if PetList then
        local petInfo = PetList[itemName]
        if petInfo and petInfo.Icon then
            return petInfo.Icon
        end
    end

    if PetEggRegistry then
        local eggInfo = PetEggRegistry[itemName]
        if eggInfo and eggInfo.Icon then
            return eggInfo.Icon
        end
    end

    if CosmeticCrates then
        local crateInfo = CosmeticCrates[itemName]
        if crateInfo and crateInfo.Icon then
            return crateInfo.Icon
        end
    end

    if CosmeticList then
        local cosmeticInfo = CosmeticList[itemName]
        if cosmeticInfo and cosmeticInfo.Icon then
            return cosmeticInfo.Icon
        end
    end

    return nil
end

local function setupShopDropdowns(SeedGearEggSection, CosmeticSection, SeasonPassSection)
    local configs = {
        { Title = "Seed Shop",           Key = "Seed",        Raw = ShopModules.Seed },
        { Title = "Daily Seed Shop",     Key = "DailySeed",   Raw = ShopModules.DailySeed },
        { Title = "Gear Shop",           Key = "Gear",        Raw = ShopModules.Gear.Gear },
        { Title = "Egg Shop",            Key = "Egg",         Raw = ShopModules.Egg },
        { Title = "Season Pass Shop",    Key = "SeasonPass",  Raw = ShopModules.SeasonPass },
        { Title = "Cosmetic Crate Shop", Key = "CosmeticCrate", Raw = ShopModules.CosmeticCrate },
        { Title = "Cosmetic Item Shop",  Key = "CosmeticItem",  Raw = ShopModules.CosmeticItem }
    }

    for _, config in ipairs(configs) do
        local processedItems = processShopData(config.Key, config.Raw)
        local options = getDropdownOptions(processedItems)

        local targetSection
        if config.Key == "CosmeticCrate" or config.Key == "CosmeticItem" then
            targetSection = CosmeticSection
        elseif config.Key == "SeasonPass" then
            targetSection = SeasonPassSection
        else
            targetSection = SeedGearEggSection
        end

        targetSection:Dropdown({
            Title = config.Title,
            Desc = "Select items for auto-purchase",
            Values = options,
            Multi = true,
            SearchBarEnabled = true,
            AllowNone = true,
            Callback = function(selected)
                handleSelection(config.Key, selected)
            end,
        })
    end
end

local function setupEventShop(EventShopSection)
    if type(EventShopData) ~= "table" then
        warn("EventShopData is not a table, got: " .. typeof(EventShopData))
        return
    end

    local items = {}

    for categoryName, categoryItems in pairs(EventShopData) do
        if type(categoryItems) ~= "table" then
            continue
        end

        for itemName, itemData in pairs(categoryItems) do
            if type(itemData) ~= "table" then
                continue
            end

            local seedName = itemData.SeedName
            local layoutOrder = itemData.LayoutOrder

            if not seedName or not layoutOrder then
                continue
            end

            local entry = {
                Name = seedName,
                LayoutOrder = layoutOrder,
                Icon = DEFAULT_ICON,
                Asset = nil,
            }

            local resolvedIcon = resolveIconFromAllSources(seedName)
            entry.Icon = resolvedIcon or DEFAULT_ICON
            entry.Asset = entry.Icon

            table.insert(items, entry)
        end
    end

    table.sort(items, function(a, b)
        return a.LayoutOrder < b.LayoutOrder
    end)

    local options = getDropdownOptions(items)

    EventShopSection:Dropdown({
        Title = "Event Shop",
        Desc = "Select items for auto-purchase",
        Values = options,
        Multi = true,
        SearchBarEnabled = true,
        AllowNone = true,
        Callback = function(selected)
            handleSelection("EventShop", selected)
        end,
    })
end

local function setupTravelingMerchants(TravelingMerchantSection)
    if type(TravelingMerchantData) ~= "table" then
        warn("TravelingMerchantData is not a table, got: " .. typeof(TravelingMerchantData))
        return
    end

    for merchantName, merchantInfo in pairs(TravelingMerchantData) do
        local shopData = merchantInfo.ShopData
        if type(shopData) ~= "table" then
            warn("ShopData for merchant '" .. tostring(merchantName) .. "' is not a table")
            continue
        end

        local items = {}

        for itemName, itemInfo in pairs(shopData) do
            if type(itemInfo) ~= "table" then
                continue
            end

            local layoutOrder = itemInfo.LayoutOrder
            if not layoutOrder then
                continue
            end

            local entry = {
                Name = itemName,
                LayoutOrder = layoutOrder,
                Icon = DEFAULT_ICON,
                Asset = nil,
            }

            local resolvedIcon = resolveIconFromAllSources(itemName)
            entry.Icon = resolvedIcon or itemInfo.Icon or DEFAULT_ICON
            entry.Asset = entry.Icon

            table.insert(items, entry)
        end

        table.sort(items, function(a, b)
            return a.LayoutOrder == b.LayoutOrder and a.Name < b.Name or a.LayoutOrder < b.LayoutOrder
        end)

        local options = getDropdownOptions(items)
        local title = (merchantInfo.Title or merchantName) .. " Traveling Merchant"

        TravelingMerchantSection:Dropdown({
            Title = title,
            Desc = "Select items for auto-purchase",
            Values = options,
            Multi = true,
            SearchBarEnabled = true,
            AllowNone = true,
            Callback = function(selected)
                handleSelection("TravelingMerchant", selected)
            end,
        })
    end
end

-- Public API
function ShopAutoBuy:Initialize(windUIInstance, shopTab)
    WindUI = windUIInstance
    
    ShopParagraph = shopTab:Paragraph({
        Title = "Shop",
        Desc = "🔴 Inactive",
        Image = "rbxassetid://126537660819583",
        ImageSize = 50,
        Thumbnail = "",
        ThumbnailSize = 80,
        Locked = false,
    })

    shopTab:Toggle({
        Title = "Auto-Purchase",
        Desc = "Buys selected shop items automatically",
        Icon = "shopping-bag",
        Type = "Toggle",
        Value = false,
        Callback = function(state)
            setEnabled(state)
            
            if state then
                ShopParagraph:SetDesc("🟢 Active")
                WindUI:Notify({
                    Title = "Shop",
                    Content = "Auto-purchase is now ON.",
                    Duration = 2,
                    Icon = "rbxassetid://126537660819583",
                })
            else
                ShopParagraph:SetDesc("🔴 Inactive")
                WindUI:Notify({
                    Title = "Shop",
                    Content = "Auto-purchase is now OFF.",
                    Duration = 2,
                    Icon = "rbxassetid://126537660819583",
                })
            end
        end
    })

    shopTab:Space()
    shopTab:Divider()
    shopTab:Space()

    local SeedGearEggSection = shopTab:Section({ Title = "Shop", Box = true })
    shopTab:Space()
    local CosmeticSection = shopTab:Section({ Title = "Cosmetics", Box = true })
    shopTab:Space()
    local EventShopSection = shopTab:Section({ Title = "Event Shop", Box = true })
    shopTab:Space()
    local SeasonPassSection = shopTab:Section({ Title = "Season Pass", Box = true })
    shopTab:Space()
    local TravelingMerchantSection = shopTab:Section({ Title = "Traveling Merchants", Box = true })

    -- Setup all dropdowns
    setupShopDropdowns(SeedGearEggSection, CosmeticSection, SeasonPassSection)
    setupEventShop(EventShopSection)
    setupTravelingMerchants(TravelingMerchantSection)
    
    -- Setup cleanup
    Players.PlayerRemoving:Connect(function(player)
        if player == Players.LocalPlayer then
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end
        end
    end)
end

return ShopAutoBuy
