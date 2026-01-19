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

-- Store in global environment so it persists
getgenv().BypassEnabled = true

-- Wait for TextChannels
local TextChannels = TextChatService:WaitForChild("TextChannels")

-- Wait for RBXGeneral specifically
local RBXGeneral = TextChannels:WaitForChild("RBXGeneral")

-- Store the REAL original SendAsync before anything else touches it
if not getgenv().OriginalSendAsync then
    getgenv().OriginalSendAsync = RBXGeneral.SendAsync
end

-- Replace SendAsync with our bypassed version
RBXGeneral.SendAsync = newcclosure(function(self, message, ...)
    if type(message) == "string" and getgenv().BypassEnabled then
        local converted = ConvertBypass(message)
        print("[BYPASS] Converting message...")
        print("[BYPASS] Before:", message)
        print("[BYPASS] After:", converted)
        return getgenv().OriginalSendAsync(self, converted, ...)
    end
    return getgenv().OriginalSendAsync(self, message, ...)
end)

-- ALSO hook metamethod for extra protection
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "SendAsync" and self == RBXGeneral then
            if type(args[1]) == "string" and getgenv().BypassEnabled then
                args[1] = ConvertBypass(args[1])
                print("[META BYPASS] Converted:", args[1])
            end
            return oldNamecall(self, unpack(args))
        end
        
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

wait(1) -- Give hooks time to settle

print("[✓ BYPASS] Ready - All messages will be converted with special characters")
