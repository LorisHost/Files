local placeScripts = {
    [16896041188] = loadstring(game:HttpGet("https://raw.githubusercontent.com/LorisHost/Files/refs/heads/main/Survive%20nightmare%20XChristianXsj.lua")),
    [14722542056] = loadstring(game:HttpGet("https://raw.githubusercontent.com/LorisHost/Files/refs/heads/main/Sonic.EXE%3A%20The%20Disaster%201.3.lua")),
}
if placeScripts[game.PlaceId]
    then
    placeScripts[game.PlaceId]()
end
