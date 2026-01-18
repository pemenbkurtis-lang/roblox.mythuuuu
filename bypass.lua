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
    local Reverse = utf8_reverse(Text)
    local New = {}

    for Word in Reverse:gmatch("%S+") do
        local Letters = utf8_chars(Word)
        local Fill = Special .. table.concat(Letters, Special)
        table.insert(New, Fill)
    end

    return table.concat(New, " ")
end

-- Hook method for Xeno
local success, OldNamecall = pcall(function()
    return hookmetamethod(game, "__namecall", function(Self, ...)
        local Args = {...}
        local Method = getnamecallmethod()
        
        -- Hook SendAsync for TextChannel
        if Method == "SendAsync" and Self:IsA("TextChannel") then
            if type(Args[1]) == "string" then
                Args[1] = ConvertBypass(Args[1])
            end
        end
        
        return OldNamecall(Self, unpack(Args))
    end)
end)

if not success then
    warn("[BYPASS] Failed to hook: " .. tostring(OldNamecall))
    
    -- Fallback: Try hooking the TextChannel directly
    local TextChannels = TextChatService:WaitForChild("TextChannels")
    
    for _, channel in pairs(TextChannels:GetChildren()) do
        if channel:IsA("TextChannel") then
            local OldSend = channel.SendAsync
            channel.SendAsync = function(self, message)
                if type(message) == "string" then
                    message = ConvertBypass(message)
                end
                return OldSend(self, message)
            end
        end
    end
    
    TextChannels.ChildAdded:Connect(function(channel)
        if channel:IsA("TextChannel") then
            task.wait(0.1)
            local OldSend = channel.SendAsync
            channel.SendAsync = function(self, message)
                if type(message) == "string" then
                    message = ConvertBypass(message)
                end
                return OldSend(self, message)
            end
        end
    end)
end

print("[BYPASS] TextChat bypass loaded successfully")
