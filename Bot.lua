-- Logic Script (Modified for Auto-Start)
local function BotMainLogic()
	local script = Instance.new('LocalScript', botscript)

	-- CHANGED: Set to true so it starts immediately
	local enabled = true 
	
	local StarterGui = game:GetService("StarterGui")
	local chatservice = game:GetService("TextChatService")
	local textChannel = chatservice:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
	local Playerservice = game:GetService("Players")
	local localplr = Playerservice.LocalPlayer
	
	local phrases = {}
	local blacklisted = {}

	local function resettable()
		phrases = {}
		if getgenv().BotConfig and getgenv().BotConfig.DefaultPhrases then
			for _, v in ipairs(getgenv().BotConfig.DefaultPhrases[1]) do
				table.insert(phrases, v)
			end
		end
	end

	-- Notify user it's running
	StarterGui:SetCore("SendNotification", {
		Title = "Bot Active",
		Text = "Script executed and running!",
		Duration = 5
	})

	-- Button Connections (So you can still stop/start it manually)
	StartButton.MouseButton1Up:Connect(function()
		enabled = true
		print("Bot Resumed")
	end)

	StopButton.MouseButton1Up:Connect(function()
		enabled = false
		print("Bot Paused")
	end)

	-- Main Loop
	task.spawn(resettable)
	
	while task.wait(3) do
		if enabled then
			if #phrases > 0 then
				local randomPhrase = phrases[math.random(1, #phrases)]
				textChannel:SendAsync(randomPhrase)
			else
				-- Optional: Fallback message if no phrases are loaded yet
				print("Waiting for phrases to be added...")
			end
		end
	end
end

coroutine.wrap(BotMainLogic)()
