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

local Window = WindUI:CreateWindow({
    Title = "Incognito Hub",
    Icon = "hat-glasses",
    Folder = "MySuperHub",
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
        ButtonsType = "Default", -- Default or Mac
    },
    OpenButton = {
        Title = "Open Incognito Hub", -- can be changed
        CornerRadius = UDim.new(1,0), -- fully rounded
        StrokeThickness = 3, -- removing outline
        Enabled = true, -- enable or disable openbutton
        Draggable = true,
        OnlyMobile = true,
        
        Color = ColorSequence.new( -- gradient
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
    -- Original Set
    Purple    = Color3.fromHex("#7775F2"),
    Yellow    = Color3.fromHex("#ECA201"),
    Green     = Color3.fromHex("#10C550"),
    Grey      = Color3.fromHex("#83889E"),
    Blue      = Color3.fromHex("#257AF7"),
    Red       = Color3.fromHex("#EF4F1D"),

    -- Vibrant Accents
    Teal      = Color3.fromHex("#12B5B0"),
    Orange    = Color3.fromHex("#F7821B"),
    Pink      = Color3.fromHex("#E853A2"),
    Cyan      = Color3.fromHex("#00B7FF"),
    Indigo    = Color3.fromHex("#4B4DED"),

    -- Soft & Pastel
    Mint      = Color3.fromHex("#4ADE80"),
    Sky       = Color3.fromHex("#7DD3FC"),
    Rose      = Color3.fromHex("#FB7185"),
    Lavender  = Color3.fromHex("#C084FC"),
    Peach     = Color3.fromHex("#FDBA74"),

    -- Utility & Neutrals
    Gold      = Color3.fromHex("#FFD700"),
    Crimson   = Color3.fromHex("#991B1B"),
    Slate     = Color3.fromHex("#475569"),
    DarkGrey  = Color3.fromHex("#313339"),
    White     = Color3.fromHex("#F3F4F6"),
    Black     = Color3.fromHex("#1A1C1E")
}

local Tabs = {
    Farm = Window:Tab({ Title = "Farm", Icon = "tractor", IconColor = Colors.Green, IconShape = "Square"}),
	Shop = Window:Tab({ Title = "Shop", Icon = "shopping-bag", IconColor = Colors.Red, IconShape = "Square"}),
	Pet = Window:Tab({ Title = "Pet", Icon = "paw-print", IconColor = Colors.Yellow, IconShape = "Square"}),
	Egg = Window:Tab({ Title = "Egg Hatching", Icon = "egg", IconColor = Colors.Grey, IconShape = "Square"}),
	Tools = Window:Tab({ Title = "Tools", Icon = "wrench", IconColor = Colors.Blue, IconShape = "Square"}),
	Crafting = Window:Tab({ Title = "Crafting", Icon = "pickaxe", IconColor = Colors.Purple, IconShape = "Square"}),
    Misc = Window:Tab({ Title = "Misc", Icon = "layout-dashboard", IconColor = Colors.Indigo, IconShape = "Square"}),
    Webhook = Window:Tab({ Title = "Webhook", Icon = "webhook", IconColor = Colors.Teal, IconShape = "Square"})
}