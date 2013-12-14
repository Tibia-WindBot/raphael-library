TLua = {
	content = nil,
	data = nil,
	exportedData = nil,
}

function TLua.checkContent()
	if string.sub(TLua.content, -5) == '.tlua' then
		TLua.content = TLua.getFileContent(TLua.content)
	end
end

function TLua.getFileContent(filename)
	local handler = assert(io.open(filename, 'r'))
	local content = handler:read('*all')
	handler:close()

	return content
end

function TLua.render(content, data)
	TLua.content = content
	TLua.data = data or {}

	TLua.checkContent()
	TLua.exportData()

	TLua.replaceCode()
	TLua.replaceVars()
	TLua.replaceFiles()

	return TLua.content
end

function TLua.replaceVars()
	for key, value in pairs(TLua.data) do
		local realValue = ''
		if type(value) == 'number' or type(value) == 'string' or type(value) == 'boolean' then
			realValue = value
		end
		TLua.content = TLua.content:gsub('{{%s-' .. key .. '%s-}}', TLua.escapePattern(realValue))
	end
end

function TLua.replaceCode()
	for placeholder, code in TLua.content:gmatch('({{{(.-)}}})') do
		TLua.content = TLua.content:gsub(TLua.escapePattern(placeholder), TLua.escapePattern(TLua.runCode(code)))
	end
end

function TLua.replaceFiles()
	for placeholder, filename in TLua.content:gmatch('(@include%((.-)%))') do
		TLua.content = TLua.content:gsub(TLua.escapePattern(placeholder), TLua.escapePattern(TLua.getFileContent(filename)))
	end
end

function TLua.runCode(code)
	code = TLua.exportedData .. '\n' .. 'return ' .. code
	local func = loadstring(code)
	return func()
end

function TLua.exportData()
	TLua.exportedData = ''

	if next(TLua.data) ~= nil then
		local keys, values = {}, {}
		for key, value in pairs(TLua.data) do
			table.insert(keys, key)

			if (type(value) == 'number') then
				table.insert(values, tostring(value))
			elseif (type(value) == 'string') then
				table.insert(values, string.format('%q', value))
			end
		end

		TLua.exportedData = 'local ' .. table.concat(keys, ', ') .. ' = ' .. table.concat(values, ', ')
	end
end

-- Taken from https://github.com/lua-nucleo/lua-nucleo
function TLua.escapePattern(content)
	local matches = {
		["^"] = "%^";
		["$"] = "%$";
		["("] = "%(";
		[")"] = "%)";
		["%"] = "%%";
		["."] = "%.";
		["["] = "%[";
		["]"] = "%]";
		["*"] = "%*";
		["+"] = "%+";
		["-"] = "%-";
		["?"] = "%?";
		["\0"] = "%z";
	}

	return (content:gsub(".", matches))
end
