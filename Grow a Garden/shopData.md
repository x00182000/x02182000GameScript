```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
```

### Event Shop Data
```lua
local EventShopData = require(ReplicatedStorage.Data.EventShopData)
local seedInfo = {}

for categoryName, items in pairs(EventShopData) do
    for itemName, itemData in pairs(items) do
        table.insert(seedInfo, {
            SeedName = itemData.SeedName,
            LayoutOrder = itemData.LayoutOrder
        })
    end
end

table.sort(seedInfo, function(a, b)
    return a.LayoutOrder < b.LayoutOrder
end)

for _, info in ipairs(seedInfo) do
    print(info.SeedName)
end
```

### Gear Shop Data
```lua
local GearShopData = require(ReplicatedStorage.Data:WaitForChild("GearShopData"))

local gearInfo = {}

for gearName, itemData in pairs(GearShopData.Gear) do
    -- Get the actual gear name; some GearData modules use .Name or .SeedName
    local actualName = itemData.Gear.SeedName or itemData.Gear.Name or gearName
    table.insert(gearInfo, {
        GearName = actualName,
        LayoutOrder = itemData.LayoutOrder
    })
end

table.sort(gearInfo, function(a, b)
    return a.LayoutOrder < b.LayoutOrder
end)

for _, info in ipairs(gearInfo) do
    print(info.GearName)
end
```

### Seed Shop Data
```lua
local SeedShopData = require(ReplicatedStorage.Data.SeedShopData)

local seeds = {}

for seedName, itemData in pairs(SeedShopData) do
    if not itemData.SpecialCurrencyType then
        table.insert(seeds, {
            SeedName = seedName,
            LayoutOrder = itemData.LayoutOrder
        })
    end
end

table.sort(seeds, function(a, b)
    return a.LayoutOrder < b.LayoutOrder
end)

for _, seed in ipairs(seeds) do
    print(seed.SeedName)
end

```

### Egg Shop Data
```lua
local PetEggData = require(ReplicatedStorage.Data:WaitForChild("PetEggData"))

local eggInfo = {}

for eggName, itemData in pairs(PetEggData) do
    if type(itemData) == "table" and itemData.LayoutOrder then
        local actualName = itemData.EggName or eggName
        table.insert(eggInfo, {
            EggName = actualName,
            LayoutOrder = itemData.LayoutOrder
        })
    end
end

table.sort(eggInfo, function(a, b)
    return a.LayoutOrder < b.LayoutOrder
end)

for _, info in ipairs(eggInfo) do
    print(info.EggName)
end
```

### Daily Seed Shop
```lua
local DailySeedShopData = require(ReplicatedStorage.Data:WaitForChild("DailySeedShopData"))

local seedList = {}

for seedName, _ in pairs(DailySeedShopData) do
    table.insert(seedList, seedName)
end

for _, name in ipairs(seedList) do
    print(name)
end
```
### Cosmetic Crate Shop
```lua
local CosmeticCrateShopData = require(ReplicatedStorage.Data:WaitForChild("CosmeticCrateShopData"))

local crateList = {}

for crateName, _ in pairs(CosmeticCrateShopData) do
    table.insert(crateList, crateName)
end

for _, name in ipairs(crateList) do
    print(name)
end
```
### Cosmetic Item Shop
```lua
local CosmeticItemShopData = require(ReplicatedStorage.Data:WaitForChild("CosmeticItemShopData"))

local cosmeticNames = {}

for cosmeticName, itemData in pairs(CosmeticItemShopData) do
    table.insert(cosmeticNames, cosmeticName)
end

for _, name in ipairs(cosmeticNames) do
    print(name)
end
```

### Garden Coin Shop
```lua
local GardenCoinShopData = require(ReplicatedStorage.Data:WaitForChild("GardenCoinShopData"))

local gardenShopItems = {}

for itemName, itemData in pairs(GardenCoinShopData) do
    local dataCopy = {}
    for key, value in pairs(itemData) do
        if key ~= "LayoutOrder" then -- Remove LayoutOrder
            dataCopy[key] = value
        end
    end
    gardenShopItems[itemName] = dataCopy
end

for name, _ in pairs(gardenShopItems) do
    print(name)
end
```

### Season Pass Shop
```lua
local SeasonPassData = require(ReplicatedStorage.Data.SeasonPass.SeasonPassData)
local shopItems = SeasonPassData.ShopItems

local itemData = {}

for itemName, itemInfo in pairs(shopItems) do
    local layoutOrder = itemInfo.LayoutOrder or 0
    table.insert(itemData, {
        Name = itemName,
        LayoutOrder = layoutOrder
    })
end

table.sort(itemData, function(a, b)
    return a.LayoutOrder < b.LayoutOrder
end)

for _, item in ipairs(itemData) do
    print(item.Name, item.LayoutOrder)
end
```

### Traveling Merchant Shop (All)
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TravelingMerchantData = require(ReplicatedStorage.Data.TravelingMerchant.TravelingMerchantData)

local groupedItems = {}

for merchantName, merchantInfo in pairs(TravelingMerchantData) do
    local shopData = merchantInfo.ShopData
    groupedItems[merchantName] = {} -- Prepare table for this merchant
    
    for itemName, itemInfo in pairs(shopData) do
        if itemInfo.LayoutOrder then
            table.insert(groupedItems[merchantName], {
                ItemName = itemName,
                LayoutOrder = itemInfo.LayoutOrder,
                Data = itemInfo
            })
        end
    end
    
    table.sort(groupedItems[merchantName], function(a, b)
        return a.LayoutOrder < b.LayoutOrder
    end)
end

for merchant, items in pairs(groupedItems) do
    print("Merchant:", merchant)
    for _, item in ipairs(items) do
        print(item.ItemName)
    end
end

return groupedItems
```
