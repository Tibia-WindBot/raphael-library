-- Temporary fix for Lucas' table.stringformat
-- Now handles userdatas and booleans correctly
function table.stringformat(self, tablename, separator)
	if type(self) ~= 'table' then
		return ''
	end
	separator = separator or ''
	tablename = tablename or ''
	local ret
	if tablename == '' then
		ret = '{'
	else
		ret = tablename..' = {'
	end
	local count = 0
	for i,j in ipairs(self) do
		count = count+1
		local valType = type(j)
		if valType == 'string' then
			ret = ret..'"'..j..'", '..separator
		elseif valType == 'number' then
			ret = ret..j..', '..separator
		elseif valType == 'boolean' then
			ret = ret..tostring(j)..', '..separator
		elseif valType == 'nil' then
			ret = ret..'nil, '..separator
		elseif valType == 'table' then
			ret = ret..table.stringformat(j)..', '..separator
		elseif valType == 'userdata' then
			ret = ret..userdatastringformat(j)..', '..separator
		end
	end
	if count == 0 then
		for i,j in pairs(self) do
			local valType = type(j)
			if valType == 'string' then
				ret = ret..i..' = "'..j..'", '..separator
			elseif valType == 'number' then
				ret = ret..i..' = '..j..', '..separator
			elseif valType == 'boolean' then
				ret = ret..i..' = '..tostring(j)..', '..separator
			elseif valType == 'nil' then
				ret = ret..i..' = nil, '..separator
			elseif valType == 'table' then
				ret = ret..i..' = '..table.stringformat(j)..', '..separator
			elseif valType == 'userdata' then
				ret = ret..i..' = '..userdatastringformat(j)..', '..separator
			end
		end
	end
	return ret:sub(1,#ret-2)..'}'
end