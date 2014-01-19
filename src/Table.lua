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