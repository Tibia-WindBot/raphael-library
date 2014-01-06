-- Raphael's Library v1.0.2
-- Last Updated: 06/01/2014 - 23:13 UTC
-- Released for WindBot v1.2.2

RAPHAEL_LIB = '1.0.2'
print("Raphael's Library Version: " .. RAPHAEL_LIB)


--[[
 * Changelog v1.0.2
 *
 * - Fixed sstime().
 *
--]]


-- Setting a good random seed
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)) * (os.clock()) * $idlerecvtime / $timems + ($connected and 1 or 0))

-- Make sure table.unpack and unpack are both mapped to the same function
table.unpack = table.unpack or unpack
unpack = unpack or table.unpack

-- Used by userdatastringformat
GLOBAL_USERDATA = nil

-- Some aliases
set = setsetting
get = getsetting

-- Handle overwrriten functions
_TOSTRING   = _TOSTRING   or tostring
_TYPE       = _TYPE       or type
math._CEIL  = math._CEIL  or math.ceil
math._FLOOR = math._FLOOR or math.floor

-- Vocation IDs used by $voc
VOC_NONE        = 0
VOC_UNKNOWN     = 0
VOC_NO_VOCATION = 1
VOC_KNIGHT      = 2
VOC_PALADIN     = 4
VOC_SORCERER    = 8
VOC_DRUID       = 16


-- Some useful regexes
REGEX_DMG_TAKEN     = '^You lose (%d+) (%l+) due to an attack by ?a?n? (.-)%.$'
REGEX_DMG_DEALT     = '^A?n? (.+) loses (%d+) (%l+) due to your attack%.$'
REGEX_HEAL_RECEIVED = '^You were healed by (.+) for (%d+) hitpoints%.$'
REGEX_HEAL_SELF     = '^(.+) healed (%l%l%l%l?)self for (%d+) hitpoints%.$'
REGEX_ADVANCE_LVL   = '^You advanced from Level (%d+) to Level (%d+)%.$'
REGEX_ADVANCE_SKILL = '^You advanced to (.-) level (%d+)%.$'
REGEX_LOOT          = '^Loot of ?a?n? (.-): (.+)$'
REGEX_ITEM_CHARGES  = '^You see an? (.-) %(?.- that has (%d+) charges? left%.'
REGEX_ITEM_DURATION = '^You see an? (.-) that will expire in (.-)%.'
REGEX_PLAYER_BASIC  = '^You see (.-) %(Level (%d+)%)%. (%a+) is an? (.-)%.'
REGEX_PLAYER_FULL   = REGEX_PLAYER_BASIC .. ' %u%l%l? is (.-) of the (.+), which has (%d+) members, (%d+) of them online%.$'
REGEX_SERVER_SAVE   = '^Server is saving game in (%d+) minutes. Please .+%.$'
REGEX_SPA_COORDS    = '^x:(%d+), y:(%d+), z:(%d+)$'
REGEX_SPA_SIZE      = '^(%d+) x (%d+)$'


