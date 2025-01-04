local placeScripts = {
    [124563] = loadstring(game:HttpGet("scriptURL1")),
    [987654] = loadstring(game:HttpGet("scriptURL2")),
}
if placeScripts[game.PlaceId]
    then
    placeScripts[game.PlaceId]()
end
