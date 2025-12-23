local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuyCosmeticItem = ReplicatedStorage.GameEvents.BuyCosmeticItem
local BuyCosmeticCrate = ReplicatedStorage.GameEvents.BuyCosmeticCrate
local BuyGearStock = ReplicatedStorage.GameEvents.BuyGearStock
local BuySeedStock = ReplicatedStorage.GameEvents.BuySeedStock
local BuyEventShopStock = ReplicatedStorage.GameEvents.BuyEventShopStock
local BuyPetEgg = ReplicatedStorage.GameEvents.BuyPetEgg
local BuySeasonPassStock = ReplicatedStorage.GameEvents.SeasonPass.BuySeasonPassStock
local BuyDailySeedShopStock = ReplicatedStorage.GameEvents.BuyDailySeeShopStock
local BuyTravelingMerchantShopStock = ReplicatedStorage.GameEvents.BuyTravelingMerchantShopStock

BuyCosmeticItem:FireServer("", "Cosmetics")
BuyCosmeticCrate:FireServer("", "Cosmetics")
BuyGearStock:FireServer("")
BuySeedStock:FireServer("Shop", "Carrot")
BuyEventShopStock:FireServer("", "Santa's Stash")
BuyPetEgg:FireServer("")
BuySeasonPassStock:FireServer("")
BuyDailySeedShopStock:FireServer("")
BuyTravelingMerchantShopStock:FireServer("")

---------------------------------
local PetBoostService = ReplicatedStorage.GameEvents.PetBoostService
local PetsService = ReplicatedStorage.GameEvents.PetsService
local ActivePetService = ReplicatedStorage.GameEvents.ActivePetService

PetBoostService:FireServer("Apply", "{}")

PetsService:FireServer("EquipPet", "{}", CFrame.new(-172, 0 ,-82, 1, 0, 0, 0, 1, 0, 0, 0, 1))
PetsService:FireServer("UnequipPet", "{}")
ActivePetService:FireServer("Feed", "{}")

---------------------------------
local SellPet_RE = ReplicatedStorage.GameEvents.SellPet_RE
local Sell_Item = ReplicatedStorage.GameEvents.Sell_Item

SellPet_RE:FireServer("Dog")
Sell_Item:FireServer()

---------------------------------
local ClaimSeasonPassReward = ReplicatedStorage.GameEvents.SeasonPass.ClaimSeasonPassReward

ClaimSeasonPassReward:FireServer(1, false)

---------------------------------
local ChristmasTree_SubmitAll = ReplicatedStorage.GameEvents.ChristmasEvent.ChristmasTree_SubmitAll

ChristmasTree_SubmitAll:FireServer()

---------------------------------
local Notification = ReplicatedStorage.GameEvents.Notification

firesignal(Notification.OnClientEvent, "Hoy, yung tabo!")