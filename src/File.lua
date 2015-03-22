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
