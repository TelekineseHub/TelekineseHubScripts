-- Main Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Load External Script from GitHub
local url = "https://raw.githubusercontent.com/TelekineseHub/TelekineseHubScripts/main/AimAssistESP.lua"
local success, scriptContent = pcall(function()
    return game:HttpGet(url)
end)

if not success then
    warn("Failed to load external script: ", scriptContent)
    return
end

local externalScript = loadstring(scriptContent)
if not externalScript then
    warn("Failed to compile external script")
    return
end

externalScript()

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local TabsFrame = Instance.new("Frame", MainFrame)
local ContentFrame = Instance.new("Frame", MainFrame)

-- Styling
ScreenGui.Name = "TelekineseHub"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0

TabsFrame.Size = UDim2.new(0, 100, 1, 0)
TabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabsFrame.BorderSizePixel = 0

ContentFrame.Position = UDim2.new(0, 100, 0, 0)
ContentFrame.Size = UDim2.new(1, -100, 1, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BorderSizePixel = 0

-- Tabs
local tabs = {"Aim Assist", "ESP", "Misc"}
local currentTab = "Aim Assist"
local tabButtons = {}

for i, tab in ipairs(tabs) do
    local button = Instance.new("TextButton", TabsFrame)
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = UDim2.new(0, 0, 0, (i-1) * 50)
    button.Text = tab
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.BorderSizePixel = 0
    button.MouseButton1Click:Connect(function()
        currentTab = tab
        updateContent()
    end)
    table.insert(tabButtons, button)
end

-- Update content based on tab
function updateContent()
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    if currentTab == "Aim Assist" then
        createAimAssistContent()
    elseif currentTab == "ESP" then
        createESPContent()
    elseif currentTab == "Misc" then
        createMiscContent()
    end
end

-- Aim Assist Content
function createAimAssistContent()
    local silentAimToggle = Instance.new("TextButton", ContentFrame)
    silentAimToggle.Size = UDim2.new(0, 200, 0, 50)
    silentAimToggle.Position = UDim2.new(0, 10, 0, 10)
    silentAimToggle.Text = "Toggle Silent Aim"
    silentAimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    silentAimToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    silentAimToggle.BorderSizePixel = 0
    silentAimToggle.MouseButton1Click:Connect(function()
        silentAimEnabled = not silentAimEnabled
        silentAimToggle.Text = silentAimEnabled and "Silent Aim: ON" or "Silent Aim: OFF"
    end)

    local fovSlider = Instance.new("TextButton", ContentFrame)
    fovSlider.Size = UDim2.new(0, 200, 0, 50)
    fovSlider.Position = UDim2.new(0, 10, 0, 70)
    fovSlider.Text = "FOV: " .. silentAimFOV
    fovSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    fovSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    fovSlider.BorderSizePixel = 0
    fovSlider.MouseButton1Click:Connect(function()
        silentAimFOV = (silentAimFOV + 10) % 360
        fovSlider.Text = "FOV: " .. silentAimFOV
        drawFOVCircle()
    end)
end

-- ESP Content
function createESPContent()
    local espToggle = Instance.new("TextButton", ContentFrame)
    espToggle.Size = UDim2.new(0, 200, 0, 50)
    espToggle.Position = UDim2.new(0, 10, 0, 10)
    espToggle.Text = "Toggle ESP"
    espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    espToggle.BorderSizePixel = 0
    espToggle.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        espToggle.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    end)

    local tracersToggle = Instance.new("TextButton", ContentFrame)
    tracersToggle.Size = UDim2.new(0, 200, 0, 50)
    tracersToggle.Position = UDim2.new(0, 10, 0, 70)
    tracersToggle.Text = "Toggle Tracers"
    tracersToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    tracersToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tracersToggle.BorderSizePixel = 0
    tracersToggle.MouseButton1Click:Connect(function()
        tracersEnabled = not tracersEnabled
        tracersToggle.Text = tracersEnabled and "Tracers: ON" or "Tracers: OFF"
    end)
end

-- Misc Content
function createMiscContent()
    local wallCheckToggle = Instance.new("TextButton", ContentFrame)
    wallCheckToggle.Size = UDim2.new(0, 200, 0, 50)
    wallCheckToggle.Position = UDim2.new(0, 10, 0, 10)
    wallCheckToggle.Text = "Toggle Wall Check"
    wallCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    wallCheckToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    wallCheckToggle.BorderSizePixel = 0
    wallCheckToggle.MouseButton1Click:Connect(function()
        wallCheckEnabled = not wallCheckEnabled
        wallCheckToggle.Text = wallCheckEnabled and "Wall Check: ON" or "Wall Check: OFF"
    end)

    local teamCheckToggle = Instance.new("TextButton", ContentFrame)
    teamCheckToggle.Size = UDim2.new(0, 200, 0, 50)
    teamCheckToggle.Position = UDim2.new(0, 10, 0, 70)
    teamCheckToggle.Text = "Toggle Team Check"
    teamCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    teamCheckToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    teamCheckToggle.BorderSizePixel = 0
    teamCheckToggle.MouseButton1Click:Connect(function()
        teamCheckEnabled = not teamCheckEnabled
        teamCheckToggle.Text = teamCheckEnabled and "Team Check: ON" or "Team Check: OFF"
    end)
