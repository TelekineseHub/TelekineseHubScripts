-- Script de Aim Assist e ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local espFrames = {}
local tracersLines = {}
local fovCircle

-- Função para desenhar ESP
local function drawESP(player)
    if player == LocalPlayer then return end
    if teamCheck and player.Team == LocalPlayer.Team then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).magnitude
    if distance > maxDistance then return end
    
    local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)
    if onScreen then
        if not espFrames[player] then
            espFrames[player] = {}
            espFrames[player].box = Drawing.new("Square")
            espFrames[player].distanceText = Drawing.new("Text")
        end
        
        espFrames[player].box.Size = Vector2.new(50, 100)
        espFrames[player].box.Position = Vector2.new(screenPos.X - 25, screenPos.Y - 50)
        espFrames[player].box.Color = Color3.fromRGB(255, 255, 255)
        espFrames[player].box.Thickness = 1
        espFrames[player].box.Transparency = 1
        espFrames[player].box.Visible = espEnabled
        
        espFrames[player].distanceText.Text = tostring(math.floor(distance)) .. "m"
        espFrames[player].distanceText.Position = Vector2.new(screenPos.X, screenPos.Y - 50)
        espFrames[player].distanceText.Color = Color3.fromRGB(255, 255, 255)
        espFrames[player].distanceText.Size = 16
        espFrames[player].distanceText.Center = true
        espFrames[player].distanceText.Outline = true
        espFrames[player].distanceText.Visible = espEnabled
    else
        if espFrames[player] then
            espFrames[player].box.Visible = false
            espFrames[player].distanceText.Visible = false
        end
    end
end

-- Função para desenhar Tracers
local function drawTracers(player)
    if player == LocalPlayer then return end
    if teamCheck and player.Team == LocalPlayer.Team then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).magnitude
    if distance > maxDistance then return end
    
    local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)
    if onScreen then
        if not tracersLines[player] then
            tracersLines[player] = Drawing.new("Line")
        end
        
        tracersLines[player].From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
        tracersLines[player].To = Vector2.new(screenPos.X, screenPos.Y)
        tracersLines[player].Color = Color3.fromRGB(255, 255, 255)
        tracersLines[player].Thickness = 1
        tracersLines[player].Transparency = 1
        tracersLines[player].Visible = tracersEnabled
    else
        if tracersLines[player] then
            tracersLines[player].Visible = false
        end
    end
end

-- Função para atualizar ESP e Tracers
RunService.RenderStepped:Connect(function()
    if espEnabled or tracersEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if espEnabled then
                drawESP(player)
            end
            if tracersEnabled then
                drawTracers(player)
            end
        end
    end
end)

-- Função para limpar ESP e Tracers
Players.PlayerRemoving:Connect(function(player)
    if espFrames[player] then
        espFrames[player].box:Remove()
        espFrames[player].distanceText:Remove()
        espFrames[player] = nil
    end
    if tracersLines[player] then
        tracersLines[player]:Remove()
        tracersLines[player] = nil
    end
end)

-- Função para desenhar FOV Circle
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
        fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        fovCircle.Visible = true
    end
end

-- Atualizar círculo de FOV a cada renderização
RunService.RenderStepped:Connect(function()
    if fovCircleEnabled then
        fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        fovCircle.Visible = true
    elseif fovCircle then
        fovCircle.Visible = false
    end
end)

-- Função de Silent Aim
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = silentAimFOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if teamCheck and player.Team == LocalPlayer.Team then continue end
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then continue end
            local rootPart = character.HumanoidRootPart
            local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(rootPart.Position)
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
            
            if onScreen and distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end
    
    return closestPlayer
end

-- Função para ajustar a mira automaticamente para o alvo
local function silentAim()
    local target = getClosestPlayer()
    if target and math.random(1, 100) <= silentAimHSChance then
        local head = target.Character:FindFirstChild("Head")
        if head then
            local aimPos = head.Position
            local direction = (aimPos - workspace.CurrentCamera.CFrame.Position).Unit
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + direction)
        end
    end
end

-- Conectar Silent Aim ao evento RenderStepped
RunService.RenderStepped:Connect(function()
    if silentAimEnabled then
        silentAim()
    end
end)
