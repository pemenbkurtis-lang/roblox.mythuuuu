-- [[ TEXTCHAT SERVICE BYPASS HOOK FOR XENO ]] --

local TextChatService = game:GetService("TextChatService")

-- Utility functions
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
    if type(Text) ~= "string" then return Text end
    
    local Reverse = utf8_reverse(Text)
    local New = {}

    for Word in Reverse:gmatch("%S+") do
        local Letters = utf8_chars(Word)
        local Fill = Special .. table.concat(Letters, Special)
        table.insert(New, Fill)
    end

    return table.concat(New, " ")
end

-- Wait for services
local TextChannels = TextChatService:WaitForChild("TextChannels")
local RBXGeneral = TextChannels:WaitForChild("RBXGeneral")

-- Store original if not already stored
if not getgenv().OriginalSendAsync then
    getgenv().OriginalSendAsync = RBXGeneral.SendAsync
end

-- Hook SendAsync
RBXGeneral.SendAsync = newcclosure(function(self, message, ...)
    if type(message) == "string" then
        local converted = ConvertBypass(message)
        print("[BYPASS] " .. message .. " → " .. converted)
        return getgenv().OriginalSendAsync(self, converted, ...)
    end
    return getgenv().OriginalSendAsync(self, message, ...)
end)

print("[✓] Chat bypass loaded successfully")
