local function run(script)
  local s, r = pcall(loadstring(script))
  if not s then warn(r) end
end

local id = game.PlaceId
local scripts = {
  [9872472334] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
  [10808838353] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
  [10539706691] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
  [10324347967] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
  [10662542523] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
  [10324346056] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
  [621129760] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Knife-Ability-Test/main/Gui')))",
  [7991339063] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Rainbow-Friends/main/Main.lua')))",
  [13622985049] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Rainbow-Friends/main/Main.lua')))",
  [8888615802] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Rainbow-Friends/main/Main.lua')))",
  [13622981808] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Rainbow-Friends/main/Main.lua')))",
  [18901165922] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Pets-Go/refs/heads/main/Main.lua')))",
  [19006211286] = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Pets-Go/refs/heads/main/Main.lua')))",
}

if scripts[id] then
  run(scripts[id])
else
  run("pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Universal/refs/heads/main/Main.lua')))")
end
