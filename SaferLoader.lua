task.spawn(function()
  local ok, result = pcall(game.HttpGetAsync, game, "https://raw.githubusercontent.com/LorisHost/lzosiexw/refs/heads/main/frtxhub.lua")
  if ok then
    pcall(loadstring(result))
    game:GetService("StarterGui"):SetCore("SendNotification", {
      Title = "Script Loaded",
      Text = "Script loaded successfully!", 
      Duration = 5
    })
  else
    warn("Error:", result)
  end
end)
