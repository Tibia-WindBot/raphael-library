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
 * will receive as arguments, for each item, its value and correspondent index
 * and the whole table.
 *
 * @since     0.1.0
 * @updated   1.5.0
 *
 * @param     {table}        self           - The target table
 * @param     {function}     f              - Routine to be ran on each element
 * @param     {boolean}      [recursive]    - Whether inner tables should also
 *                                            be iterated; defaults to false
 *
 * @returns   {table}                       - A table with the returning values
 *                                            for each item
--]]
function table.each(self, f, recursive)
    local r = {}

    for k, v in pairs(self) do
        if recursive and type(v) == 'table' then
            r[k] = table.each(v, f, recursive)
        else
            r[k] = f(v, k, self)
        end
    end

    return r
end

--[[
 * Runs a routine through every item in the given table and replace the item
 * with the value returned by it. The routine to be ran will receive as
 * arguments, for each item, its value and correspondent index and the whole
 * table.
 *
 * @since     0.1.0
 * @updated   1.5.0
 *
 * @param     {table}        self           - The target table
 * @param     {function}     f              - Routine to be ran on each element
 * @param     {boolean}      [recursive]    - Whether inner tables should also
 *                                            be iterated; defaults to false
--]]
function table.map(self, f, recursive)
    for k, v in pairs(self) do
        if recursive and type(v) == 'table' then
            table.map(v, f, true)
        else
            self[k] = f(v, k, self)
        end
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

--[[
 * Makes a deep, by value, copy of a table. This solves referencing problems.
 * This may be slow for big, complex tables; use carefully.
 *
 * Adapted from http://lua-users.org/wiki/CopyTable
 *
 * @since     1.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {table}                       - The copy of the table
--]]
function table.copy(self)
    local origType, copy = type(self)

    if origType == 'table' then
        copy = {}

        for origKey, origValue in next, self, nil do
            copy[table.copy(origKey)] = table.copy(origValue)
        end

        setmetatable(copy, table.copy(getmetatable(self)))
    else
        copy = self
    end
    return copy
end

--[[
 * Normalizes the given table, removing nil values and rearranging the indexes.
 *
 * @since     1.1.0
 *
 * @param     {table}        self           - The target table
--]]
function table.normalize(self)
    for i = #self, 1, -1 do
        if self[i] == nil then
            table.remove(self, i)
        end
    end
end

--[[
 * Runs a routine through every item in the given table and remove it from the
 * table if the routine returns false. The routine to be ran will receive as
 * arguments, for each item, its value and correspondent index and the whole
 * table.
 *
 * @since     1.1.0
 * @updated   1.5.0
 *
 * @param     {table}        self           - The target table
 * @param     {function}     f              - Routine to be ran as filter;
 *                                            default removes falsy values
--]]
function table.filter(self, f)
    if not f then
        f = tobool
        table.normalize(self)
    end

    for k, v in pairs(self) do
        if not f(v, k, self) then
            table.remove(self, k)
        end
    end
end

--[[
 * Merges the items of the given tables to a single table.
 *
 * @since     1.1.0
 * @updated   1.4.0
 *
 * @param     {table}        [table1], ...  - Tables to be merged
 * @param     {boolean}      [recursive]    - Whether inner tables should also
 *                                            be merged; defaults to false
 *
 * @returns  {table}                        - A table with all items on the
 *                                            given tables
--]]
function table.merge(...)
    local args = {...}
    local r = {}
    local recursive, f

    if (type(table.last(args)) == 'boolean') then
        recursive = table.remove(args)
    end

    if #args[1] ~= table.size(args[1]) then
        function f(v, k)
            if recursive and type(r[k]) == 'table' and type(v) == 'table' then
                r[k] = table.merge(r[k], v, true)
            else
                r[k] = v
            end
        end
    else
        function f(v)
            local rv = v
            table.insert(r, rv)
        end
    end

    table.each(args, function(v)
        table.each(v, f, recursive)
    end)

    return r
end

--[[
 * Returns the sum of all items in the given table.
 *
 * @since     1.1.0
 * @updated   1.5.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {number}                      - The sum of all items
--]]
function table.sum(self)
    return table.reduce(self, function (memo, v) return memo + v end)
end

--[[
 * Returns the average of all items in the given table.
 *
 * @since     1.1.0
 * @since     1.5.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {number}                      - The average of all items
--]]
function table.average(self)
    return table.sum(self) / table.size(self)
end

