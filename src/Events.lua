--[[
 * Handles talking to a NPC. Takes care of all waiting times and checks if NPCs
 * channel is open. By default, it uses a waiting method that waits until it
 * sees the the message was actually sent. Optionally, you can opt for the
 * original waitping() solution, passing `normalWait` as true.
 *
 * @since     0.1.0
 * @updated   1.2.0
 *
 * @param     {string...}    messages       - Messages to be said
 * @param     {boolean}      [normalWait]   - If waitping should be used as
 *                                            waiting method; defaults to false
 *
 * @returns   {boolean}                     - A value indicating whether all
 *                                            messages were correctly said
--]]
function npctalk(...)
	local args = {...}

	-- Checks for NPCs around
	-- Blatantly (almost) copied from @Colandus' lib
	local npcFound = false
	foreach creature c 'nfs' do
		if c.dist <= 3 then
			npcFound = true
			break
		end
	end

	if not npcFound then
		return false
	end


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
					return npctalk(select(k, ...))
				end
			end
		end
	end

	return true
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
