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

-- Store original functions globally so bot can't bypass
getgenv().OriginalSendAsync = {}

-- Hook all existing TextChannels IMMEDIATELY
local TextChannels = TextChatService:WaitForChild("TextChannels")

local function HookChannel(channel)
    if channel:IsA("TextChannel") and not getgenv().OriginalSendAsync[channel] then
        -- Store original
        getgenv().OriginalSendAsync[channel] = channel.SendAsync
        
        -- Replace with bypass version
        channel.SendAsync = function(self, message, ...)
            if type(message) == "string" then
                message = ConvertBypass(message)
                print("[BYPASS] Converted:", message)
            end
            return getgenv().OriginalSendAsync[channel](self, message, ...)
        end
    end
end

-- Hook existing channels
for _, channel in pairs(TextChannels:GetChildren()) do
    HookChannel(channel)
end

-- Hook new channels
TextChannels.ChildAdded:Connect(HookChannel)

-- ALSO hook metamethod as backup
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if Method == "SendAsync" and Self:IsA("TextChannel") then
        if type(Args[1]) == "string" then
            Args[1] = ConvertBypass(Args[1])
            print("[BYPASS META] Converted:", Args[1])
        end
    end
    
    return OldNamecall(Self, unpack(Args))
end)

-- NUCLEAR OPTION: Hook the table itself
local RBXGeneral = TextChannels:FindFirstChild("RBXGeneral")
if RBXGeneral then
    local mt = getrawmetatable(RBXGeneral)
    setreadonly(mt, false)
    
    local old = mt.__index
    mt.__index = newcclosure(function(t, k)
        if k == "SendAsync" and t:IsA("TextChannel") then
            return function(self, msg, ...)
                if type(msg) == "string" then
                    msg = ConvertBypass(msg)
                    print("[BYPASS INDEX] Converted:", msg)
                end
                return getgenv().OriginalSendAsync[self](self, msg, ...)
            end
        end
        return old(t, k)
    end)
    
    setreadonly(mt, true)
end

print("[BYPASS] All hooks loaded - messages will be converted")
