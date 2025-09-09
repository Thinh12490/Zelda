PlayerLiftIdleState = Class{__includes = PlayerIdleState}

function PlayerLiftIdleState:init(player)
    self.player = player
    self.player:changeAnimation('lift-idle-' .. self.player.direction)

    -- render offset for spaced character sprite; negated in render function of state
    self.player.offsetY = 5
    self.player.offsetX = 0

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
end

function PlayerLiftIdleState:update(dt)
    self:handleMovement()
end

function PlayerLiftIdleState:handleMovement()
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') or
        love.keyboard.isDown('down') then
        self.player:changeState('lift-walk')
    end

    if love.keyboard.wasPressed('return') then
        self.player:changeState('throw')
    end

    self.player:updateCoordinateItems()
end

function PlayerLiftIdleState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    for k, carried in ipairs(self.player.carriedItems) do   
        carried.item:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end
end