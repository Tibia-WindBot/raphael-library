dofile('TLua Engine.lua')

local version = arg[1]
local handler = io.open('Raphael.lua', 'w+')
handler:write(TLua.render('Layout.tlua', { version = version }))
handler:close()

print('Raphael\'s Library v' .. version .. ' succesfully built! (' .. os.clock() * 1000 .. 'ms)')
