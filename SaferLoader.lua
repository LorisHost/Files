local t = os.clock()
task.spawn(function()
  local ok, _ = pcall(game.HttpGetAsync, game, "https://raw.githubusercontent.com/LorisHost/lzosiexw/refs/heads/main/frtxhub.lua")
  if ok then
    game:GetService("StarterGui"):SetCore("SendNotification", {
      Title = "Script Loaded",
      Text = string.format("Loaded in %.2fs!", os.clock() - t),
      Duration = 5
    })
  else
    warn("Error loading script.")
  end
end)