--[[
 * Returns the maximum value of all items in the given table.
 *
 * @since     1.1.0
 *
 * @param   {table}     self    - The target table
 *
 * @returns {number}            - The maximum value of all items
--]]
function table.max(self)
    return math.max(table.unpack(self))
end

--[[
 * Returns the minimum value of all items in the given table.
 *
 * @since     1.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {number}                      - The minimum value of all items
--]]
function table.min(self)
    return math.min(table.unpack(self))
end

--[[
 * Flattens the table, removing any other tables inside `self` and inserting the
 * values inside those tables.
 *
 * @since     1.4.0
 *
 * @param     {table}        self           - The target table
 * @param     {boolean}      [recursive]    - Whether inner tables should also
 *                                            be flattened; defaults to false
--]]
function table.flatten(self, recursive)
    -- I would have liked to use ipairs() here, but since we'll need to skip
    -- added indexes, I couldn't =/
    for i = 1, #self do
        if type(self[i]) == 'table' then
            if recursive then
                table.flatten(self[i])
            end

            for j, v in ipairs(self[i]) do
                table.insert(self, i + j, v)
            end

            tableIndex = i
            i = i + #self[i] - 1
            table.remove(self, tableIndex)
        end
    end
end

--[[
 * Returns a copy of the table, filtered to only have values for the whitelisted
 * keys.
 *
 * @since     1.5.0
 *
 * @param     {table}        self           - The target table
 * @param     {string}       key1, [...]    - The whitelisted keys
 *
 * @returns   {table}                       - The copy of the table, filtered
--]]
function table.pick(self, ...)
    local args = {...}
    local r = {}

    for _, v in ipairs(args) do
        r[v] = self[v]
    end

    return r
end

--[[
 * Runs a routine through every item in the given table to reduce it to a single
 * value. The routine to be ran will receive as arguments, for each item, its
 * value and the result of the reduction of the previous elements of the table.
 *
 * @since     1.5.0
 *
 * @param     {table}        self           - The target table
 * @param     {function}     f              - The routine used to reduce the
 *                                            table
 * @param     {any}          [memo]         - The initial value to be passed to
 *                                            the routine as the second argument;
 *                                            if none is passed, the first item
 *                                            is used and iteration starts on the
 *                                            second one instead
 *
 * @returns   {any}                         - The reduced value
--]]
function table.reduce(self, f, memo)
    for k, v in pairs(self) do
        if memo == nil then
            memo = v
        else
            memo = f(memo, v, k, self)
        end
    end

    return memo
end

--[[
 * Runs a routine through every item in the given table and returns whether every
 * item ran through the routine returns true. The routine to be ran will receive
 * as arguments, for each item, its value and correspondent index and the whole
 * table.
 *
 * @since     1.5.0
 *
 * @param     {table}        self           - The target table
 * @param     {function}     f              - The routine ran through the table
 *
 * @returns   {boolean}                     - Whether all items passed the test
 *                                            by the routine
--]]
function table.every(self, f)
    for k, v in pairs(self) do
        if not f(v, k, self) then
            return false
        end
    end

    return true
end

--[[
 * Runs a routine through every item in the given table and returns whether any
 * item ran through the routine returns true. The routine to be ran will receive
 * as arguments, for each item, its value and correspondent index and the whole
 * table.
 *
 * @since     1.5.0
 *
 * @param     {table}        self           - The target table
 * @param     {function}     f              - The routine ran through the table
 *
 * @returns   {boolean}                     - Whether any items passed the test
 *                                            by the routine
--]]
function table.any(self, f)
    for k, v in pairs(self) do
        if f(v, k, self) then
            return true
        end
    end

    return false
end

--[[
 * Extracts a property from each item in the given table.
 *
 * @since     1.5.0
 *
 * @param     {table}        self           - The target table
 * @param     {any}          prop           - The property to be extracted
 *
 * @returns   {table}                       - The table with the extracted
 *                                            properties
--]]
function table.pluck(self, prop)
    return table.each(self, function (v) return v[prop] end)
end

--[[
 * Returns a copy of the table with the indexes reversed.
 *
 * @since     1.5.0
 * @updated   1.5.1
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {table}                       - The table with the reversed indexes
--]]
function table.reverse(self)
    local r = {}

    for i, v in ipairs(self) do
        r[#self - i + 1] = v
    end

    return r
end

--[[
 * Shuffles the table (randomizes the order of the elements).
 *
 * @since     1.6.3
 *
 * @param     {table}        self           - The target table
--]]
function table.shuffle(self)
    local index
    for i = #self, 1, -1 do
        index = math.random(i)

        self[i], self[index] = self[index], self[i]
    end
end