-- Raphael's Library v1.0.0
--		Last updated: 08/10/12 - 20:38

--[[
 * Changelog v1.0.0
 *
 * - First stable release, project added to GitHub.
 * - Started working on some basic documentation. (Based on http://goo.gl/93Q62 & http://goo.gl/67idS)
 * - Updated num(), itemcount() and table.each().
 * - Fixed small bugs on maround(), file.line() and file.isline().
 * - Added table.merge(), table.sum() and table.average().
 * - Added string.begin() and string.finish().
 * - Added ischannel(), npctalk(), toyesno(), toonoff(), tobool(), get() and set().
--]]

LIBS = LIBS or {}
LIBS.RAPHAEL = '1.0.0'

findcreature = getcreature


--[[
 * Groups thousands digits for readability.
 *
 * Receives a number and returns a equivalent string with its thousands digits
 * separated by the chosen decimal mark. Ex: 12,345,678
 *
 * @since 0.1
 * @updated 1.0.0
 *
 * @param	{number}	n		- The number to be formatted
 * @param	{string}	[mark]	- The decimal mark to be used; defaults to ','
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
 * @since 0.1
 *
 * @param	{number}	secs		- The number of seconds the time represents
 * @param	{string}	[pattern]	- The pattern it sould be parsed on; defaults to the best
 									  pattern to display all info
 * @returns	{string}				- Formatted time string
--]]
function time(secs, pattern)
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
 * @since 0.1
 *
 * @param	{string}	v1	- The first version string
 * @param	{string}	v2	- The second version string
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
 * @since 0.2
 *
 * @param	{string}	execstring	- The string to be executed
 * @returns {?}						- Anything returned by the code ran
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
 * @since 0.3
 *
 * @param	{number}	[l1]	- The starting level; defaults to 0
 * @param	{number}	l2		- The target level
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
 * @returns {number}			- The experience needed
--]]
function exptolevel(lvl)
	return exptolvl(lvl) - exp
end


--[[
 * Returns the amount of items in a specified location.
 *
 * @overrides
 * @since 0.3
 * @updated 1.0.0
 *
 * @param	{number|string|table}	item		- The item(s) name or id.
 * @param	{number|string}			[origin]	- The location to look for; defaults to 'all'
 * @returns {number}							- The amount of items
--]]
function itemcount(item, origin)
	origin = origin or 'all'
	if type(item) ~= 'table' then
		return _itemcount(item, origin)
	else
		local c = 0
		table.each(item, function(v) c = c + _itemcount(v, origin) end, true)
		return c
	end
end


