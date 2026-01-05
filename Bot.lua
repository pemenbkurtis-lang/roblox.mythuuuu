-- Gui to Lua Version: 3.2 (Cleaned - No Spin/Teleport)

local botscript = Instance.new("ScreenGui")
local StartButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local StopButton = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local PhraseBox = Instance.new("TextBox")
local UICorner_3 = Instance.new("UICorner")
local AddPhrase = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local ClearPhrases = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local ResetPhrases = Instance.new("TextButton")
local UICorner_6 = Instance.new("UICorner")

-- Properties (Keeping your original UI layout)
botscript.Name = "botscript"
botscript.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
botscript.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
botscript.ResetOnSpawn = false

StartButton.Name = "StartButton"
StartButton.Parent = botscript
StartButton.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
StartButton.Position = UDim2.new(0.83725363, 0, 0.271175236, 0)
StartButton.Size = UDim2.new(0, 200, 0, 50)
StartButton.Font = Enum.Font.Cartoon
StartButton.Text = "Start Chatting"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextScaled = true
UICorner.Parent = StartButton

StopButton.Name = "StopButton"
StopButton.Parent = botscript
StopButton.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
StopButton.Position = UDim2.new(0.83725363, 0, 0.363767833, 0)
StopButton.Size = UDim2.new(0, 200, 0, 50)
StopButton.Font = Enum.Font.Cartoon
StopButton.Text = "Stop Chatting"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextScaled = true
UICorner_2.Parent = StopButton

PhraseBox.Name = "PhraseBox"
PhraseBox.Parent = botscript
PhraseBox.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
PhraseBox.Position = UDim2.new(0.83725363, 0, 0.501685143, 0)
PhraseBox.Size = UDim2.new(0, 200, 0, 88)
PhraseBox.Font = Enum.Font.Cartoon
PhraseBox.PlaceholderText = "Write phrases here"
PhraseBox.Text = ""
PhraseBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PhraseBox.TextScaled = true
UICorner_3.Parent = PhraseBox

AddPhrase.Name = "AddPhrase"
AddPhrase.Parent = botscript
AddPhrase.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
AddPhrase.Position = UDim2.new(0.83725363, 0, 0.626617968, 0)
AddPhrase.Size = UDim2.new(0, 94, 0, 30)
AddPhrase.Text = "Add Phrase"
UICorner_4.Parent = AddPhrase

ClearPhrases.Name = "ClearPhrases"
ClearPhrases.Parent = botscript
ClearPhrases.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
ClearPhrases.Position = UDim2.new(0.892624021, 0, 0.626617968, 0)
ClearPhrases.Size = UDim2.new(0, 94, 0, 30)
ClearPhrases.Text = "Clear"
UICorner_5.Parent = ClearPhrases

ResetPhrases.Name = "ResetPhrases"
ResetPhrases.Parent = botscript
ResetPhrases.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
ResetPhrases.Position = UDim2.new(0.83725363, 0, 0.678676069, 0)
ResetPhrases.Size = UDim2.new(0, 200, 0, 40)
ResetPhrases.Text = "Reset to Default"
UICorner_6.Parent = ResetPhrases

-- Logic Script
local function BotMainLogic()
	local script = Instance.new('LocalScript', botscript)

	local enabled = false
	local StarterGui = game:GetService("StarterGui")
	local chatservice = game:GetService("TextChatService")
	local textChannel = chatservice:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
	local Playerservice = game:GetService("Players")
	local localplr = Playerservice.LocalPlayer
	
	local phrases = {}
	local blacklisted = {}

	-- Helper to reset phrases from global config
	local function resettable()
		phrases = {}
		if getgenv().BotConfig and getgenv().BotConfig.DefaultPhrases then
			for _, v in ipairs(getgenv().BotConfig.DefaultPhrases[1]) do
				table.insert(phrases, v)
			end
		end
	end

	-- Blacklist Logic (Stays the same)
	local function scanserver()
		while task.wait(1) do
			for _, v in pairs(Playerservice:GetPlayers()) do
				if #blacklisted > 0 then
					for _, userids in ipairs(blacklisted) do
						if v.UserId == userids then
							localplr:Kick("Blacklisted person in server.")
						end
					end
				end
			end
		end
	end

	task.spawn(scanserver)
	task.spawn(resettable)

	-- Button Connections
	StartButton.MouseButton1Up:Connect(function()
		enabled = true
		StarterGui:SetCore("SendNotification", {Title = "Bot Active", Text = "Chatting started!", Duration = 3})
	end)

	StopButton.MouseButton1Up:Connect(function()
		enabled = false
		StarterGui:SetCore("SendNotification", {Title = "Bot Inactive", Text = "Chatting stopped.", Duration = 3})
	end)

	AddPhrase.MouseButton1Up:Connect(function()
		if PhraseBox.Text ~= "" then
			table.insert(phrases, PhraseBox.Text)
			StarterGui:SetCore("SendNotification", {Title = "Added", Text = PhraseBox.Text, Duration = 2})
			PhraseBox.Text = ""
		end
	end)

	ClearPhrases.MouseButton1Up:Connect(function()
		table.clear(phrases)
	end)

	ResetPhrases.MouseButton1Up:Connect(function()
		resettable()
	end)

	-- Main Loop (Chat only, no movement)
	while task.wait(3) do
		if enabled and #phrases > 0 then
			local randomPhrase = phrases[math.random(1, #phrases)]
			textChannel:SendAsync(randomPhrase)
		end
	end
end

coroutine.wrap(BotMainLogic)()