-- Custom Types properties
CUSTOM_TYPE = {
	CREATURE     = {'name', 'id', 'hppc', 'posx', 'posy', 'posz', 'dir', 'speed', 'iswalking', 'outfit', 'headcolor', 'chestcolor', 'legscolor', 'feetcolor', 'addon', 'mount', 'lightintensity', 'lightcolor', 'lastattacked', 'walkblock', 'skull', 'party', 'warbanner', 'updated', 'aggressortype', 'isshootable', 'isreachable', 'dist', 'ignored', 'ismonster', 'isplayer', 'isnpc', 'issummon', 'isownsummon', 'hpcolor'},
	ITEM         = {'id', 'count', 'special'},
	CONTAINER    = {'name', 'itemid', 'itemcount', 'maxcount', 'isopen', 'ispage', 'hashigher'},
	TILE         = {'itemcount'},
	MESSAGE      = {'content', 'level', 'sender', 'type'},
	PROJECTILE   = {'type', 'fromx', 'fromy', 'tox', 'toy', 'time'},
	EFFECT       = {'type', 'posx', 'posy', 'time'},
	ANIMTEXT     = {'type', 'content', 'posx', 'posy', 'time'},
	RECT         = {'left', 'top', 'bottom', 'right', 'width', 'height', 'centerx', 'centery'},
	POINT        = {'x', 'y'},
	ITEMDATA     = {'name', 'id', 'sellprice', 'buyprice', 'weight', 'isbank', 'isclip', 'isbottom', 'istop', 'iscontainer', 'iscumulative', 'isforceuse', 'ismultiuse', 'iswrite', 'iswriteonce', 'isliquidcontainer', 'isliquidpool', 'isunpass', 'isunmove', 'isunsight', 'isavoid', 'isnomovementanimation', 'istake', 'ishang', 'ishooksouth', 'ishookeast', 'isrotate', 'islight', 'isdonthide', 'istranslucent', 'isfloorchange', 'isshift', 'isheight', 'islyingobject', 'isanimatealways', 'isautomap', 'islenshelp', 'isfullbank', 'isignorelook', 'isclothes', 'ismarket', 'ismount', 'isdefaultaction', 'isusable', 'ignoreextradata', 'enchantable', 'destructible', 'hasextradata', 'height', 'sizeinpixels', 'layers', 'patternx', 'patterny', 'patterndepth', 'phase', 'walkspeed', 'textlimit', 'lightradius', 'lightcolor', 'shiftx', 'shifty', 'walkheight', 'automapcolor', 'lenshelp', 'defaultaction', 'clothslot', 'marketcategory', 'markettradeas', 'marketshowas', 'marketrestrictprofession', 'marketrestrictlevel', 'durationtotalinmsecs', 'specialeffect', 'specialeffectgain', 'category', 'attack', 'attackmod', 'hitpercentmod', 'defense', 'defensemod', 'armor', 'holyresistmod', 'deathresistmod', 'earthresistmod', 'fireresistmod', 'iceresistmod', 'energyresistmod', 'physicalresistmod', 'lifedrainresistmod', 'manadrainresistmod', 'itemlossmod', 'mindmg', 'maxdmg', 'dmgtype', 'range', 'mana'},
	SUPPLYDATA   = {'name', 'id', 'weight', 'buyprice', 'leaveat', 'count', 'rule', 'rulevalue', 'destination', 'category', 'uptocount', 'downtocap', 'amountbought', 'amounttobuy', 'amountused'},
	LOOTINGDATA  = {'name' ,'id' ,'weight' ,'sellprice' ,'count' ,'action' ,'alert' ,'condition' ,'conditionvalue' ,'destination' ,'category' ,'amountlooted' ,'haslessthan' ,'caphigherthan'},
	VIP          = {'name', 'id', 'icon', 'isonline', 'notify'},
	MOUSEINFO    = {'x', 'y', 'z', 'id', 'count'},
	DEATHTIMER   = {'timeofdeath', 'target', 'killer', 'time'},
	PLAYERINFO   = {'name', 'guild', 'voc', 'vocation', 'vocshort', 'priority', 'status', 'time', 'level', 'comment'},
	NAVPING      = {'time', 'color', 'glowcolor', 'posx', 'posy', 'posz'},
	NAVTARGET    = {'name', 'posx', 'posy', 'posz', 'time', 'color', 'glowcolor', 'isleader', 'isfriend', 'isenemy', 'isneutral', 'team', 'teamname', 'creature', 'realname', 'id', 'mp', 'maxmp', 'voc', 'icon'}
}


