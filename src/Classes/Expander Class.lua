Expander = { __class = 'Expander' }
ExpanderMT = { __index = Expander }

function Expander:new(filter, expander)
	local newObj = {
		filter = filter,
		expander = expander
	}

	setmetatable(newObj, ExpanderMT)
	return newObj
end

function Expander:makeFilter(objType)
	return function(v)
		return type(v) == objType
	end
end

function Expander:makeExpander(...)
	local props = {...}
	return function(v)
		local vals = {}
		for _, vv in ipairs(props) do
			table.insert(vals, getvalue(v[vv]))
		end

		return table.unpack(vals)
	end
end

function Expander:expand(...)
	local args = {...}

	for k, v in ipairs(args) do
		if self.filter(v) then
			args[k] = {self.expander(v)}
		end
	end

	table.flatten(args)
	return table.unpack()
end