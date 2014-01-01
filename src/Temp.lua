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
		local type = type(j)
		if type == 'string' then
			ret = ret..'"'..j..'", '..separator
		elseif type == 'number' then
			ret = ret..j..', '..separator
		elseif type == 'boolean' then
			ret = ret..tostring(j)..', '..separator
		elseif type == 'table' then
			ret = ret..table.stringformat(j)..', '..separator
		elseif type == 'userdata' then
			ret = ret..userdatastringformat(j)..', '..separator
		end
	end
	if count == 0 then
		for i,j in pairs(self) do
			local type = type(j)
			if type == 'string' then
				ret = ret..i..' = "'..j..'", '..separator
			elseif type == 'number' then
				ret = ret..i..' = '..j..', '..separator
			elseif type == 'boolean' then
				ret = ret..i..' = '..tostring(j)..', '..separator
			elseif type == 'table' then
				ret = ret..i..' = '..table.stringformat(j)..', '..separator
			elseif type == 'userdata' then
				ret = ret..i..' = '..userdatastringformat(j)..', '..separator
			end
		end
	end
	return ret:sub(1,#ret-2)..'}'
end