--[[
 * Gets the variable's type. Works for user created classes, using
 * getclasses().
 *
 * @since     0.1.0
 * @overrides
 *
 * @param     {any}          value          - The variable to be checked
 *
 * @returns   {string}                      - The variable's type
--]]
function type(value)
	local luaType = _TYPE(value)

	-- If it's not an object, simply return the actual variable type
	if luaType ~= 'table' then
		return luaType
	end

	return value.__class or luaType
end

--[[
 * Compares version strings.
 *
 * Receives two version strings, compares them and return a boolean indicating
 * whether v1 is equal to or higher than v2.
 *
 * @since     0.1.0
 *
 * @param     {string}       v1             - The version string to be checked
 * @param     {string}       v2             - The version it should be compared
 *                                            with
 *
 * @returns   {boolean}                     - Whether v1 is equal or higher
 *                                            than v2
--]]
function versionhigherorequal(v1, v2)
	local v1, v2 = string.explode(tostring(v1), '%.'), string.explode(tostring(v2), '%.')
	for i = 1, math.max(#v1, #v2) do
		v1[i] = tonumber(v1[i]) or 0
		v2[i] = tonumber(v2[i]) or 0
		if v1[i] < v2[i] then
			return false
		elseif v1[i] > v2[i] then
			return true
		end
	end
	return true
end

--[[
 * Executes a given string and returns its return values.
 *
 * @since     0.1.0
 *
 * @param     {string}       code           - The string to be executed
 *
 * @returns   {any}                         - Anything returned by the code ran
--]]
function exec(code)
        local func = loadstring(code)

        -- Needs pcall to be reenabled
        -- local arg = {pcall(func)}
        -- table.insert(arg, arg[1])
        -- table.remove(arg, 1)
        -- return table.unpack(arg)

        return func()
end

--[[
 * Calculates the total experience at specified level.
 *
 * @since     0.1.0
 *
 * @param     {number}       level          - The starting level
 *
 * @returns   {number}                      - The experience needed
--]]
function expatlvl(level)
	return 50 / 3 * (level ^ 3 - 6 * level ^ 2 + 17 * level - 12)
end

--[[
 * Gets the variable's classes, looking for the __class index on their
 * metatables.
 *
 * @since     0.1.0
 *
 * @param     {any}          value          - The variable to be checked
 *
 * @returns   {string...}                   - The variable's classes
--]]
function getclasses(value)
	local classes = {}

	local meta = getmetatable(value)
	while meta and meta.__index do
		if meta.__index.__class then
			table.insert(classes, meta.__index.__class)
		end

		meta = getmetatable(meta.__index)
	end

	return table.unpack(classes)
end

--[[
 * Gets the total amount of visible gold you're carrying.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - Total amount of gold
--]]
function gold()
	return itemcount('gold coin') +
	       itemcount('platinum coin') * 100 +
	       itemcount('crystal coin') * 10000
end

--[[
 * Gets the total amount of visible flasks you're carrying.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - Total amount of flasks
--]]
function flasks()
	return itemcount('empty potion flask (small)') +
	       itemcount('empty potion flask (medium)') +
	       itemcount('empty potion flask (large)')
end

--[[
 * Helper for the ternary operator that Lua lacks. Returns `expr2` if `expr1`
 * is true, `expr3` otherwise.
 *
 * @since     0.1.0
 *
 * @param     {any}          expr1          - The expression to be evaluated
 * @param     {any}          expr2          - The expression to be returned if
 *                                            `expr1` evaluates to true
 * @param     {any}          expr3          - The expression to be returned if
 *                                            `expr1` evaluates to false
 *
 * @returns   {any}                         - `expr2` or `expr3`
--]]
function tern(expr1, expr2, expr3)
	if expr1 then
		return expr2
	else
		return expr3
	end
end

--[[
 * Returns the maximum capacity for the character current logged on. It may
 * get it wrong if you left rookgard after level 8.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - Maximum capacity
--]]
function maxcap()
	-- There's no way to know max cap if we're not logged in
	if $voc == 0 then
		return -1
	end

	local vocs = {10, 30, 20, 10, 10}
	return vocs[math.log($voc * 4)] * ($level - 8) + 470
end

--[[
 * Returns the amount of seconds the computer's clock is currently offset from
 * UTC timezone.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - UTC offset in seconds
--]]
function utcoffset()
	local now = os.time()
	return os.difftime(
		now,
		os.time(os.date("!*t", now)) - tern(os.date('*t').isdst, 3600, 0)
	)
end

--[[
 * Returns the amount of seconds the computer's clock is currently offset from
 * CET timezone.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - CET offset in seconds
--]]
function cetoffset()
	return utcoffset() - tern(math.abs(os.date('*t').yday - 187) < 46, 7200, 3600)
end

--[[
 * Returns the current time of day, in seconds, on UTC timezone.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - UTC time of day in seconds
--]]
function utctime()
	return tosec(os.date('!%X'))
end

--[[
 * Returns the current time of day, in seconds, on CET timezone.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - CET time of day in seconds
--]]
function cettime()
	return tosec(os.date('!%X')) - tern(math.abs(os.date('*t').yday - 187) < 46, 7200, 3600)
end

--[[
 * Returns the current computers timezone string. Ex: UTC +3
 *
 * @since     0.1.0
 *
 * @returns   {string}                      - Computer's timezone
--]]
function timezone()
	local offset = utcoffset()
	if offset then
		return 'UTC ' .. tern(offset > 0, '+', '-') .. math.abs(offset / 3600)
	end
	return 'UTC'
end

--[[
 * Returns amount of seconds left for the next server save.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - Seconds left to server save
--]]
function sstime()
	return (36000 - cettime()) % 86400
end

--[[
 * Shorthand method for playing a beep.
 *
 * @since     0.1.0
--]]
function beep()
	playsound('monster.wav')
end

--[[
 * Shorthand method for not listing a hotkey.
 *
 * @since     0.1.0
--]]
function dontlist()
	listas('dontlist')
end

--[[
 * Returns all the open containers' objects.
 *
 * @since     0.1.0
 *
 * @return    {array}                       - The containers' objects
--]]
function getopencontainers()
	local conts, c = {}
	for i = 0, 15 do
		c = getcontainer(i)
		if c.isopen then
			table.insert(conts, c)
		end
	end

	return conts
end

--[[
 * Toggles a setting. If it's set to `a`, sets it to `b` and the other way
 * around.
 *
 * @since     0.1.1
 *
 * @param     {string}       setting        - The setting to be toggled
 * @param     {string}       a              - One of the values used on toggle
 * @param     {string}       b              - The other value used on toggle
--]]
function toggle(setting, a, b)
	a, b = a or 'no', b or 'yes'
	set(setting, tern(get(setting) == a, b, a))
end

--[[
 * Converts any variable to a boolean representation.
 *
 * @since     0.1.1
 * @modified  0.1.3
 *
 * @param     {any}          value          - The value to be converted
 * @param     {string}       property       - Whether the conversion should be
 *                                            strict; this means 'no' and 'off'
 *                                            are considered true.
 *
 * @return    {boolean}                     - Boolean representation
--]]
function tobool(value, strict)
	strict = strict or false

	local valType = type(value)

	if valType == 'boolean' then
		return value
	elseif valType == 'nil' then
		return false
	elseif valType == 'userdata' then
		return true
	elseif valType == 'number' then
		return value ~= 0
	elseif valType == 'string' then
		return tobool(#value) and (strict or not (value == 'no' or value == 'off'))
	elseif valType == 'table' then
		return table.size(value) == 0
	end
end

--[[
 * Converts any variable to a numeric representation; that means one or zero.
 *
 * @since     0.1.3
 *
 * @param     {any}          value          - The value to be converted
 * @param     {string}       property       - Whether the conversion should be
 *                                            strict; this means 'no' and 'off'
 *                                            are considered true.
 *
 * @return    {number}                      - Numeric representation
--]]
function toonezero(value, strict)
	return tern(tobool(value, strict), 1, 0)
end

--[[
 * Converts any variable to a yes/no representation.
 *
 * @since     0.1.3
 *
 * @param     {any}          value          - The value to be converted
 * @param     {string}       property       - Whether the conversion should be
 *                                            strict; this means 'no' and 'off'
 *                                            are considered true.
 *
 * @return    {string}                      - Yes/no representation
--]]
function toyesno(value, strict)
	return tern(tobool(value, strict), 'yes', 'no')
end

--[[
 * Converts any variable to a on/off representation.
 *
 * @since     0.1.3
 *
 * @param     {any}          value          - The value to be converted
 * @param     {string}       property       - Whether the conversion should be
 *                                            strict; this means 'no' and 'off'
 *                                            are considered true.
 *
 * @return    {string}                      - On/off representation
--]]
function toonoff(value, strict)
	return tern(tobool(value, strict), 'on', 'off')
end

--[[
 * Verifies that certain requirements, such as libraries and bot version, are
 * met. Throws an error if it doesn't.
 *
 * @since     0.1.3
 *
 * @param     {table}        reqs           - Requirements in a table, in the
 *                                            pattern of {curVer, neededVer,
 *                                            reqName}
--]]
function requires(reqs)
	local failedRequirements = {}

	for _, v in ipairs(reqs) do
		if not versionhigherorequal(v[1], v[2]) then
			table.insert(failedRequirements, v)
		end
	end

	if #failedRequirements > 0 then
		local errorMsg = 'Your current setup does not meet the following ' ..
		                 'minimum requirements:\n'

		for _, v in ipairs(failedRequirements) do
			errorMsg = errorMsg .. '\n' ..
			           '- ' .. v[3] .. ': v' .. v[2]
		end

		printerror(errorMsg)
	end
end