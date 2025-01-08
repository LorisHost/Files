local PromptInterface = loadstring(game:HttpGet("https://raw.githubusercontent.com/CookieCrumble2/Prompt-UI/refs/heads/main/load.lua"))()
PromptInterface.create(
    "can't continue the script...", -- Title
    ":(", -- Description
    "Execute", -- Primary Button Text
    "Exit", -- Secondary Button Text
    function(response)
        if response then
local placeScripts = {
    [16896041188] = loadstring(game:HttpGet("https://raw.githubusercontent.com/LorisHost/Files/refs/heads/main/Survive%20nightmare%20XChristianXsj.lua")),
    [14722542056] = loadstring(game:HttpGet("https://raw.githubusercontent.com/LorisHost/Files/refs/heads/main/Sonic.EXE%3A%20The%20Disaster%201.3.lua")),
}

if not placeScripts[game.PlaceId] then
    loadstring(game:HttpGet("https://paste.gg/p/sorx./60165cb7336043c1b13bec4c715a39c7/files/398cc92f126c462d9d3fc86842deb41e/raw"))()
else
    placeScripts[game.PlaceId]()
end
        else
    print("wait then or join discord server https://discord.gg/EuaYmUxayz")     
end
    end
)