-- Key codes
-- http://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
local KEYS = {
	MOUSELEFT   = 0x01,
	MOUSERIGHT  = 0x02,
	MOUSEMIDDLE = 0x04,
	BACKSPACE   = 0x08,
	TAB         = 0x09,
	CLEAR       = 0x0C,
	ENTER       = 0x0D,
	SHIFT       = 0x10,
	CTRL        = 0x11,
	ALT         = 0x12,
	PAUSE       = 0x13,
	CAPSLOCK    = 0x14,
	ESC         = 0x1B,
	SPACE       = 0x20,
	PAGEUP      = 0x21,
	PAGEDOWN    = 0x22,
	END         = 0x25,
	HOME        = 0x24,
	LEFTARROW   = 0x25,
	UPARROW     = 0x26,
	RIGHTARROW  = 0x27,
	DOWNARROW   = 0x28,
	SELECT      = 0x29,
	PRINT       = 0x2A,
	EXECUTE     = 0x2B,
	PRINTSCREEN = 0x2C,
	INSERT      = 0x2D,
	DELETE      = 0x2E,
	HELP        = 0x2F,

	['0']       = 0x30,
	['1']       = 0x31,
	['2']       = 0x32,
	['3']       = 0x33,
	['4']       = 0x34,
	['5']       = 0x35,
	['6']       = 0x36,
	['7']       = 0x37,
	['8']       = 0x38,
	['9']       = 0x39,

	A           = 0x41,
	B           = 0x42,
	C           = 0x43,
	D           = 0x44,
	E           = 0x45,
	F           = 0x46,
	G           = 0x47,
	H           = 0x48,
	I           = 0x49,
	J           = 0x4A,
	K           = 0x4B,
	L           = 0x4C,
	M           = 0x4D,
	N           = 0x4E,
	O           = 0x4F,
	P           = 0x50,
	Q           = 0x51,
	R           = 0x52,
	S           = 0x53,
	T           = 0x54,
	U           = 0x55,
	V           = 0x56,
	W           = 0x57,
	x           = 0x58,
	Y           = 0x59,
	Z           = 0x5A,

	SLEEP       = 0x5F,
	NUM0        = 0x60,
	NUM1        = 0x61,
	NUM2        = 0x62,
	NUM3        = 0x63,
	NUM4        = 0x64,
	NUM5        = 0x65,
	NUM6        = 0x66,
	NUM7        = 0x67,
	NUM8        = 0x68,
	NUM9        = 0x69,
	MULTIPLY    = 0x6A,
	ADD         = 0x6B,
	SEPARATOR   = 0x6C,
	SUBTRACT    = 0x6D,
	DECIMAL     = 0x6E,
	DIVIDE      = 0x6F,

	F1          = 0x70,
	F2          = 0x71,
	F3          = 0x72,
	F4          = 0x73,
	F5          = 0x74,
	F6          = 0x75,
	F7          = 0x76,
	F8          = 0x77,
	F9          = 0x78,
	F10         = 0x89,
	F11         = 0x7A,
	F12         = 0x7B,
	F13         = 0x7C,
	F14         = 0x7D,
	F15         = 0x7E,
	F16         = 0x7F,
	F17         = 0x80,
	F18         = 0x81,
	F19         = 0x82,
	F20         = 0x83,
	F21         = 0x84,
	F22         = 0x85,
	F23         = 0x86,
	F24         = 0x87,

	NUMLOCK     = 0x90,
	SCROLLLOCK  = 0x91,
	COMMA       = 0xBC,
	HIFFEN      = 0xBD,
	DOT         = 0xBE,
	BAR         = 0xBF,
	SINGLEQUOTE = 0xD3
}




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
 * @modified  1.0.2
 *
 * @returns   {number}                      - CET time of day in seconds
--]]
function cettime()
	return tosec(os.date('!%X')) + tern(math.abs(os.date('*t').yday - 187) < 46, 7200, 3600)
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

--[[
 * Converts a userdata into a string reprensentation.
 *
 * @since     0.1.3
 *
 * @param     {userdata}     userdata       - The userdata to be converted
 *
 * @returns   {string}                      - The String reprensentation
--]]
function userdatastringformat(userdata)
	local obj = {}
	local props = CUSTOM_TYPE[userdata.objtype:upper()]
	GLOBAL_USERDATA = userdata

	for _, v in ipairs(props) do
		-- Very, very dirty hack.
		obj[v] = exec('return GLOBAL_USERDATA.' .. v)
	end

	if userdata.objtype == 'tile' or userdata.objtype == 'container' then
		obj.item = {}

		for i = 1, userdata.itemcount do
			table.insert(obj.item, userdata.item[i])
		end
	end

	return table.stringformat(obj)
end

--[[
 * Converts any value into a string. Handles tables and userdatas specially.
 *
 * @since     0.1.3
 * @overrides
 *
 * @param     {any}          value          - The variable to be converted
 *
 * @returns   {string}                      - The converted value
--]]
function tostring(value)
	if type(value) == 'table' then
		return table.stringformat(value)
	elseif type(value) == 'userdata' then
		return userdatastringformat(value)
	else
		return _TOSTRING(value)
	end
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




