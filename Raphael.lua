-- Raphael's Library v1.1.4
--		Last updated: 01/27/13 - -04:25

--[[
 * Changelog v1.1.4
 *
 * - Renamed functions that overrode native methods and broke backwards compatibility; that
 * 		includes __getmessages(), __getnewmessages() and __getcreatures().
 *
--]]


LIBS = LIBS or {}
LIBS.RAPHAEL = '1.1.4'

findcreature = getcreature
tilewalkable = tileiswalkable
table.unpack = table.unpack or unpack


--     _ ____        __     ______     __                  _
--    (_) __ )____  / /_   / ____/  __/ /____  ____  _____(_)___  ____
--   / / __  / __ \/ __/  / __/ | |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  / / /_/ / /_/ / /_   / /____>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /_/_____/\____/\__/  /_____/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/


--[[
 * Groups thousands digits for readability.
 *
 * Receives a number and returns a equivalent string with its thousands digits
 * separated by the chosen decimal mark. Ex: 12,345,678
 *
 * @since 0.1.0
 * @updated 1.0.0
 *
 * @param	{number}	n		- The number to be formatted
 * @param	{string}	[mark]	- The decimal mark to be used; defaults to ','
 *
 * @returns	{string}			- Formatted number
--]]
function num(n, mark)
	local sign, nl = ''
	n = math.floor(n)
	mark = (mark or ',') .. '%1'

	if n < 0 then
		sign = '-'
		n = math.abs(n)
	end

	nl = (3 - (#tostring(n) % 3)) % 3
	return sign .. (string.rep('0', nl) .. tostring(n)):gsub('(%d%d%d)', mark):sub(nl + 2)
end


--[[
 * Formats a time string for readability.
 *
 * Receives the number of seconds representing the time and parses it into a
 * string according to the pattern passed. Ex: 01:23:45
 *
 * @since 0.1.0
 *
 * @param	{number}	secs		- The number of seconds the time represents
 * @param	{string}	[pattern]	- The pattern it sould be parsed on; defaults to the best
 									  pattern to display all info
 *
 * @returns	{string}				- Formatted time string
--]]
function formattime(secs, pattern)
	local dt = {
		dd = math.floor(secs / (60 * 60 * 24)),		-- Days
		hh = math.floor(secs / (60 * 60)) % 24,		-- Hours
		mm = math.floor(secs / 60) % 60,			-- Minutes
		ss = secs % 60								-- Seconds
	}

	if not pattern then
		if dt.dd > 0 then
			pattern = 'dd:hh:mm:ss'
		elseif dt.hh > 0 then
			pattern = 'hh:mm:ss'
		else
			pattern = 'mm:ss'
		end
	else
		pattern = pattern:lower()
	end

	return pattern:gsub('%l%l', function(s) return math.format(dt[s], '00') end)
end


--[[
 * Compares version strings.
 *
 * Receveives two version strings, compares them and return a boolean
 * indicating whether v2 is equal or higher than v1.
 *
 * @since 0.1.0
 *
 * @param	{string}	v1	- The first version string
 * @param	{string}	v2	- The second version string
 *
 * @returns	{boolean}		- Whether v2 is equal or higher than v1
--]]
function compversions(v1, v2)
	local v1, v2 = string.explode(tostring(v1), '%.'), string.explode(tostring(v2), '%.')
	for i = 1, math.max(#v1, #v2) do
		v1[i] = tonumber(v1[i]) or 0
		v2[i] = tonumber(v2[i]) or 0
		if v2[i] < v1[i] then
			return false
		elseif v2[i] > v1[i] then
			return true
		end
	end
	return true
end


--[[
 * Executes a given string.
 *
 * Executes the code string in protection mode without propagating the errors. Returns any value
 * returned by the executed code and a boolean indicating whether any error was fired.
 *
 * @since 0.2.0
 *
 * @param	{string}	execstring	- The string to be executed
 *
 * @returns {any}						- Anything returned by the code ran
--]]
function exec(execstring)
	local func = loadstring(execstring)
	local arg = {pcall(func)}
	table.insert(arg, arg[1])
	table.remove(arg, 1)
	return table.unpack(arg)
end


--[[
 * Calculates the experience needed from a level to another.
 *
 * NOTE: Do not confuse exptolvl() with exptolevel(). While the former is based on a hypothetical
 * scenario, where you would have just reached the starting level, the latter is based on your
 * character's current experience.
 *
 * @since 0.3.0
 *
 * @param	{number}	[l1]	- The starting level; defaults to 0
 * @param	{number}	l2		- The target level
 *
 * @returns {number}			- The experience needed
--]]
function exptolvl(l1, l2)
	l1 = l1 or level + 1
	if l2 then
		return exptolvl(l2) - exptolvl(l1)
	else
		return 50 / 3 * (l1 ^ 3 - 6 * l1 ^ 2 + 17 * l1 - 12)
	end
end


--[[
 * Calculates the experience your characters needs to achieve specified level.
 *
 * NOTE: Do not confuse exptolvl() with exptolevel(). While the former is based on a hypothetical
 * scenario, where you would have just reached the starting level, the latter is based on your
 * character's current experience.
 *
 * @overrides
 * @since 0.3
 *
 * @param	{number}	[lvl]	- The target level; defaults to level + 1
 *
 * @returns {number}			- The experience needed
--]]
function exptolevel(lvl)
	return exptolvl(lvl) - exp
end


--[[
 * Returns the amount of items in a specified location.
 *
 * @overrides
 * @since 0.3.0
 * @updated 1.1.0
 *
 * @param	{number|string|table}	item		- The item(s) name or id.
 * @param	{number|string}			[origin]	- The location to look for; defaults to 'all'
 *
 * @returns {number}							- The amount of items
--]]
function itemcount(item, origin)
	origin = origin or 'all'
	if type(item) ~= 'table' then
		return _itemcount(item, origin)
	else
		return table.sum(table.each(item, function(v) return _itemcount(v, origin) end))
	end
end


--[[
 * Returns the amount of creatures that meet some specific criteria around you.
 *
 * @overrides
 * @since 0.3.0
 * @updated 1.0.0
 *
 * @param	{number}		[range]					- The range the creatures need to be around you; defaults to 7
 * @param	{boolean}		[samefloor]				- Only consider creatures on the same floor as you; defaults to true
 * @param	{string|table}	[name1], [name2], ...	- Names of the creatures that should be considered; defaults to any
 * @param	{function}		[f]						- A function to validate each creature; must return a boolean
 *
 * @returns {number}								- The amount of creatures
--]]
function maround(...)
	local fl, r = 'mf', 7
	local f

	if type(arg[1]) == 'number' then
		r = table.remove(arg, 1)
	end
	if type(arg[1]) == 'boolean' then
		if table.remove(arg, 1) then
			fl = 'm'
		end
	end
	if type(arg[#arg]) == 'function' then
		f = table.remove(arg)
	end
	if type(arg[1]) == 'table' then
		arg = arg[1]
	end
	table.lower(arg)

	if not f then
		return _maround(r, fl == 'm', table.concat(arg, ";") .. string.rep(';', math.min(#arg, 1)))
	else
		if r then
			f = function(c)
					return c.dist <= r and f(c)
				end
		end
		if #arg > 0 then
			f = function(c)
					return table.find(c.name:lower(), arg) and f(c)
				end
		end
		return #getcreatures(fl, f)
	end
end


--[[
 * Returns the pointers to the creatures that meet the specified criteria.
 *
 * @overrides
 * @since 0.3.0
 * @updated 1.1.4
 *
 * @param	{string}	[filter]	- A string containing the filters to be applied, where 'f' means same floor, 's'
 *									  means on the screen, 'm' means monster and 'p' means player; defaults to 'mpsf'
 * @param	{function}	[f]			- A function to validate each creature; must return a boolean
 *
 * @returns {table}					- The pointers to the creatures
--]]
function __getcreatures(...)
	local fl = 'mpsf'
	local cre = {}

	if type(arg[1]) == 'string' then
		fl = table.remove(arg, 1)
	end

	do
		local tcre = _getcreatures(fl)
		for i = 0, tcre.count - 1 do
			table.insert(cre, tcre[i])
		end
	end

	if type(arg[1]) == 'function' then
		table.filter(cre, arg[1])
	end
	return cre
end


--[[
 * Returns the pointers to the messages sent on specified channel.
 *
 * @overrides
 * @since 1.1.2
 * @updated 1.1.4
 *
 * @param	{string}	[channel]	- Client channel to pull messages from; defaults to all
 *
 * @returns {table}					- The pointers to the messages
--]]
function __getmessages(channel)
	local msgs = {}
	do
		local tmsgs = getmessages(channel)
		for i = 0, tmsgs.count - 1 do
			table.insert(msgs, tmsgs[i])
		end
	end

	return msgs
end


--[[
 * Returns the pointers to the new messages sent on specified channel.
 *
 * @overrides
 * @since 1.1.2
 * @updated 1.1.4
 *
 * @param	{string}	[channel]	- Client channel to pull messages from; defaults to all
 *
 * @returns {table}					- The pointers to the messages
--]]
function __getnewmessages(channel)
	local msgs = {}
	do
		local tmsgs = getnewmessages(channel)
		for i = 0, tmsgs.count - 1 do
			table.insert(msgs, tmsgs[i])
		end
	end

	return msgs
end


local trueValues = {'yes', 'on', 1, true}
--[[
 * Converts a possible boolean value to its 'yes' or 'no' equivalent.
 *
 * @since 1.0.0
 *
 * @param	{any}		val	- The value to be converted
 *
 * @returns {string}		- The equivalent 'yes' or 'no' value
--]]
function toyesno(val)
	return (table.find(trueValues, val) and 'yes') or 'no'
end


--[[
 * Converts a possible boolean value to its 'on' or 'off' equivalent.
 *
 * @since 1.0.0
 *
 * @param	{any}		val	- The value to be converted
 *
 * @returns {string}		- The equivalent 'on' or 'off' value
--]]
function toonoff(val)
	return (table.find(trueValues, val) and 'on') or 'off'
end


--[[
 * Converts a possible boolean value to its 1 or 0 equivalent.
 *
 * @since 1.1.0
 *
 * @param	{any}		val	- The value to be converted
 *
 * @returns {number}		- The equivalent 'on' or 'off' value
--]]
function toonezero(val)
	return (table.find(trueValues, val) and 1) or 0
end


--[[
 * Converts a possible boolean value to its boolean equivalent.
 *
 * @since 1.0.0
 *
 * @param	{any}		val	- The value to be converted
 *
 * @returns {boolean}		- The equivalent boolean value
--]]
function tobool(val)
	return table.find(trueValues, val)
end


--[[
 * Replaces all '/' with '\\' and prepends 'Settings\\' to the beginning of the setting path.
 *
 * @since 1.0.0
 * @updated 1.1.0
 *
 * @param	{string}	path	- The setting path
 *
 * @returns {string}			- The converted path
--]]
local function getfullpath(path)
	return path:gsub('/', '\\'):begin('Settings\\')
end


--[[
 * Simply a helper for setsettings(), which automatically runs the path through getfullpath().
 *
 * @since 1.0.0
 *
 * @param	{string}	path	- The setting path to be set
 * @param	{any}		val		- The value to be set
--]]
function set(path, val)
	setsettings(getfullpath(path), val)
end


--[[
 * Simply a helper for getsettings(), which automatically runs the path through getfullpath().
 *
 * @since 1.0.0
 *
 * @param	{string}	path	- The setting path to be gotten
 *
 * @returns {any}				- The value contained in the setting path
--]]
function get(path)
	return getsettings(getfullpath(path))
end




--     __  ___      __  __                 __                  _
--    /  |/  /___ _/ /_/ /_     ___  _  __/ /____  ____  _____(_)___  ____
--   / /|_/ / __ `/ __/ __ \   / _ \| |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  / /  / / /_/ / /_/ / / /  /  __/>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /_/  /_/\__,_/\__/_/ /_/   \___/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/
--


--[[
 * Formats a number according to a specified pattern.
 *
 * Formats a number according to a specified pattern, in order to keep a specific amount of digits before and after the
 * decimal mark.
 *
 * @since 0.1.0
 *
 * @param	{number}	self	- The number to be formatted
 * @param	{string}	pattern	- The pattern in which the number should be formatted; e.g: '00.00'
 *
 * @returns	{string}			- The formatted number
--]]
function math.format(self, pattern)
	local s, p
	s = string.explode('0' .. tostring(self), '%.')
	p = string.explode('0' .. pattern       , '%.')

	s[1] = s[1]:sub(2) -- Removes the extra zero
	p[1] = p[1]:sub(2) -- Removes the extra zero

	s[1] = ('0'):rep(#p[1] - #s[1]) .. s[1] -- Adds padding 0 before the dot

	if p[2] then -- Adds padding 0 after the dot
		s[2] = s[2] or ''
		s[2] = '.' .. (s[2] .. ('0'):rep(#p[2] - #s[2])):sub(#p[2])
	else
		s[2] = ''
	end

	return s[1] .. s[2]
end







--    _____ __       _                ______     __                  _
--   / ___// /______(_)___  ____ _   / ____/  __/ /____  ____  _____(_)___  ____
--   \__ \/ __/ ___/ / __ \/ __ `/  / __/ | |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  ___/ / /_/ /  / / / / / /_/ /  / /____>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /____/\__/_/  /_/_/ /_/\__, /  /_____/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/
--                       /____/


--[[
 * Splits the string by the specified delimiter.
 *
 * Returns an array of strings, each of which is a substring of self formed by splitting it on boundaries formed by
 * the string delimiter.
 *
 * @since 0.1.0
 *
 * @param	{string}	self		- The string to be split
 * @param	{string}	delimiter	- The string delimiter
 *
 * @returns	{array}					- An array of strings created by splitting the string.
--]]
function string.explode(self, delimiter) -- By Socket, improved by Hardek.
	local result = {}
	self:gsub('[^'.. delimiter ..'*]+', function(s) table.insert(result, (string.gsub(s, '^%s*(.-)%s*$', '%1'))) end)
	return result
end


--[[
 * Capitalizes the first character in a given string.
 *
 * @since 0.1.0
 *
 * @param	{string}	self	- The string to be capitalized
 *
 * @returns {string}			- The capitalized string
--]]
function string.capitalize(self)
	return self:sub(1, 1):upper() .. self:sub(2):lower()
end


--[[
 * Capitalizes the first character of every word in a given string.
 *
 * @since 0.1.0
 * @updated 1.1.0
 *
 * @param	{string}	self	- The string to be capitalized
 *
 * @returns {string}			- The capitalized string
--]]
function string.capitalizeall(self)
	local r = self:explode(' ')
	table.each(r, function(v) return v:capitalize() end)
	return table.concat(r, ' ')
end


--[[
 * Returns the nth character in a given string.
 *
 * @since 0.1.0
 *
 * @param	{string}	self	- The target string
 * @param	{number}	n		- The character's position
 *
 * @returns {string}			- The nth character
--]]
function string.at(self, n)
	return self:sub(n, n)
end


--[[
 * Checks whether a given string ends with a given substring.
 *
 * @since 0.1.0
 *
 * @param	{string}	self	- The target string
 * @param	{string}	substr	- The ending substring
 *
 * @returns {boolean}			- Whether it ends or not with the given substring
--]]
function string.ends(self, substr)
	return self:sub(-#substr) == substr
end


--[[
 * Checks whether a given string starts with a given substring.
 *
 * @since 0.1.0
 * @updated 0.3.0
 *
 * @param	{string}	self	- The target string
 * @param	{string}	substr	- The starting substring
 *
 * @returns {boolean}			- Whether it starts or not with the given substring
--]]
function string.starts(self, substr)
	return self:sub(1, #substr) == substr
end


--[[
 * Forces a given string to start with a given substring.
 *
 * @since 1.0.0
 *
 * @param	{string}	self	- The target string
 * @param	{string}	substr	- The starting substring
 *
 * @returns {string}			- The string starting with the substring
--]]
function string.finish(self, substr)
	if self:ends(substr) then
		return self
	else
		return self .. substr
	end
end


--[[
 * Forces a given string to end with a given substring.
 *
 * @since 1.0.0
 *
 * @param	{string}	self	- The target string
 * @param	{string}	substr	- The starting substring
 *
 * @returns {string}			- The string ending with the substring
--]]
function string.begin(self, substr)
	if self:starts(substr) then
		return self
	else
		return substr .. self
	end
end





--   ______      __    __        ______     __                  _
--  /_  __/___ _/ /_  / /__     / ____/  __/ /____  ____  _____(_)___  ____
--   / / / __ `/ __ \/ / _ \   / __/ | |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  / / / /_/ / /_/ / /  __/  / /____>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /_/  \__,_/_.___/_/\___/  /_____/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/
--


--[[
 * Checks wheter given table is empty, that is, has no elements. This may be needed for tables with non-numeric indexes,
 * where the length operator (#) might not work properly.
 *
 * NOTE: May return incorrect values if the given table contains nil values.
 *
 * @malfunction
 * @since 0.1.0
 *
 * @param	{table}		self	- The target table
 *
 * @returns {boolean}			- Wheter the target table is empty or not
--]]
function table.isempty(self)
	return next(self) == nil
end


--[[
 * Returns the amount of elements present in the table. This may be needed for tables with non-numeric indexes, where
 * the length operator (#) might not work properly.
 *
 * @since 0.1.0
 *
 * @param	{table}		self	- The target table
 *
 * @returns {number}			- The number of elements inside the target table
--]]
function table.size(self)
	local i = 0
	for v in pairs(self) do
		i = i + 1
	end

	return i
end


--[[
 * Runs a routine through every item in the given table. The routine to be ran will receive as arguments, for each item,
 * it's value and correspondet index.
 *
 * @since 0.1.0
 * @updated 1.1.0
 *
 * @param	{table}		self		- The target table
 * @param	{function}	f			- Routine to be ran on each element
 *
 * @returns {table}					- A table with the returning values for each item
--]]
function table.each(self, f)
	local r = {}

	for k, v in pairs(self) do
		r[k] = f(v, k)
	end

	return r
end


--[[
 * Runs a routine through every item in the given table and replace the item with the value returned by it. The routine
 * to be ran will receive as arguments, for each item, it's value and correspondet index.
 *
 * @since 1.1.0
 *
 * @param	{table}		self		- The target table
 * @param	{function}	f			- Routine to be ran on each element
--]]
function table.map(self, f)
	for k, v in pairs(self) do
		self[k] = f(v, k)
	end
end


--[[
 * Transforms all strings in the given table to their lowercase equivalent.
 *
 * @since 0.1.0
 * @updated 1.1.0
 *
 * @param	{table}		self		- The target table
 *
 * @returns {table}					- A table with the equivalent lowercase strings
--]]
function table.lower(self)
	return table.each(self, string.lower)
end


--[[
 * Transforms all strings in the given table to their uppercase equivalent.
 *
 * @since 0.1.0
 * @updated 1.1.0
 *
 * @param	{table}		self		- The target table
 *
 * @returns {table}					- A table with the equivalent uppercase strings
--]]
function table.upper(self)
	return table.each(self, string.upper)
end


--[[
 * Transforms all item names in the table to their equivalent item id.
 *
 * @since 0.1.0
 * @updated 1.1.0
 *
 * @param	{table}		self		- The target table
 *
 * @returns {table}					- A table with the equivalent item ids
--]]
function table.id(self)
	return table.each(self, itemid)
end


--[[
 * Filters the items in the given table, running a routine on each of them and removing those which the routines returns
 * false. The routine to be ran will receive as arguments, for each item, it's value and correspondet index.
 *
 * @since 1.0.0
 * @updated 1.1.0
 *
 * @param	{table}		self		- The target table
 * @param	{function}	f			- Routine to be ran on each element
 * @param	{boolean}	[forceKey]	- Whether to assure the filtered items have the same key they had on the original
 *                             		  array; defaults to false
 *
 * @returns {table}					- A table with the filtered items
--]]
function table.filter(self, f, forceKey)
	local r = {}

	if forceKey then
		for k, v in pairs(self) do
			if f(v, k) then
				r[k] = v
			end
		end
	else
		for k, v in pairs(self) do
			if f(v, k) then
				table.insert(r)
			end
		end
	end

	return r
end


--[[
 * Merges the items of the given tables to a single table.
 *
 * @since 1.0.0
 * @updated 1.1.0
 *
 * @param	{table}		[table1], [table2], ...		- Tables to be merged
 * @param	{boolean}	[forceKey]					- Whether to assure the filtered items have the same key they had on
 *                                 					  the original array; defaults to false
 *
 * @returns {table}									- A table with all items on the given tables
--]]
function table.merge(...)
	local args = {...}
	local r = {}
	local forceKey, f

	if (type(table.last(args)) == 'boolean') then
		forceKey = table.remove(args)
	end

	if forceKey then
		f = function(v, k)
				r[k] = v
			end
	else
		f = function(v)
				local rv = v
				table.insert(r, rv)
			end
	end

	table.each(args,
		function(v)
			table.each(v, f)
		end)

	return r
end


--[[
 * Returns the sum of all items in the given table.
 *
 * @since 1.0.0
 * @updated 1.1.0
 *
 * @param	{table}		self	- The target table
 *
 * @returns {number}			- The sum of all items
--]]
function table.sum(self)
	local s = 0
	table.each(self, function(v) s = s + v end)
	return s
end


--[[
 * Returns the average of all items in the given table.
 *
 * @since 1.0.0
 * @updated 1.1.0
 *
 * @param	{table}		self	- The target table
 *
 * @returns {number}			- The average of all items
--]]
function table.average(self)
	return table.sum(self) / #self
end


--[[
 * Returns the first item of the given table.
 *
 * @since 1.1.0
 *
 * @param	{table}		self	- The target table
 *
 * @returns {any}				- The first item of the given table
--]]
function table.first(self)
	return self[1]
end


--[[
 * Returns the last item of the given table.
 *
 * @since 1.1.0
 *
 * @param	{table}		self	- The target table
 *
 * @returns {any}				- The last item of the given table
--]]
function table.last(self)
	return self[#self]
end


--[[
 * Returns the maximum value of all items in the given table.
 *
 * @since 1.1.0
 *
 * @param	{table}		self	- The target table
 *
 * @returns {number}			- The maximum value of all items
--]]
function table.max(self)
	return math.max(table.unpack(self))
end


--[[
 * Returns the minimum value of all items in the given table.
 *
 * @since 1.1.0
 *
 * @param	{table}		self	- The target table
 *
 * @returns {number}			- The minimum value of all items
--]]
function table.min(self)
	return math.min(table.unpack(self))
end




--     _______ __        __  __                _____
--    / ____(_) /__     / / / /___ _____  ____/ / (_)___  ____ _
--   / /_  / / / _ \   / /_/ / __ `/ __ \/ __  / / / __ \/ __ `/
--  / __/ / / /  __/  / __  / /_/ / / / / /_/ / / / / / / /_/ /
-- /_/   /_/_/\___/  /_/ /_/\__,_/_/ /_/\__,_/_/_/_/ /_/\__, /
--                                                     /____/

file = {}


--[[
 * Used as a helper function to ensure all files are placed inside the files folder.
 *
 * @since 0.2.0
 *
 * @param	{string}	filename	- File name to be checked
 *
 * @returns	{string}				- Checked file name
--]]
function file.checkname(filename)
	return filename:begin('files/')
end


--[[
 * Checks wheter given file exists in disk or not.
 *
 * @since 0.2.0
 *
 * @param	{string}	filename	- File name to be checked
 *
 * @returns	{boolean}				- Whether it exists or not
--]]
function file.exists(filename)
	filename = file.checkname(filename)
	local handler, exists = io.open(filename), false

	if type(handler) ~= 'nil' then
		handler:close()
		return true
	end
	return false
end


--[[
 * Gets all the content of a given file. Returns nil if file doesn't exist.
 *
 * @since 0.2.0
 * @updated 1.1.0
 *
 * @param	{string}	filename	- File name to be read
 *
 * @returns {string}				- File content
--]]
function file.content(filename)
	filename = file.checkname(filename)
	if not file.exists(filename) then
		return nil
	end

	local handler = io.open(filename, 'r')
	local content = handler:read('*a')
	handler:close()
	return content
end


--[[
 * Gets the number of lines in a given file. Returns -1 if file doesn't exist.
 *
 * @since 0.2.0
 * @updated 1.1.0
 *
 * @param	{string}	filename	- File name to be checked
 *
 * @returns {number}				- File lines count
--]]
function file.linescount(filename)
	filename = file.checkname(filename)
	if not file.exists(filename) then
		return -1
	end

	local l = 0
	for line in io.lines(filename) do
		l = l + 1
	end

	return l
end


--[[
 * Gets the content of the nth file line. Returns nil if file doesn't exist.
 *
 * @since 0.2.0
 * @updated 1.1.0
 *
 * @param	{string}	filename	- File name to be read
 * @param	{number}	linenum		- Line number
 *
 * @returns {string}				- Line content
--]]
function file.line(filename, linenum)
	filename = file.checkname(filename)
	if not file.exists(filename) then
		return nil
	end

	local l, linev = 0, ''
	for line in io.lines(filename) do
		l = l + 1
		if l == linenum then
			linev = line
			break
		end
	end

	return linev
end


--[[
 * Appends content to the end of given file. If the file does not exist, it's created.
 *
 * @since 0.2.0
 *
 * @param	{string}	filename	- File name to be written on
 * @param	{string}	content		- Content to be appended
--]]
function file.write(filename, content)
	filename = file.checkname(filename)

	local handler = io.open(filename, 'a+')
	handler:write(content)
	handler:close()
end


--[[
 * Write content to the given file, erasing any previous content. If the file does not exist, it's created.
 *
 * @since 0.2.0
 *
 * @param	{string}	filename	- File name to be written on
 * @param	{string}	content		- Content to be written
--]]
function file.rewrite(filename, content)
	filename = file.checkname(filename)

	local handler = io.open(filename, 'w+')
	handler:write(content)
	handler:close()
end


--[[
 * Clears all the content of the given file. If the file does not exist, it's created. Useful to create new, empty
 * files.
 *
 * @since 0.2.0
 *
 * @param	{string}	filename	- File name to be cleared
--]]
function file.clear(filename)
	filename = file.checkname(filename)

	local handler = io.open(filename, 'w+')
	handler:close()
end


--[[
 * Appends content to the end of given file, on a new line. If the file does not exist, it's created.
 *
 * @since 0.2.0
 *
 * @param	{string}	filename	- File name to be written on
 * @param	{string}	content		- Content to be appended
--]]
function file.writeline(filename, content)
	filename = file.checkname(filename)
	local s = ''
	if file.linescount(filename) > 0 then
		s = '\n'
	end

	file.write(filename, s .. content)
end


--[[
 * Checks whether the any file line matches given content. Returns false if it can't be found.
 *
 * @since 0.2.0
 * @updated 1.0.0
 *
 * @param	{string}	filename	- File name to be checked
 * @param	{string}	content		- Content to be matched against
 *
 * @returns {number}				- Matching line number
--]]
function file.isline(filename, content)
	filename = file.checkname(filename)
	local l = 0

	if file.exists(filename) then
		for line in io.lines(filename) do
			l = l + 1
			if line == content then
				return l
			end
		end
	end
	return false
end


--[[
 * Executes the content of given file.
 *
 * @since 0.2.0
 * @updated 1.1.0
 *
 * @param	{any}	filename	- File name to be executed
--]]
function file.exec(filename)
	filename = file.checkname(filename)

	if file.exists(filename) then
		return dofile(filename)
	end
	return nil
end