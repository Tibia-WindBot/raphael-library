dofile('config.lua')
dofile('TLua Engine.lua')


local handler = io.open(config.files.dest, 'w+')
handler:write(TLua.render(config.files.layout, config))
handler:close()

print(config.name .. ' v' .. config.version .. ' succesfully built! (' .. os.clock() * 1000 .. 'ms)')
