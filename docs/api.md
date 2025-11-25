# perish api

env bus (passed to every module)
- env.log(msg)         -> drawing chat print
- env.const.*          -> all shared shortcuts (services, math, tween, ray, etc.)
- env.undo             -> { push(fn), fire() }  cleanup registry
- env.pcall(fn,...)    -> silent error wrapper
- env.perish           -> active universal script table (after loader)

console chat
- :reload <module>     hot-reload any src/ file
- :unload              kill hub, clean drawings, nil globals

lib/esp.lua
- local esp = import("lib/esp")()
- esp.toggle(bool)     show/hide name esp

undo pattern
- env.undo.push(function() -- cleanup here end)
- env.undo.fire()        called by :unload

dispatcher
- edit src/core/dispatcher.lua map to point PlaceId → script name (no .lua)
- fallback is "universal"

signals (none yet) – reserved for future pub/sub bus