--[[
 * Returns the amount of creatures around you.
 *
 *
 *
 * @overrides
 * @since 0.3
 * @updated 1.0.0
 *
 * @param	{number}		[range]					- The range the creatures need to be around you; defaults to 7
 * @param	{boolean}		[samefloor]				- WConsider creature on the same floor as you; defaults to true
 * @param	{string|table}	[name1], [name2], ...	- Names of the creatures that should be considered; defaults to any
 * @param	{function}		[f]						- A function to validate each creature; must return a boolean
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

function getcreatures(...)
	local fl = 'mpsf'
	local cre

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

function moveitems(item, origin, dest, amount)
	if amount == nil then

	end
end

function ischannel(ch)
	return #getmessages(ch) > 0
end

local trueValues = {'yes', 'on', 1, true}
function toyesno(v)
	return (table.find(trueValues, v) and 'yes') or 'no'
end

function toonoff(v)
	return (table.find(trueValues, v) and 'on') or 'off'
end

function tobool(v)
	return table.find(trueValues, v)
end

local function getfullpath(t, p)
	return p:begin('Settings/'):gsub('/', '\\')
end

function set(p, v)
	setsettings(getfullpath(p), v)
end

function get(p)
	return getsettings(getfullpath(p))
end




--     __  ___      __  __                 __                  _
--    /  |/  /___ _/ /_/ /_     ___  _  __/ /____  ____  _____(_)___  ____
--   / /|_/ / __ `/ __/ __ \   / _ \| |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  / /  / / /_/ / /_/ / / /  /  __/>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /_/  /_/\__,_/\__/_/ /_/   \___/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/
--

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

function string.explode(self, sep) -- By Socket, improved by Hardek.
	local result = {}
	self:gsub('[^'.. sep ..'*]+', function(s) table.insert(result, (string.gsub(s, '^%s*(.-)%s*$', '%1'))) end)
	return result
end

function string.capitalize(self)
	return self:sub(1, 1):upper() .. self:sub(2):lower()
end

function string.capitalizeall(self)
	local r = self:explode(' ')
	for i = 1, #r do
		r[i] = r[i]:capitalize()
	end

	return table.concat(r, ' ')
end

function string.at(self, n)
	return self:sub(n, n)
end

function string.ends(self, substr)
	return self:sub(-#substr) == substr
end

function string.starts(self, substr)
	return self:sub(1, #substr) == substr
end

function string.begin(self, substr)
	if self:starts(substr) then
		return self
	else
		return substr .. self
	end
end

function string.finish(self, substr)
	if self:ends(substr) then
		return self
	else
		return self .. substr
	end
end





--   ______      __    __        ______     __                  _
--  /_  __/___ _/ /_  / /__     / ____/  __/ /____  ____  _____(_)___  ____
--   / / / __ `/ __ \/ / _ \   / __/ | |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  / / / /_/ / /_/ / /  __/  / /____>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /_/  \__,_/_.___/_/\___/  /_____/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/
--

function table.isempty(self)
	return next(self) == nil
end

function table.size(self)
	local i = 0
	for v in pairs(self) do
		i = i + 1
	end

	return i
end

--@updated 1.0.0 added passive
function table.each(self, f, passive)
	passive = passive or false
	if not passive then
		for k, v in pairs(self) do
			self[k] = f(v, k)
		end
	else
		for k, v in pairs(self) do
			f(v, k)
		end
	end
end

function table.lower(self)
	table.each(self, string.lower)
end

function table.upper(self)
	table.each(self, string.upper)
end

function table.id(self)
	table.each(self, itemid)
end

function table.findcreature(self)
	table.each(self, findcreature)
end

function table.filter(self, f)
	for k, v in pairs(self) do
		if not f(v, k) then
			table.remove(self, k)
		end
	end
end

function table.merge(self, v, forceKey)
	local f
	if forceKey then
		f = function(v, k)
				self[k] = v
			end
	else
		f = function(v)
				local rv = v
				table.insert(self, rv)
			end
	end
	table.each(v, f)
end

function table.sum(self)
	local s = 0
	table.each(self, function(v) s = s + v end, true)
	return s
end

function table.average(self)
	return table.sum(self) / #self
end




--     _______ __        __  __                _____
--    / ____(_) /__     / / / /___ _____  ____/ / (_)___  ____ _
--   / /_  / / / _ \   / /_/ / __ `/ __ \/ __  / / / __ \/ __ `/
--  / __/ / / /  __/  / __  / /_/ / / / / /_/ / / / / / / /_/ /
-- /_/   /_/_/\___/  /_/ /_/\__,_/_/ /_/\__,_/_/_/_/ /_/\__, /
--                                                     /____/

file = {}

function file.checkname(filename)
	return filename:begin('files/')
end

function file.exists(filename)
	filename = file.checkname(filename)
	local handler, exists = io.open(filename), false

	if type(handler) ~= 'nil' then
		handler:close()
		return true
	end
	return false
end

function file.content(filename)
	filename = file.checkname(filename)
	if not file.exists(filename) then
		return ''
	end

	local handler = io.open(filename, 'r')
	local content = handler:read('*a')
	handler:close()
	return content
end

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

-- @updated 1.0.0
function file.line(filename, linenum)
	filename = file.checkname(filename)
	if not file.exists(filename) then
		return ''
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

function file.write(filename, content)
	filename = file.checkname(filename)

	local handler = io.open(filename, 'a+')
	handler:write(content)
	handler:close()
end

function file.rewrite(filename, content)
	filename = file.checkname(filename)

	local handler = io.open(filename, 'w+')
	handler:write(content)
	handler:close()
end

function file.clear(filename)
	filename = file.checkname(filename)

	local handler = io.open(filename, 'w+')
	handler:close()
end

function file.writeline(filename, content)
	filename = file.checkname(filename)
	local s = ''
	if file.linescount(filename) > 0 then
		s = '\n'
	end

	file.write(filename, s .. content)
end

-- @updated 1.0.0

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

function file.exec(filename)
	filename = file.checkname(filename)

	return dofile(filename)
end