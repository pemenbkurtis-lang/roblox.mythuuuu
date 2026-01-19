local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local SpecialCharacter = utf8.char(0x060D) -- The character used to break up text

local function SendChatMessage(Message)
    local Channel = TextChatService:FindFirstChild("RBXGeneral", true)
    if Channel then
        Channel:SendAsync(Message)
    end
end

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

-- The logic that reverses and injects invisible characters
local function ConvertBypass(Text)
    local Reverse = utf8_reverse(Text)
    local New = {}

    for Word in Reverse:gmatch("%S+") do
        local Letters = utf8_chars(Word)
        local Fill = SpecialCharacter .. table.concat(Letters, SpecialCharacter)
        table.insert(New, Fill)
    end

    return table.concat(New, " ")
end

-- Automatic Hook into the Chat Box
local function InitializeBypass()
    local ExpChat = CoreGui:WaitForChild("ExperienceChat", 10)
    if not ExpChat then return end

    local Box = ExpChat:FindFirstChild("TextBox", true)
    if not Box then return end

    Box.MultiLine = true -- Allows for processing before sending

    UserInputService.InputBegan:Connect(function(Input, Processed)
        if Input.KeyCode == Enum.KeyCode.Return and Box:IsFocused() then
            local RawText = Box.Text:gsub("%s+$", "")
            
            if RawText:match("%S") then
                Box.Text = "" -- Clear the box
                Box:ReleaseFocus()
                
                local ProcessedText = ConvertBypass(RawText)
                SendChatMessage(ProcessedText)
            end
        end
    end)
end

-- Run immediately
task.spawn(InitializeBypass)
