local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Telekinese Hub",
    HidePremium = true,
    SaveConfig = true,
    ConfigFolder = "TelekinesisConfig"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local InfoTab = Window:MakeTab({
    Name = "Info",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local AimAssistTab = Window:MakeTab({
    Name = "Aim Assist & ESP",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local PaidHubTab = Window:MakeTab({
    Name = "Paid Hub",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = true
})

-- Importing Gamepass Script
loadstring(game:HttpGet('https://raw.githubusercontent.com/TelekineseHub/TelekineseHubScripts/main/GamepassScript.lua'))()

-- Importing Telekinesis Script
loadstring(game:HttpGet('https://raw.githubusercontent.com/TelekineseHub/TelekineseHubScripts/main/TelekinesisScript.lua'))()

-- Importing AimAssistESP Script
loadstring(game:HttpGet('https://raw.githubusercontent.com/TelekineseHub/TelekineseHubScripts/main/AimAssistESP.lua'))()

OrionLib:Init()
