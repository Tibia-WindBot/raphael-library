Area = { __class = 'Area' }
AreaMT = { __index = Area }

function Area:new(firstCorner, width, height)
    -- Special handling for rect
    if type(firstCorner) == 'userdata' and firstCorner.objtype == 'rect' then
        return Area:new(Point:new(firstCorner.left, firstCorner.top), firstCorner.width, firstCorner.height)
    end

    firstCorner = Point:new(firstCorner)

    local secondCorner = Point:new(width)
    if secondCorner == nil then
        secondCorner = firstCorner + Point:new(width - 1, height - 1)
    end

    if type(firstCorner) ~= 'Point' or type(secondCorner) ~= 'Point' then
        return nil
    end

    local newObj = {
        topLeft = Point:new(math.min(firstCorner.x, secondCorner.x), math.min(firstCorner.y, secondCorner.y)),
        botRight = Point:new(math.max(firstCorner.x, secondCorner.x), math.max(firstCorner.y, secondCorner.y))
    }
    setmetatable(newObj, AreaMT)
    return newObj
end

function Area:createFromWaypoint(waypoint)
    local topLeft = Point:new(get(waypoint, 'Coordinates'):match(REGEX_COORDS))
    local width, height = get(waypoint, 'Range'):match(REGEX_RANGE)

    return Area:new(topLeft, width, height)
end

function Area:createFromSpecialArea(specialArea)
    local topLeft = Point:new(get(specialArea, 'Coordinates'):match(REGEX_COORDS))
    local width, height = get(specialArea, 'Size'):match(REGEX_RANGE)

    return Area:new(topLeft, width, height)
end

function Area:createFromAreaTable(areaTable)
    if areaTable.width ~= nil then
        return Area:new(Point:new(areaTable.left, areaTable.top), areaTable.width, areaTable.height)
    else
        return Area:new(Point:new(areaTable.left, areaTable.top), areaTable.right - areaTable.left, areaTable.bottom - areaTable.top)
    end
end

function Area:extend(top, right, bottom, left)
    -- This gives us a CSS-like workflow; the one that usually works in margin
    -- and padding shorthands
    top    = top    or 0
    right  = right  or top
    bottom = bottom or top
    left   = left   or right

    self.topLeft = self.topLeft - Point:new(left, top)
    self.botRight = self.botRight + Point:new(right, bottom)

    -- Allow chaining
    return self
end

function Area:getLeft()
    return self.topLeft.x
end

function Area:getTop()
    return self.topLeft.y
end

function Area:getRight()
    return self.botRight.x
end

function Area:getBottom()
    return self.botRight.y
end

function Area:getWidth()
    return self.botRight.x - self.topLeft.x + 1
end

function Area:getHeight()
    return self.botRight.y - self.topLeft.y + 1
end

function Area:hasPoint(point, y)
    point = Point:new(point, y)

    return point.x >= self.topLeft.x  and
           point.y >= self.topLeft.y  and
           point.x <= self.botRight.x and
           point.y <= self.botRight.y
end

function Area:isVertical()
    return self:getHeight() >= self:getWidth()
end

function Area:move(point, y)
    point = Point:new(point, y)

    self.topLeft = self.topLeft + point
    self.botRight = self.botRight + point

    -- Allow chaining
    return self
end

function AreaMT:__tostring()
    return '{topLeft = ' .. tostring(self.topLeft) .. ', botRight = ' .. tostring(self.botRight) .. '}'
end
