HUD = { __class = 'HUD' }
HUDMT = { __index = HUD }

function HUD:new(options)
	newObj = {
		uniqueId      = nil,
		draggable     = false,
		dragEvent     = IEVENT_MMOUSEDOWN,
		dragStopEvent = IEVENT_MMOUSEUP,
		dragTarget    = nil,
		savePosition  = false,
		startPosition = Point:new(0, 0),
		posRelativeTo = function() return Point:new(0, 0) end,
		database      = $botdb,

		dragging      = false
	}

	newObj = table.merge(newObj, options, true)

	if newObj.savePosition then
		if newObj.uniqueId == nil then
			error('The uniqueId attribute is required when savePosition is enabled.')
		end

		local oldPos = newObj.database:getvalue('HUDs Info', newObj.uniqueId .. '.position')
		if oldPos ~= nil then
			newObj.startPosition = newObj.posRelativeTo() + Point:new(oldPos:explode(';'))
		end
	end

	setmetatable(newObj, HUDMT)
	return newObj
end

function HUD:bootstrap()
	filterinput(false, self.draggable, false, false)
	self:setPosition(self.startPosition)
end

function HUD:setPosition(x, y)
	local p = Point:new(x, y)
	setposition(p.x, p.y)

	if self.savePosition then
		self:updateSavedPosition()
	end
end

function HUD:handleInput(e)
	if self.draggable and (self.dragTarget == nil or self.dragTarget == e.elementid) then
		if e.type == self.dragEvent then
			self:startDragging()
		elseif e.type == self.dragStopEvent then
			self:stopDragging()
		end
	end
end

function HUD:run()
	if self.draggable then
		self:drag()
	end
end

function HUD:startDragging()
	self.dragging = true
	self.mousePos = Point:new($cursor)
end

function HUD:stopDragging()
	self.dragging = false

	-- Had to move it to HUD:setPosition(), because apparently getposition()
	-- doesn't work inside inputevents()
	--[[ if self.savePosition then
		self:updateSavedPosition()
	end ]]--
end

function HUD:updateSavedPosition()
	local relativePos = Point:new(getposition()) - self.posRelativeTo()
	self.database:setvalue('HUDs Info', self.uniqueId .. '.position', relativePos.x .. ';' .. relativePos.y)
end

function HUD:drag()
	if self.dragging then
		auto(10)

		local curMouse = Point:new($cursor)

		self:setPosition((curMouse - self.mousePos) + getposition())
		self.mousePos = curMouse
	end
end
