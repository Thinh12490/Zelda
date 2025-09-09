--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player, dungeon)
    self.entity = player
    self.room = dungeon.currentRoom

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerWalkState:update(dt)
    self:handleMovement()

    -- perform base collision detection against walls
    EntityWalkState.update(self, dt)

    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then    
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.room.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    self.entity:updateCoordinateItems()
                    Event.dispatch('shift-left')
                end
            end
        elseif self.entity.direction == 'right' then
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.room.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    self.entity:updateCoordinateItems()
                    Event.dispatch('shift-right')
                end
            end
        elseif self.entity.direction == 'up' then
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.room.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    self.entity:updateCoordinateItems()
                    Event.dispatch('shift-up')
                end
            end
        else   
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.room.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    self.entity:updateCoordinateItems()
                    Event.dispatch('shift-down')
                end
            end
        end
    end
end

function PlayerWalkState:handleMovement()
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('walk-down')
    else
        self.entity:changeState('idle')
    end

    if love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end
end
