PlayerLiftWalkState = Class{__includes = PlayerWalkState}

function PlayerLiftWalkState:init(player, dungeon)
    self.entity = player
    self.room = dungeon.currentRoom

    self.entity:changeAnimation('lift-walk-' .. self.entity.direction)

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
end

function PlayerLiftWalkState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))

    for k, carried in ipairs(self.entity.carriedItems) do   
        carried.item:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end
end

function PlayerLiftWalkState:handleMovement()
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('lift-walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('lift-walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('lift-walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('lift-walk-down')
    else
        self.entity:changeState('lift-idle')
    end

    if love.keyboard.wasPressed('return') then
        self.entity:changeState('throw')
    end

    self.entity:updateCoordinateItems()
end