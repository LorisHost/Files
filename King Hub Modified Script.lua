local function run(script)
  local s, r = pcall(loadstring(script))
  if not s then warn(r) end
end

local id = game.PlaceId
local scripts = {
  [9872472334] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
    name = "Evade" 
  },
  [10808838353] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
    name = "Evade" 
  },
  [10539706691] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
    name = "Evade" 
  },
  [10324347967] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
    name = "Evade" 
  },
  [10662542523] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
    name = "Evade" 
  },
  [10324346056] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Evade/main/Main.lua')))",
    name = "Evade" 
  },
  [621129760] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Knife-Ability-Test/main/Gui')))",
    name = "Knife Ability Test" 
  },
  [7991339063] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Rainbow-Friends/main/Main.lua')))",
    name = "Rainbow Friends" 
  },
  [13622985049] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Rainbow-Friends/main/Main.lua')))",
    name = "Rainbow Friends" 
  },
  [8888615802] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Rainbow-Friends/main/Main.lua')))",
    name = "Rainbow Friends" 
  },
  [13622981808] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Rainbow-Friends/main/Main.lua')))",
    name = "Rainbow Friends"
  },
  [18901165922] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Pets-Go/refs/heads/main/Main.lua')))",
    name = "Pets GO" 
  },
  [19006211286] = { 
    script = "pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Pets-Go/refs/heads/main/Main.lua')))",
    name = "Pets GO" 
  }
}

if scripts[id] then
  print("Running script for:", scripts[id].name)
  run(scripts[id].script)
else
  print("Running Universal script")
  run("pcall(loadstring(game:HttpGet('https://raw.githubusercontent.com/zReal-King/Universal/refs/heads/main/Main.lua')))")
end
