PlayerThrowState = Class{__includes = BaseState}

function PlayerThrowState:init(player, dungeon)
    self.player = player

    self.room = dungeon.currentRoom

    self.player:changeAnimation('throw-' .. self.player.direction)

    local carriedItems = self.player.carriedItems
    self.player.carriedItems = {}
    

    local dx, dy = 0, 0
    local throwSpeed = 150

    if self.player.direction == 'left' then
        dx = -throwSpeed
    elseif self.player.direction == 'right' then
        dx = throwSpeed
    elseif self.player.direction == 'up' then
        dy = -throwSpeed
    elseif self.player.direction == 'down' then
        dy = throwSpeed
    end

    for k, carried in ipairs(carriedItems) do 
        table.insert(self.room.objects, carried.item)
        carried.item:fire(dx, dy)
    end

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0
end

function PlayerThrowState:enter(params)
    self.player.currentAnimation:refresh()
end

function PlayerThrowState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end
end

function PlayerThrowState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end