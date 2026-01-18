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

-- Get the TextChannels folder
local TextChannels = TextChatService:WaitForChild("TextChannels")

-- Wait for RBXGeneral to exist
local RBXGeneral = TextChannels:WaitForChild("RBXGeneral")

-- HOOK THE ACTUAL SENDASYNC METHOD BEFORE THE BOT LOADS
local OriginalSendAsync = RBXGeneral.SendAsync

-- Replace it with our bypassed version
RBXGeneral.SendAsync = function(self, message, ...)
    if type(message) == "string" then
        local converted = ConvertBypass(message)
        print("[BYPASS] Original:", message)
        print("[BYPASS] Converted:", converted)
        return OriginalSendAsync(self, converted, ...)
    end
    return OriginalSendAsync(self, message, ...)
end

-- ALSO hook the metamethod as a backup
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if Method == "SendAsync" and Self:IsA("TextChannel") then
        if type(Args[1]) == "string" then
            Args[1] = ConvertBypass(Args[1])
        end
    end
    
    return OldNamecall(Self, unpack(Args))
end)

print("[BYPASS] Loaded successfully - All messages will be bypassed")
