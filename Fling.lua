
local Targets = {"All"} 
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
 
getgenv().LoopFling = true
workspace.FallenPartsDestroyHeight = 0/1/0 -- Sets to NaN to prevent dying while flinging
 
local GetPlayer = function(Name)
    Name = Name:lower()
    if Name == "all" or Name == "others" then
        return Players:GetPlayers()
    else
        for _, x in next, Players:GetPlayers() do
            if x ~= Player and (x.Name:lower():match("^" .. Name) or x.DisplayName:lower():match("^" .. Name)) then
                return {x}
            end
        end
    end
    return {}
end
 
local ContinuousFling = function(TargetPlayer)
    local Character = Player.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local TCharacter = TargetPlayer.Character
    local TRootPart = TCharacter and TCharacter:FindFirstChild("HumanoidRootPart")
 
    if not RootPart or not TRootPart then return end
 
    -- Keep the camera on target for stability
    workspace.CurrentCamera.CameraSubject = TRootPart
 
    local Time = tick()
    -- Reduced the repeat duration for faster switching between "All" targets
    repeat
        RootPart.CFrame = TRootPart.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
        RootPart.Velocity = Vector3.new(9e7, 9e7, 9e7)
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        task.wait() 
    until not TargetPlayer or not TCharacter or (TRootPart.Velocity.Magnitude > 500) or (tick() > Time + 0.5)
end
 
-- 🔁 MAIN LOOP
task.spawn(function()
    -- Disable seating once to prevent interruption
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid"):SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    end
 
    while getgenv().LoopFling do
        for _, tName in pairs(Targets) do
            local targetList = GetPlayer(tName)
            for _, plr in pairs(targetList) do
                if plr ~= Player and plr.Character then
                    ContinuousFling(plr)
                end
            end
        end
        task.wait() -- Minimal delay to prevent engine crash
    end
end)
