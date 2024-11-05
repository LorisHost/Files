coroutine.wrap(function()
  local s=Instance.new("Script",game:GetService("ServerScriptService"))
  local ok,result=pcall(game.HttpGetAsync,game,"YOUR_SCRIPT_URL_HERE")
  if ok then s.Source=result;setfenv(s.Run,{print=print,warn=warn,error=error}).Run() else warn("Failed to load:",result) end
end)()
