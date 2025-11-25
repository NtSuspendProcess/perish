local ok,chunk = pcall(loadfile,"perish/src/core/loader.lua")
if not ok then error(chunk,0) end
chunk().start()