end

-- Initialize Content
updateContent()

-- Variables
local espFrames = {}
local tracersLines = {}
local fovCircle
local silentAimEnabled = false
local silentAimFOV = 100
local silentAimHSChance = 50
local fovCircleEnabled = true
local wallCheckEnabled = false
local teamCheckEnabled = false
local espEnabled = false
local tracersEnabled = false
local maxDistance = 1000
local aimbotLegitEnabled = false
local aimbotAggressiveEnabled = false

-- Function to Draw FOV Circle
local function drawFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    if fovCircleEnabled then
        fovCircle = Drawing.new("Circle")
        fovCircle.Color = Color3.fromRGB(255, 255, 255)
        fovCircle.Thickness = 1
        fovCircle.Transparency = 1
        fovCircle.Radius = silentAimFOV
        fovCircle.Visible = true
    end
end

-- Get Closest Player
local function getClosestPlayer()
    local closestPlayer
    local shortestDistance = silentAimFOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if teamCheckEnabled and player.Team == LocalPlayer.Team then continue end
            local rootPart = player.Character.HumanoidRootPart
            local screenPoint = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    
    return closestPlayer
end

-- Silent Aim Function
local function silentAim()
    if not silentAimEnabled then return end
    
    local target = getClosestPlayer()
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then return end
    local head = target.Character.Head
    
    -- Perform aim adjustment
    local aimPosition = head.Position
    local screenPoint = workspace.CurrentCamera:WorldToViewportPoint(aimPosition)
    mousemoveabs(screenPoint.X, screenPoint.Y)
end

-- Legit Aimbot Function
local function legitAimbot()
    if not aimbotLegitEnabled then return end

    local target = getClosestPlayer()
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then return end
    local head = target.Character.Head
    
    -- Perform aim adjustment only when right mouse button is pressed
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local aimPosition = head.Position
        local screenPoint = workspace.CurrentCamera:WorldToViewportPoint(aimPosition)
        mousemoveabs(screenPoint.X, screenPoint.Y)
    end
end

-- Aggressive Aimbot Function
local function aggressiveAimbot()
    if not aimbotAggressiveEnabled then return end

    local target = getClosestPlayer()
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then return end
    local head = target.Character.Head
    
    -- Perform aim adjustment when left mouse button is clicked
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local aimPosition = head.Position
        local screenPoint = workspace.CurrentCamera:WorldToViewportPoint(aimPosition)
        mousemoveabs(screenPoint.X, screenPoint.Y)
    end
end

-- ESP and Tracers
RunService.RenderStepped:Connect(function()
    -- Remove previous ESP and Tracers
    for _, frame in pairs(espFrames) do
        frame:Destroy()
    end
    for _, line in pairs(tracersLines) do
        line:Remove()
    end
    espFrames = {}
    tracersLines = {}
    
    if espEnabled or tracersEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if teamCheckEnabled and player.Team == LocalPlayer.Team then continue end
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then continue end
                local rootPart = character.HumanoidRootPart
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                if distance > maxDistance then continue end
                
                local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                
                -- ESP
                if espEnabled and onScreen then
                    local espFrame = Instance.new("Frame", ContentFrame)
                    espFrame.Size = UDim2.new(0, 50, 0, 50)
                    espFrame.Position = UDim2.new(0, screenPoint.X - 25, 0, screenPoint.Y - 25)
                    espFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    espFrame.BorderSizePixel = 0
                    table.insert(espFrames, espFrame)
                end
                
                -- Tracers
                if tracersEnabled and onScreen then
                    local tracerLine = Drawing.new("Line")
                    tracerLine.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                    tracerLine.To = Vector2.new(screenPoint.X, screenPoint.Y)
                    tracerLine.Color = Color3.fromRGB(255, 255, 255)
                    tracerLine.Thickness = 1
                    tracerLine.Transparency = 1
                    tracerLine.Visible = true
                    table.insert(tracersLines, tracerLine)
                end
            end
        end
    end
    
    -- Update FOV Circle
    if fovCircleEnabled then
        fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
    end
    
    -- Perform Silent Aim
    silentAim()
    
    -- Perform Legit Aimbot
    legitAimbot()
    
    -- Perform Aggressive Aimbot
    aggressiveAimbot()
end)
