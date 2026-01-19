-- Gui to Lua
-- Version: 3.2
-- With Built-in Chat Bypass

-- [[ CHAT BYPASS FUNCTIONS ]] --
local function utf8_chars(str)
    local chars = {}
    for _, c in utf8.codes(str) do
        table.insert(chars, utf8.char(c))
    end
    return chars
end

local function utf8_reverse(str)
    local chars = utf8_chars(str)
    local rev = {}
    for i = #chars, 1, -1 do
        table.insert(rev, chars[i])
    end
    return table.concat(rev)
end

local Special = utf8.char(0x060D)
local function ConvertBypass(Text)
    local Reverse = utf8_reverse(Text)
    local New = {}
    for Word in Reverse:gmatch("%S+") do
        local Letters = utf8_chars(Word)
        local Fill = Special .. table.concat(Letters, Special)
        table.insert(New, Fill)
    end
    return table.concat(New, " ")
end

-- Hooking the actual internal Service instead of the TextBox
local RawMetatable = getrawmetatable(game)
local OldNamecall = RawMetatable.__namecall
setreadonly(RawMetatable, false)
RawMetatable.__namecall = newcclosure(function(Self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    -- Check if a script is trying to call SendAsync on a TextChannel
    if not checkcaller() and Method == "SendAsync" and Self.ClassName == "TextChannel" then
        local OriginalMessage = Args[1]
        Args[1] = ConvertBypass(OriginalMessage) -- Apply the bypass
        return OldNamecall(Self, unpack(Args))
    end
    return OldNamecall(Self, ...)
end)
setreadonly(RawMetatable, true)

print("[Chat Bypass] Loaded - All bot messages will be bypassed")

-- [[ GUI INSTANCES ]] --

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

--Properties:

botscript.Name = "botscript"
botscript.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
botscript.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
botscript.ResetOnSpawn = false

StartButton.Name = "StartButton"
StartButton.Parent = botscript
StartButton.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
StartButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
StartButton.BorderSizePixel = 0
StartButton.Position = UDim2.new(0.83725363, 0, 0.271175236, 0)
StartButton.Size = UDim2.new(0, 200, 0, 50)
StartButton.Font = Enum.Font.Cartoon
StartButton.Text = "Start"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextScaled = true
StartButton.TextSize = 14.000
StartButton.TextWrapped = true

UICorner.Parent = StartButton

StopButton.Name = "StopButton"
StopButton.Parent = botscript
StopButton.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
StopButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
StopButton.BorderSizePixel = 0
StopButton.Position = UDim2.new(0.83725363, 0, 0.363767833, 0)
StopButton.Size = UDim2.new(0, 200, 0, 50)
StopButton.Font = Enum.Font.Cartoon
StopButton.Text = "Stop"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextScaled = true
StopButton.TextSize = 14.000
StopButton.TextWrapped = true

UICorner_2.Parent = StopButton

PhraseBox.Name = "PhraseBox"
PhraseBox.Parent = botscript
PhraseBox.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
PhraseBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
PhraseBox.BorderSizePixel = 0
PhraseBox.Position = UDim2.new(0.83725363, 0, 0.501685143, 0)
PhraseBox.Size = UDim2.new(0, 200, 0, 88)
PhraseBox.ClearTextOnFocus = false
PhraseBox.Font = Enum.Font.Cartoon
PhraseBox.MultiLine = true
PhraseBox.PlaceholderColor3 = Color3.fromRGB(184, 184, 184)
PhraseBox.PlaceholderText = "Write phrases to add here"
PhraseBox.Text = ""
PhraseBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PhraseBox.TextScaled = true
PhraseBox.TextSize = 14.000
PhraseBox.TextWrapped = true

UICorner_3.Parent = PhraseBox

AddPhrase.Name = "AddPhrase"
AddPhrase.Parent = botscript
AddPhrase.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
AddPhrase.BorderColor3 = Color3.fromRGB(0, 0, 0)
AddPhrase.BorderSizePixel = 0
AddPhrase.Position = UDim2.new(0.83725363, 0, 0.626617968, 0)
AddPhrase.Size = UDim2.new(0, 94, 0, 30)
AddPhrase.Font = Enum.Font.Cartoon
AddPhrase.Text = "Add Phrase"
AddPhrase.TextColor3 = Color3.fromRGB(255, 255, 255)
AddPhrase.TextScaled = true
AddPhrase.TextSize = 14.000
AddPhrase.TextWrapped = true

UICorner_4.Parent = AddPhrase

ClearPhrases.Name = "ClearPhrases"
ClearPhrases.Parent = botscript
ClearPhrases.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
ClearPhrases.BorderColor3 = Color3.fromRGB(0, 0, 0)
ClearPhrases.BorderSizePixel = 0
ClearPhrases.Position = UDim2.new(0.892624021, 0, 0.626617968, 0)
ClearPhrases.Size = UDim2.new(0, 94, 0, 30)
ClearPhrases.Font = Enum.Font.Cartoon
ClearPhrases.Text = "Clear Phrases"
ClearPhrases.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearPhrases.TextScaled = true
ClearPhrases.TextSize = 14.000
ClearPhrases.TextWrapped = true

UICorner_5.Parent = ClearPhrases

ResetPhrases.Name = "ResetPhrases"
ResetPhrases.Parent = botscript
ResetPhrases.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
ResetPhrases.BorderColor3 = Color3.fromRGB(0, 0, 0)
ResetPhrases.BorderSizePixel = 0
ResetPhrases.Position = UDim2.new(0.83725363, 0, 0.678676069, 0)
ResetPhrases.Size = UDim2.new(0, 200, 0, 40)
ResetPhrases.Font = Enum.Font.Cartoon
ResetPhrases.Text = "Reset Phrases"
ResetPhrases.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetPhrases.TextScaled = true
ResetPhrases.TextSize = 14.000
ResetPhrases.TextWrapped = true

UICorner_6.Parent = ResetPhrases

-- Scripts:

local function BLQRFBV_fake_script() -- botscript.BotMain
	local script = Instance.new('LocalScript', botscript)

	local enabled = true
	local StarterGui = game:GetService("StarterGui")
	local chatservice = game:GetService("TextChatService")
	local textChannel = chatservice:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
	local startbutton = script.Parent:WaitForChild("StartButton")
	local stopbutton = script.Parent:WaitForChild("StopButton")
	local addphrase = script.Parent:WaitForChild("AddPhrase")
	local clearphrases = script.Parent:WaitForChild("ClearPhrases")
	local phrasebox = script.Parent:WaitForChild("PhraseBox")
	local resetphrases = script.Parent:WaitForChild("ResetPhrases")
	local Playerservice = game:GetService("Players")
	local phrases = {}
	local blacklisted = {}
	local localplr = Playerservice.LocalPlayer
	
	local function resettable()
		phrases = {}
		if getgenv().BotConfig and getgenv().BotConfig.DefaultPhrases then
			for i,v in ipairs(getgenv().BotConfig.DefaultPhrases[1]) do
				table.insert(phrases,v)
			end
		end
	end
	
	game.Players.PlayerAdded:Connect(function(plr)
		for i,v in pairs(blacklisted) do
			if plr.UserId == v then
				localplr:Kick("You cannot be in a server with this person")
			end
		end
	end)
	
	local function scanserver()
		while task.wait(0.1) do
			for i,v in pairs(Playerservice:GetPlayers()) do
				if #blacklisted > 0 then
					for i,userids in ipairs(blacklisted) do
						if v.UserId == userids then
							localplr:Kick("You cannot be in a server with this person")
						end
					end
				end
			end
		end
	end
	
	local function refbblacklist()
		if getgenv().Blacklist and getgenv().Blacklist.blacklistt then
			for i,v in ipairs(getgenv().Blacklist.blacklistt[1]) do
				table.insert(blacklisted,v)
			end
		end
	end
	
	task.spawn(refbblacklist)
	task.spawn(scanserver)
	task.spawn(resettable)
	
	local function onandoff()
		startbutton.MouseButton1Up:Connect(function()
			enabled = true
			StarterGui:SetCore("SendNotification", {Title = "Enabled", Text = "Bot started", Duration = 3})
		end)
		stopbutton.MouseButton1Up:Connect(function()
			enabled = false
			StarterGui:SetCore("SendNotification", {Title = "Disabled", Text = "Bot stopped", Duration = 3})
		end)
		addphrase.MouseButton1Up:Connect(function()
			table.insert(phrases, phrasebox.Text)
			StarterGui:SetCore("SendNotification", {Title = "Added", Text = phrasebox.Text, Duration = 3})
		end)
		clearphrases.MouseButton1Up:Connect(function()
			table.clear(phrases)
		end)
		resetphrases.MouseButton1Up:Connect(function()
			table.clear(phrases)
			task.spawn(resettable)
		end)
	end
	
	task.spawn(onandoff)
	
	local function unsit()
		while task.wait(0.1) do
			if localplr.Character and localplr.Character:FindFirstChildOfClass("Humanoid") then
				local hum = localplr.Character:FindFirstChildOfClass("Humanoid")
				if hum.Sit then
					hum.Sit = false
				end
			end
		end
	end
	
	task.spawn(unsit)
	
	while task.wait(3) do
		if enabled == true then
			if #phrases > 0 then
				textChannel:SendAsync(phrases[math.random(1,#phrases)])
			end
		end
	end
end
coroutine.wrap(BLQRFBV_fake_script)()
