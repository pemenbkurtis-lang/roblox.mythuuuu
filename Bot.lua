local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local VIM = game:GetService("VirtualInputManager")

local localplr = Players.LocalPlayer
local pg = localplr:WaitForChild("PlayerGui")

local REQUIRE_GLOBAL_TAB = false -- set true to skip sending unless Global tab is active
local cfgInterval = getgenv().BotConfig and getgenv().BotConfig.Interval
local INTERVAL = math.max(1, cfgInterval or 1)

-- Remove a previous copy so loops don't stack
local old = pg:FindFirstChild("botscript")
if old then old:Destroy() end

local enabled = true
local phrases, bag, blacklisted = {}, {}, {}

local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
	end)
end

local function resetPhrases()
	table.clear(phrases)
	table.clear(bag)
	local cfg = getgenv().BotConfig
	if cfg and cfg.DefaultPhrases and cfg.DefaultPhrases[1] then
		for _, v in ipairs(cfg.DefaultPhrases[1]) do
			table.insert(phrases, v)
		end
	end
end

local function nextPhrase()
	if #phrases == 0 then return nil end
	if #bag == 0 then
		for i, v in ipairs(phrases) do bag[i] = v end
		for i = #bag, 2, -1 do
			local j = math.random(i)
			bag[i], bag[j] = bag[j], bag[i]
		end
	end
	return table.remove(bag)
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "botscript"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = pg

local function make(class, props)
	local o = Instance.new(class)
	o.BackgroundColor3 = Color3.fromRGB(245, 139, 87)
	o.BorderSizePixel = 0
	o.Font = Enum.Font.Cartoon
	o.TextColor3 = Color3.fromRGB(255, 255, 255)
	o.TextScaled = true
	o.TextWrapped = true
	for k, v in pairs(props) do o[k] = v end
	Instance.new("UICorner").Parent = o
	o.Parent = gui
	return o
end

local X = 0.83725363
local startBtn = make("TextButton", {Name = "StartButton", Text = "Start", Position = UDim2.new(X, 0, 0.2712, 0), Size = UDim2.new(0, 200, 0, 50)})
local stopBtn = make("TextButton", {Name = "StopButton", Text = "Stop", Position = UDim2.new(X, 0, 0.3638, 0), Size = UDim2.new(0, 200, 0, 50)})
local phraseBox = make("TextBox", {Name = "PhraseBox", Text = "", PlaceholderText = "Write phrases to add here", PlaceholderColor3 = Color3.fromRGB(184, 184, 184), ClearTextOnFocus = false, MultiLine = true, Position = UDim2.new(X, 0, 0.5017, 0), Size = UDim2.new(0, 200, 0, 88)})
local addBtn = make("TextButton", {Name = "AddPhrase", Text = "Add Phrase", Position = UDim2.new(X, 0, 0.6266, 0), Size = UDim2.new(0, 94, 0, 30)})
local clearBtn = make("TextButton", {Name = "ClearPhrases", Text = "Clear Phrases", Position = UDim2.new(0.8926, 0, 0.6266, 0), Size = UDim2.new(0, 94, 0, 30)})
local resetBtn = make("TextButton", {Name = "ResetPhrases", Text = "Reset Phrases", Position = UDim2.new(X, 0, 0.6787, 0), Size = UDim2.new(0, 200, 0, 40)})

startBtn.MouseButton1Up:Connect(function() enabled = true notify("Enabled", "Bot started") end)
stopBtn.MouseButton1Up:Connect(function() enabled = false notify("Disabled", "Bot stopped") end)
addBtn.MouseButton1Up:Connect(function()
	local text = phraseBox.Text:match("^%s*(.-)%s*$")
	if text ~= "" then
		table.insert(phrases, text)
		table.clear(bag)
		notify("Added", text)
	end
end)
clearBtn.MouseButton1Up:Connect(function() table.clear(phrases) table.clear(bag) end)
resetBtn.MouseButton1Up:Connect(resetPhrases)

