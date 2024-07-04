-- GamepassScript.lua

local MainTab = Window:FindTab("Main")

MainTab:AddButton({
    Name = "Free gamepass bypass 70%",
    Description = "Tenta obter gamepasses na maioria dos jogos (70% de chance). Alguns jogos podem não funcionar.",
    Callback = function()
        if game.CreatorType == Enum.CreatorType.User then
            game.Players.LocalPlayer.UserId = game.CreatorId
        end
        if game.CreatorType == Enum.CreatorType.Group then
            game.Players.LocalPlayer.UserId = game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId).Owner.Id
        end
    end
})

local function checkPremium()
    local hasGamepass = false
    return hasGamepass
end

local isPremium = checkPremium()

if isPremium then
    MainTab:AddButton({
        Name = "Buy Premium",
        Callback = function()
        end
    })
    
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftShift then
            local target = mouse.Target
            if target then
                ghostTeleport(target)
            end
        end
    end)
end
