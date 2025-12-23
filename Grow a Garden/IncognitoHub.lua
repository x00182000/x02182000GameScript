local WindUI

do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    
    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end
end

local function safeLoad(url)
    local success, result = pcall(function()
        local src = game:HttpGet(url)
        local chunk = loadstring(src)
        return chunk()
    end)

    if not success then
        warn("Failed to load: " .. url .. " | Error: " .. tostring(result))
        return {}
    end

    return result
end

-- Load Modules
local ShopAutoBuy = safeLoad("https://raw.githubusercontent.com/x00182000/x02182000GameScript/main/Grow%20a%20Garden/functions/ShopAutoBuy.lua")

local MarketplaceService = game:GetService("MarketplaceService")
local gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name

-- Create the main UI window with WindUI
local Window = WindUI:CreateWindow({
    Title = "Incognito Hub | " .. gameName,
    Icon = "hat-glasses",
    Author = "by Sitsiritsit alibangbang",
    Folder = "IncognitoHub",
    NewElements = true,
    Size = UDim2.fromOffset(850, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = false,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    Topbar = {
        Height = 50,
        ButtonsType = "Default",
    },
    OpenButton = {
        Title = "Open Incognito Hub",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = true,
        
        Color = ColorSequence.new(
            Color3.fromHex("#30FF6A"), 
            Color3.fromHex("#e7ff2f")
        )
    },
})

Window:SetToggleKey(Enum.KeyCode.H)

Window:Tag({
    Title = "v1.1.0",
    Color = Color3.fromHex("#1c1c1c")
})

local Colors = {
    Purple    = Color3.fromHex("#7775F2"),
    Yellow    = Color3.fromHex("#ECA201"),
    Green     = Color3.fromHex("#10C550"),
    Grey      = Color3.fromHex("#83889E"),
    Blue      = Color3.fromHex("#257AF7"),
    Red       = Color3.fromHex("#EF4F1D"),
    Teal      = Color3.fromHex("#12B5B0"),
    Orange    = Color3.fromHex("#F7821B"),
    Pink      = Color3.fromHex("#E853A2"),
    Cyan      = Color3.fromHex("#00B7FF"),
    Indigo    = Color3.fromHex("#4B4DED"),
    Mint      = Color3.fromHex("#4ADE80"),
    Sky       = Color3.fromHex("#7DD3FC"),
    Rose      = Color3.fromHex("#FB7185"),
    Lavender  = Color3.fromHex("#C084FC"),
    Peach     = Color3.fromHex("#FDBA74"),
    Gold      = Color3.fromHex("#FFD700"),
    Crimson   = Color3.fromHex("#991B1B"),
    Slate     = Color3.fromHex("#475569"),
    DarkGrey  = Color3.fromHex("#313339"),
    White     = Color3.fromHex("#F3F4F6"),
    Black     = Color3.fromHex("#1A1C1E")
}

-- Create Tabs
local Tabs = {
    Farm = Window:Tab({ 
        Title = "Farm", 
        Icon = "tractor", 
        IconColor = Colors.Slate, 
        IconShape = "Square"
    }),
    Shop = Window:Tab({ 
        Title = "Shop", 
        Icon = "shopping-basket", 
        IconColor = Colors.Slate, 
        IconShape = "Square"
    }),
}

-- Initialize Shop Auto-Buy Module
if ShopAutoBuy and type(ShopAutoBuy.Initialize) == "function" then
    ShopAutoBuy:Initialize(WindUI, Tabs.Shop)
    print("✅ Shop Auto-Buy Module Initialized")
else
    warn("❌ Failed to load ShopAutoBuy module")
end

