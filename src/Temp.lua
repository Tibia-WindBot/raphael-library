-- Temporary fix for Lucas Terra's Library's color function.
-- It needs to round the color values, else it gets messed up.
_COLOR = _COLOR or color
function color(...)
	local args = {...}
	if type(args[1]) ~= 'string' then
		table.map(args, math.round)
	end

	return _COLOR(table.unpack(args))
end