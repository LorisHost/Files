-- Modified By Tencent
local Scripts = {
    ["Evade"] = {
        Ids = {9872472334, 10808838353, 10539706691, 10324347967, 10662542523, 10324346056},
        Url = "https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua"
    },
    ["Knife Ability Test"] = {
        Ids = {621129760},
        Url = "https://raw.githubusercontent.com/zReal-King/Knife-Ability-Test/main/Gui" 
    },
    ["Rainbow Friends"] = {
        Ids = {7991339063, 13622985049, 8888615802, 13622981808},
        Url = "https://raw.githubusercontent.com/zReal-King/Rainbow-Friends/main/Main.lua"
    },
    ["Pets GO"] = {
        Ids = {18901165922, 19006211286},
        Url = "https://raw.githubusercontent.com/zReal-King/Pets-Go/refs/heads/main/Main.lua"
    }
}

local placeId = game.PlaceId

for name, data in pairs(Scripts) do
    for _, id in ipairs(data.Ids) do
        if id == placeId then
            local success, result = pcall(loadstring, game:HttpGet(data.Url))
            if not success then 
                warn("Error executing script for '" .. name .. "' (PlaceId: " .. placeId .. "): " .. result) 
            end
            return -- Stop after finding and executing the script
        end
    end
end
