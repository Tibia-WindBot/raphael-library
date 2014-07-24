Area = { __class = 'Area' }
AreaMT = { __index = Area }

function Area:new(firstCorner, width, height)
	firstCorner = Point:new(firstCorner)

	local secondCorner = Point:new(width)
	if secondCorner == nil then
		secondCorner = firstCorner + Point:new(width, height)
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

function Area:hasPoint(point, y)
	point = Point:new(point, y)

	return point.x >= self.topLeft.x  and
	       point.y >= self.topLeft.y  and
	       point.x <= self.botRight.x and
	       point.y <= self.botRight.y
end

function AreaMT:__tostring()
	return '{topLeft = ' .. tostring(self.topLeft) .. ', botRight = ' .. tostring(self.botRight) .. '}'
end
