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
    print
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
