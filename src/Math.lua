--[[
 * Rounds to the nearest multiple of mult. If it's exactly between two
 * multiples, rounds up.
 *
 * @since     0.1.0
 *
 * @param     {number}       self           - The number to be rounded
 * @param     {number}       mult           - The multiple base; defaults to 1
 *
 * @returns   {number}                      - The rounded number
--]]
function math.round(self, mult)
	div = div or 1

	if self % 1 >= 0.5 then
		return math.ceil(self, mult)
	else
		return math.floor(self, mult)
	end
end

--[[
 * Rounds up to the nearest multiple of mult.
 *
 * @since     0.1.0
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