-- Blacklist (event-based)
local function checkBlacklist(plr)
	if table.find(blacklisted, plr.UserId) then
		localplr:Kick("You cannot be in a server with this person")
	end
end
local bl = getgenv().Blacklist
if bl and bl.blacklistt and bl.blacklistt[1] then
	for _, id in ipairs(bl.blacklistt[1]) do table.insert(blacklisted, id) end
end
Players.PlayerAdded:Connect(checkBlacklist)
for _, p in ipairs(Players:GetPlayers()) do checkBlacklist(p) end

-- Auto-unsit (event-based)
local function hookCharacter(char)
	local hum = char:WaitForChild("Humanoid", 10)
	if not hum then return end
	if hum.Sit then hum.Sit = false end
	hum:GetPropertyChangedSignal("Sit"):Connect(function()
		if hum.Sit then hum.Sit = false end
	end)
end
if localplr.Character then task.spawn(hookCharacter, localplr.Character) end
localplr.CharacterAdded:Connect(hookCharacter)

-- Sending through the chat box
local inputCfg = TextChatService:FindFirstChild("ChatInputBarConfiguration")
local cachedBox

local function getBox()
	if cachedBox and cachedBox.Parent then return cachedBox end
	for _, v in ipairs(CoreGui:GetDescendants()) do
		if v:IsA("TextBox") and (v:FindFirstAncestor("chatInputBar") or v:FindFirstAncestor("ChatInputBar")) then
			cachedBox = v
			return v
		end
	end
end

local RunService = game:GetService("RunService")

local function send(msg)
	if REQUIRE_GLOBAL_TAB and inputCfg and inputCfg.TargetTextChannel ~= nil then
		return false, "Global tab isn't selected"
	end

	local box = getBox()
	if not box then return false, "Chat box not found" end

	local oldTransparency = box.TextTransparency
	box.TextTransparency = 1 -- hide the pasted text

	local submitted = false
	local lock = box:GetPropertyChangedSignal("Text"):Connect(function()
		-- undo any leaked keystrokes until the message is submitted
		if not submitted and box.Text ~= msg then
			box.Text = msg
		end
	end)

	box:CaptureFocus()
	box.Text = msg
	RunService.Heartbeat:Wait() -- one frame so the text registers
	box.Text = msg              -- re-assert in case a key slipped in

	submitted = true
	VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
	task.wait(0.03)
	VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
	task.wait(0.1)

	-- fallback if Enter didn't register
	if box.Text == msg and keypress and keyrelease then
		keypress(0x0D)
		task.wait(0.03)
		keyrelease(0x0D)
		task.wait(0.1)
	end

	lock:Disconnect()
	if box.Text == msg then box.Text = "" end
	if box:IsFocused() then box:ReleaseFocus() end
	box.TextTransparency = oldTransparency
	return true
end

	-- Method 2: keypress, with a short focus window
	if not delivered then
		box:CaptureFocus()
		box.Text = msg
		task.wait(0.08)
		VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
		task.wait(0.03)
		VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
		task.wait(0.1)

		if box.Text == msg and keypress and keyrelease then
			keypress(0x0D)
			task.wait(0.03)
			keyrelease(0x0D)
			task.wait(0.1)
		end
	end

	-- cleanup
	if box.Text == msg then box.Text = "" end
	if box:IsFocused() then box:ReleaseFocus() end
	box.TextTransparency = oldTransparency
	return true
end

-- Main loop
resetPhrases()
print("[bot] loaded. phrases:", #phrases, "interval:", INTERVAL)

local lastReason = ""
task.spawn(function()
	while gui.Parent do
		task.wait(INTERVAL)
		if enabled then
			local msg = nextPhrase()
			if msg then
				local ok, sent, reason = pcall(send, msg)
				if not ok then
					warn("[bot] error:", sent)
				elseif sent then
					print("[bot] sent:", msg)
				elseif reason ~= lastReason then
					lastReason = reason
					notify("Not sent", tostring(reason))
				end
			end
		end
	end
end)