--    _____ __       _                ______     __                  _
--   / ___// /______(_)___  ____ _   / ____/  __/ /____  ____  _____(_)___  ____
--   \__ \/ __/ ___/ / __ \/ __ `/  / __/ | |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  ___/ / /_/ /  / / / / / /_/ /  / /____>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /____/\__/_/  /_/_/ /_/\__, /  /_____/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/
--

--[[
 * Splits the string by the specified delimiter.
 *
 * Returns an array of strings, each of which is a substring of self formed by
 * splitting it on boundaries formed by the string delimiter.
 *
 * @since     0.1.0
 *
 * @param     {string}       self           - The string to be split
 * @param     {string}       delimiter      - The string delimiter
 *
 * @returns   {array}                       - An array of strings created by
 *                                            splitting the string.
--]]
function string.explode(self, delimiter)
	local result = {}
	self:gsub('[^'.. delimiter ..'*]+', function(s) table.insert(result, (string.gsub(s, '^%s*(.-)%s*$', '%1'))) end)
	return result
end

--[[
 * Returns the nth character in a given string.
 *
 * @since     0.1.0
 *
 * @param     {string}       self           - The target string
 * @param     {number}       n              - The character's position
 *
 * @returns   {string}                      - The nth character
--]]
function string.at(self, n)
	return self:sub(n, n)
end

--[[
 * Capitalizes the first character in a given string.
 *
 * @since     0.1.0
 *
 * @param     {string}       self           - The string to be capitalized
 *
 * @returns   {string}                      - The capitalized string
--]]
function string.capitalize(self) -- Working
	return self:at(1):upper() .. self:sub(2):lower()
end

--[[
 * Capitalizes the first character of every word in a given string.
 *
 * @since     0.1.0
 *
 * @param     {string}       self           - The string to be capitalized
 *
 * @returns   {string}                      - The capitalized string
--]]
function string.capitalizeall(self) -- Working
	local t = string.explode(self, ' ')
	table.map(t, string.capitalize)
	return table.concat(t, ' ')
end

--[[
 * Makes sure the given string fits in the given size. If set, adds `trailing`
 * to end of it. If `trueSize` is set to false, the comparison is made using
 * the string length; if it's set to true, the comparison is made using the
 * actual string width, in pixels, gathered by using `measurestring`.
 *
 * @since     0.1.1
 *
 * @param     {string}       self           - The target string
 * @param     {number}       size           - The maximum size
 * @param     {string}       [trailing]     - The trailing string
 * @param     {boolean}      [trueSize]     - Whether the comparison should be
 *                                          - made using real pixel measures.
 *
 * @returns   {string}                      - The final string
--]]
function string.fit(self, size, trailing, trueSize)
	trailing = trailing or '...'

	if size <= 0 then
		return ''
	end

	-- Use the actual pixels measurement if required
	local sizeFunction = string.len
	if trueSize then
		sizeFunction = measurestring
	end

	if sizeFunction(self) <= size then
		return self
	elseif not trueSize then
		return self:sub(0, size - #trailing) .. trailing
	end

	-- Assuming the order of the letters doesn't matter, we'll just append the
	-- trailing text to the beginning, so we don't have to worry about it when
	-- cutting the string for measurements later
	local trailedText = trailing .. self

	-- Helper function
	local function attempt(n)
		return n > 0 and sizeFunction(trailedText:sub(0, n)) <= size
	end

	local ratio = size / sizeFunction(trailedText)
	local suggestedSize = math.round(#trailedText * ratio)
	local firstAttempt = attempt(suggestedSize)

	-- If the first attempt failed, we should start decrementing; if it was
	-- successful, we should start incrementing
	local upDown = tern(firstAttempt, 1, -1)

	-- Keep attempting until we know the result is different; this will mean
	-- that we just reached the turning point, so we can know we have the best
	-- solution for our problem, or the longest string that fits the required
	-- size
	repeat
		suggestedSize = suggestedSize + upDown
	until suggestedSize <= 0 or attempt(suggestedSize) ~= firstAttempt

	if suggestedSize > 0 then
		return self:sub(0, suggestedSize - tern(firstAttempt, 1, 0) - #trailing ) .. trailing
	else
		return ''
	end
end

--[[
 * Checks whether a given string starts with a given substring.
 *
 * @since     0.1.3
 *
 * @param     {string}       self           - The target string
 * @param     {string}       substr         - The starting substring
 *
 * @returns   {boolean}                     - Whether it starts or not with the
 *                                            given substring
--]]
function string.starts(self, substr)
	return self:sub(1, #substr) == substr
end

--[[
 * Checks whether a given string ends with a given substring.
 *
 * @since     0.1.3
 *
 * @param     {string}       self           - The target string
 * @param     {string}       substr         - The ending substring
 *
 * @returns   {boolean}                     - Whether it ends or not with the
 *                                            given substring
--]]
function string.ends(self, substr)
	return self:sub(-#substr) == substr
end

--[[
 * Forces a given string to begin with a given substring.
 *
 * @since     0.1.3
 *
 * @param     {string}       self           - The target string
 * @param     {string}       substr         - The starting substring
 *
 * @returns   {boolean}                     - The string starting with the
 *                                            substring
--]]
function string.begin(self, substr)
	return tern(self:starts(substr), self, substr .. self)
end


--[[
 * Forces a given string to end with a given substring.
 *
 * @since     0.1.3
 *
 * @param     {string}       self           - The target string
 * @param     {string}       substr         - The ending substring
 *
 * @returns   {boolean}                     - The string ending with the
 *                                            substring
--]]
function string.finish(self, substr)
	return tern(self:ends(substr), self, self .. substr)
end




--     __  ___      __  __                 __                  _
--    /  |/  /___ _/ /_/ /_     ___  _  __/ /____  ____  _____(_)___  ____
--   / /|_/ / __ `/ __/ __ \   / _ \| |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  / /  / / /_/ / /_/ / / /  /  __/>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /_/  /_/\__,_/\__/_/ /_/   \___/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/
--

