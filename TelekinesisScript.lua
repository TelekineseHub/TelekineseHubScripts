-- TelekinesisScript.lua

local MainTab = Window:FindTab("Main")

local scriptEnabled = false
local currentMode = "single"
local floatHeight = 2
local floatingParts = {}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()

local function notify(message, iconId)
    OrionLib:MakeNotification({
        Name = "Telekinese",
        Content = message,
        Image = "rbxassetid://" .. iconId,
        Time = 5
    })
end

local function updateScriptState(value)
    scriptEnabled = value
    if scriptEnabled then
        notify("Telekinese Ativada", 9096444789)
    else
        notify("Telekinese Desativada", 15569163121)
    end
end

local function changeMode(value)
    currentMode = value
end

local function floatPart(part)
    if part and not part.Anchored then
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyPosition.Position = part.Position + Vector3.new(0, floatHeight, 0)
        bodyPosition.Parent = part
        table.insert(floatingParts, part)
    end
end

local function setPartCollision(part, enableCollision)
    local originalCanCollide = part.CanCollide
    part.CanCollide = enableCollision
    return originalCanCollide
end

RunService.RenderStepped:Connect(function()
    if scriptEnabled then
        for _, part in ipairs(floatingParts) do
            if part and part:FindFirstChild("BodyPosition") then
                part.BodyPosition.Position = part.Position + Vector3.new(0, floatHeight, 0)
            end
            if currentMode == "spin" then
                part.CFrame = part.CFrame * CFrame.Angles(0, 0.1, 0)
            elseif currentMode == "catch" then
                local originalCanCollide = setPartCollision(part, false)
                part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                setPartCollision(part, originalCanCollide)
            end
        end
    end
end)

mouse.Button1Down:Connect(function()
    if scriptEnabled then
        local target = mouse.Target
        if target then
            floatPart(target)
        end
    end
end)

local function ghostTeleport(targetPart)
    if targetPart and targetPart.Anchored and targetPart:IsDescendantOf(game.Workspace) then
        if targetPart.CreatorType == Enum.CreatorType.User then
            LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPart.Position))
            workspace.CurrentCamera.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 5, 10), targetPart.Position)
        elseif targetPart.CreatorType == Enum.CreatorType.Group then
            local ownerId = game:GetService("GroupService"):GetGroupInfoAsync(targetPart.CreatorId).Owner.Id
            if LocalPlayer.UserId == ownerId then
                LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(targetPart.Position))
                workspace.CurrentCamera.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 5, 10), targetPart.Position)
            end
        end
    end
end

mouse.Button2Down:Connect(function()
    if scriptEnabled then
        local target = mouse.Target
        if target then
            ghostTeleport(target)
        end
    end
end)

MainTab:AddDropdown({
    Name = "Modo",
    Default = "single",
    Options = {"single", "spin", "catch"},
    Callback = function(Value)
        changeMode(Value)
    end
})

MainTab:AddButton({
    Name = "Descartar Partes Flutuantes",
    Callback = function()
        scriptEnabled = false
        for _, part in ipairs(floatingParts) do
            if part and part:FindFirstChild("BodyPosition") then
                part.BodyPosition:Destroy()
            end
        end
        floatingParts = {}
        notify("Partes Flutuantes Descartadas", 4483345998)
        scriptEnabled = true
    end
})

MainTab:AddBind({
    Name = "Toggle Telekinese",
    Default = Enum.KeyCode.T,
    Hold = false,
    Callback = function()
        updateScriptState(not scriptEnabled)
    end
})
