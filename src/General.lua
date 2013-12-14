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
 * Gets the creature's name color based on its hppc.
 *
 * @since     0.1.0
 *
 * @param     {number}       hppc           - The creature's hppc
 *
 * @returns   {color}                       - The color at the specified hppc
--]]
function getnamecolor(hppc)
	if hppc == 100 then
		return HPPC_COLOR_LIME_GREEN
	elseif hppc >= 60 then
		return HPPC_COLOR_GREEN
	elseif hppc >= 30 then
		return HPPC_COLOR_YELLOW
	elseif hppc >= 4 then
		return HPPC_COLOR_RED
	else
		return HPPC_COLOR_DARK_RED
	end
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
 * Handles talking to a NPC. Takes care of all waiting times and checks if NPCs
 * channel is open. By default, it uses a waiting method that waits until it
 * sees the the message was actually sent. Optionally, you can opt for the
 * original waitping() solution, passing `normalWait` as true.
 *
 * @since     0.1.0
 *
 * @param     {string...}    messages       - Messages to be said
 * @param     {boolean}      [normalWait]   - If waitping should be used as
 *                                            waiting method; defaults to false
--]]
function npctalk(...)
	local args = {...}

	-- Checks for aditional parameters
	local normalWait = false
	if type(table.last(args)) == 'boolean' then
		normalWait = table.remove(args)
	end

	-- Use specified waiting method
	local waitFunction = waitmessage
	if normalWait then
		waitFunction = function()
			waitping()
			return true
		end
	end

	-- We gotta convert all args to strings because there may be some numbers
	-- in between and those wouldn't be correctly said by the bot.
	table.map(args, tostring)

	local msgSuccess = false

	-- Open NPCs channel if needed
	if not ischannel('NPCs') then
		while not msgSuccess do
			say(args[1])
			msgSuccess = waitFunction($name, args[1], 3000, true, MSG_DEFAULT)
		end

		table.remove(args, 1)
		wait(400, 600)
	end

	for k, v in ipairs(args) do
		msgSuccess = false
		while not msgSuccess do
			say('NPCs', v)
			msgSuccess = waitFunction($name, v, 3000, true, MSG_SENT)
			if not msgSuccess then
				if not ischannel('NPCs') then
					npctalk(select(k, ...))
					return
				end
			end
		end
	end
end

--[[
 * Handles pressing specific keys in the given sentence. It reads the `keys`
 * argument and presses the keys as if a human was writing it. For special
 * keys, make use of brackets. For instance, to press delete, use [DELETE].
 *
 * @since     0.1.0
 *
 * @param     {string}       keys           - Keys to be pressed
--]]
function press(keys)
	keys = keys:upper()

	for i, j, k in string.gmatch(keys .. '[]', '([^%[]-)%[(.-)%]([^%[]-)') do
		for n = 1, #i do
			keyevent(KEYS[i:at(n)])
		end

		if #j then
			keyevent(KEYS[j])
		end

		for n = 1, #k do
			keyevent(KEYS[k:at(n)])
		end
	end
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