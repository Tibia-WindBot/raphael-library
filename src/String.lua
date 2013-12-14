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