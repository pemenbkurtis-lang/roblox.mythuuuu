local Targets = {"All"} 
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")

getgenv().LoopFling = true

-- Safe workspace modification with error handling
pcall(function()
    workspace.FallenPartsDestroyHeight = 0/0
end)

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
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not RootPart or not TRootPart or not Humanoid then return end

    -- Try to disable Humanoid physics
    pcall(function()
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end)
    
    workspace.CurrentCamera.CameraSubject = TRootPart

    local StartTime = tick()
    local FlingConnection
    
    -- Use Heartbeat for frame-perfect physics updates
    FlingConnection = RunService.Heartbeat:Connect(function()
        -- Validate targets still exist
        if not TargetPlayer.Character or not TCharacter.Parent or not TRootPart.Parent or not RootPart.Parent then
            if FlingConnection then FlingConnection:Disconnect() end
            return
        end

        -- Get ping with fallback
        local Ping = 0.1 -- Default 100ms
        pcall(function()
            local actualPing = Player:GetNetworkPing()
            if actualPing and actualPing > 0 then
                Ping = actualPing
            end
        end)
        
        -- Predict target position based on velocity and ping
        local PredictedPos = TRootPart.Position + (TRootPart.AssemblyLinearVelocity * Ping)
        
        -- Random offset for collision variance
        local Offset = Vector3.new(math.random(-2, 2), math.random(-1, 1), math.random(-2, 2))
        
        -- Apply position
        pcall(function()
            RootPart.CFrame = CFrame.new(PredictedPos + Offset)
        end)
        
        -- Apply extreme velocities (try both old and new properties)
        pcall(function()
            RootPart.AssemblyLinearVelocity = Vector3.new(9e7, 9e7, 9e7)
        end)
        pcall(function()
            RootPart.Velocity = Vector3.new(9e7, 9e7, 9e7)
        end)
        pcall(function()
            RootPart.AssemblyAngularVelocity = Vector3.new(9e8, 9e8, 9e8)
        end)
        pcall(function()
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end)
        
        -- Exit if target is flung or timeout
        local targetVel = TRootPart.AssemblyLinearVelocity.Magnitude
        if targetVel > 500 or tick() > StartTime + 1.5 then
            if FlingConnection then FlingConnection:Disconnect() end
        end
    end)
    
    -- Wait for fling completion
    task.wait(1.5)
    if FlingConnection and FlingConnection.Connected then 
        pcall(function() FlingConnection:Disconnect() end)
    end
end

-- Character respawn handler
Player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local Humanoid = char:WaitForChild("Humanoid", 5)
    if Humanoid then
        pcall(function()
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        end)
    end
end)

-- Main loop
task.spawn(function()
    -- Initial setup
    task.wait(0.5)
    
    if Player.Character then
        local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            pcall(function()
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            end)
        end
    end

    while getgenv().LoopFling do
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            for _, tName in pairs(Targets) do
                local targetList = GetPlayer(tName)
                for _, plr in pairs(targetList) do
                    if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        pcall(function()
                            ContinuousFling(plr)
                        end)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

print("[Universal Fling] Script loaded | Targets: " .. table.concat(Targets, ", "))
