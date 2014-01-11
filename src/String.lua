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
 * @since     1.0.0
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
 * @since     1.0.0
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
 * @since     1.0.0
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
 * @since     1.0.0
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

--[[
 * Removes whitespaces from beginning and ending of given string.
 *
 * @since     1.0.3
 *
 * @param     {string}       self           - The target string
 *
 * @returns   {boolean}                     - The trimmed string
--]]
function string.trim(self)
	return self:gsub('^%s*(.-)%s*$', '%1')
end