--[[
 * Rounds to the nearest multiple of mult. If it's exactly between two
 * multiples, rounds up.
 *
 * @since     0.1.0
 * @modified  0.1.1
 *
 * @param     {number}       self           - The number to be rounded
 * @param     {number}       mult           - The multiple base; defaults to 1
 *
 * @returns   {number}                      - The rounded number
--]]
function math.round(self, mult)
	div = div or 1

	if self % div >= 0.5 * div then
		return math.ceil(self, mult)
	else
		return math.floor(self, mult)
	end
end

--[[
 * Rounds up to the nearest multiple of mult.
 *
 * @since     0.1.0
 * @overrides
 *
 * @param     {number}       self           - The number to be rounded
 * @param     {number}       mult           - The multiple base; defaults to 1
 *
 * @returns   {number}                      - The rounded number
--]]
function math.ceil(self, mult)
	mult = mult or 1

	return math._CEIL(self / mult) * mult
end

--[[
 * Rounds down to the nearest multiple of mult.
 *
 * @since     0.1.0
 * @overrides
 *
 * @param     {number}       self           - The number to be rounded
 * @param     {number}       mult           - The multiple base; defaults to 1
 *
 * @returns   {number}                      - The rounded number
--]]
function math.floor(self, mult)
	mult = mult or 1

	return math._FLOOR(self / mult) * mult
end




