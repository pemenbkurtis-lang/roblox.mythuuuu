-- [[ TEXTCHAT SERVICE BYPASS HOOK ]] --

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
    local Reverse = utf8_reverse(Text)
    local New = {}

    for Word in Reverse:gmatch("%S+") do
        local Letters = utf8_chars(Word)
        local Fill = Special .. table.concat(Letters, Special)
        table.insert(New, Fill)
    end

    return table.concat(New, " ")
end

-- Hook TextChatService SendAsync
local RawMetatable = getrawmetatable(game)
local OldNamecall = RawMetatable.__namecall
setreadonly(RawMetatable, false)

RawMetatable.__namecall = newcclosure(function(Self, ...)
    local Method = getnamecallmethod()
    local Args = {...}

    -- Intercept SendAsync calls to TextChannels
    if Method == "SendAsync" and Self:IsA("TextChannel") then
        local OriginalMessage = Args[1]
        if type(OriginalMessage) == "string" then
            Args[1] = ConvertBypass(OriginalMessage)
        end
        return OldNamecall(Self, unpack(Args))
    end

    return OldNamecall(Self, ...)
end)

setreadonly(RawMetatable, true)

print("TextChat Bypass Hook Loaded.")