--   ______      __    __        ______     __                  _
--  /_  __/___ _/ /_  / /__     / ____/  __/ /____  ____  _____(_)___  ____
--   / / / __ `/ __ \/ / _ \   / __/ | |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  / / / /_/ / /_/ / /  __/  / /____>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /_/  \__,_/_.___/_/\___/  /_____/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/
--

--[[
 * Checks wheter given table is empty, that is, has no elements. This may be
 * needed for tables with non-numeric indexes, where the length operator (#)
 * might not work properly.
 *
 * NOTE: May return incorrect values if the given table contains nil values.
 *
 * @since     0.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {boolean}                     - Whether the target table is empty
--]]
function table.isempty(self)
	if #self ~= 0 or next(self) ~= nil then
		return false
	else
		for k, v in pairs(self) do
			return false
		end
	end
	return true
end

--[[
 * Returns the amount of elements present in the table. This may be needed for
 * tables with non-numeric indexes, where the length operator (#) might not
 * work properly.
 *
 * @since     0.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {number}                      - The number of elements inside the
 *                                            target table
--]]
function table.size(self)
	local i = 0

	for v in pairs(self) do
		i = i + 1
	end

	return i
end

--[[
 * Runs a routine through every item in the given table. The routine to be ran
 * will receive as arguments, for each item, it's value and correspondet index.
 *
 * @since     0.1.0
 *
 * @param     {table}        self           - The target table
 * @param     {function}     f              - Routine to be ran on each element
 *
 * @returns   {table}                       - A table with the returning values
 *                                            for each item
--]]
function table.each(self, f)
	local r = {}

	for k, v in pairs(self) do
		r[k] = f(v, k)
	end

	return r
end

--[[
 * Runs a routine through every item in the given table and replace the item
 * with the value returned by it. The routine to be ran will receive as
 * arguments, for each item, it's value and correspondet index.
 *
 * @since     0.1.0
 *
 * @param     {table}        self           - The target table
 * @param     {function}     f              - Routine to be ran on each element
--]]
function table.map(self, f)
		for k, v in pairs(self) do
				self[k] = f(v, k)
		end
end

--[[
 * Returns the first item of the given table.
 *
 * @since     0.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {any}                         - The first item of the given table
--]]
function table.first(self)
	return self[1]
end

--[[
 * Returns the last item of the given table.
 *
 * @since     0.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {any}                         - The last item of the given table
--]]
function table.last(self)
	return self[#self]
end




--     _______ __        __  __                _____
--    / ____(_) /__     / / / /___ _____  ____/ / (_)___  ____ _
--   / /_  / / / _ \   / /_/ / __ `/ __ \/ __  / / / __ \/ __ `/
--  / __/ / / /  __/  / __  / /_/ / / / / /_/ / / / / / / /_/ /
-- /_/   /_/_/\___/  /_/ /_/\__,_/_/ /_/\__,_/_/_/_/ /_/\__, /
--                                                     /____/

file = {}

--[[
 * Checks wheter given file exists in disk or not.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be checked
 *
 * @returns   {boolean}                     - Whether it exists or not
--]]
function file.exists(filename)
	local handler = io.open(filename)

	if type(handler) ~= 'nil' then
		handler:close()
		return true
	end
	return false
end

--[[
 * Gets all the content of a given file. Returns nil if file doesn't exist.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be read
 *
 * @returns   {string}                      - File content
--]]
function file.content(filename)
	if not file.exists(filename) then
		return nil
	end

	local handler = io.open(filename, 'r')
	local content = handler:read('*all')
	handler:close()
	return content
end

--[[
 * Gets the number of lines in a given file. Returns -1 if file doesn't exist.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be checked
 *
 * @returns   {number}                      - File lines count
--]]
function file.linescount(filename)
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
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be read
 * @param     {number}       linenum        - Line number
 *
 * @returns   {string}                      - Line content
--]]
function file.line(filename, linenum)
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
 * Appends content to the end of given file. If the file does not exist, it's
 * created.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be written on
 * @param     {string}       content        - Content to be appended
--]]
function file.write(filename, content)
	local handler = io.open(filename, 'a+')
	handler:write(content)
	handler:close()
end

--[[
 * Write content to the given file, erasing any previous content. If the file
 * does not exist, it's created.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be written on
 * @param     {string}       content        - Content to be written
--]]
function file.rewrite(filename, content)
	local handler = io.open(filename, 'w+')
	handler:write(content)
	handler:close()
end

--[[
 * Clears all the content of the given file. If the file does not exist, it's
 * created. Useful to create new, empty files.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be cleared
--]]
function file.clear(filename)
	local handler = io.open(filename, 'w+')
	handler:close()
end

--[[
 * Appends content to the end of given file, on a new line. If the file does
 * not exist, it's created.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be written on
 * @param     {string}       content        - Content to be appended
--]]
function file.writeline(filename, content)
	local s = ''
	if file.linescount(filename) > 0 then
		s = '\n'
	end

	file.write(filename, s .. content)
end

--[[
 * Checks whether the any file line matches given content. Returns false if it
 * can't be found.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be checked
 * @param     {string}       content        - Content to be matched against
 *
 * @returns   {number}                      - Matching line number
--]]
function file.isline(filename, content)
	if not file.exists(filename) then
		return false
	end

	local l = 0
	for line in io.lines(filename) do
		l = l + 1
		if line == content then
			return l
		end
	end

	return false
end

--[[
 * Executes the content of given file. Returns nil if file doesn't exist.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be checked
 *
 * @returns   {any}                         - Anything returned by the code ran
--]]
function file.exec(filename)
	if not file.exists(filename) then
		return nil
	end

	return exec(file.content(filename))
end




--   ______                                                    _______
--  /_  __/__  ____ ___  ____  ____  _________ ________  __   / ____(_)  _____  _____
--   / / / _ \/ __ `__ \/ __ \/ __ \/ ___/ __ `/ ___/ / / /  / /_  / / |/_/ _ \/ ___/
--  / / /  __/ / / / / / /_/ / /_/ / /  / /_/ / /  / /_/ /  / __/ / />  </  __(__  )
-- /_/  \___/_/ /_/ /_/ .___/\____/_/   \__,_/_/   \__, /  /_/   /_/_/|_|\___/____/
--                   /_/                          /____/

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