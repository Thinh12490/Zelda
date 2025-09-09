--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]] 
    
GameObject = Class {}

function GameObject:init(def, x, y)

    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function()
    end

    self.dx = 0
    self.dy = 0
    self.projectile = false
    self.isRemoved = false

    self.invulnerable = false
    self.invulnerableDuration = 1
    self.invulnerableTimer = 0

    -- timer for turning transparency on and off, flashing
    self.flashTimer = 0
end

function GameObject:update(dt)
    if self.projectile then
        if self.invulnerable then
            self.flashTimer = self.flashTimer + dt
            self.invulnerableTimer = self.invulnerableTimer + dt
    
            if self.invulnerableTimer > self.invulnerableDuration then
                self:destroy()
            end
        end

        local dx = self.dx * dt
        local dy = self.dy * dt

        self.x = self.x + dx
        self.y = self.y + dy

        self.distanceTraveled = (self.distanceTraveled or 0) + math.sqrt(dx^2 + dy^2)

        if self.distanceTraveled > TILE_SIZE * 4 then
            self:breakPot()
        end

        local collidesWithWall = (self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE - 5 or 
            self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 + 5 or
            self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 - 5 or
            self.y + self.height >= VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
                + MAP_RENDER_OFFSET_Y - TILE_SIZE + 5)


        if collidesWithWall then
            self:breakPot()
        end
    end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    if self.invulnerable and self.flashTimer > 0.02 then
        self.flashTimer = 0
        love.graphics.setColor(1, 1, 1, 64/255)
    end

    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        math.floor(self.x + adjacentOffsetX), math.floor(self.y + adjacentOffsetY))

    love.graphics.setColor(1, 1, 1, 1)
end

function GameObject:fire(dx, dy) 
    self.dx = dx
    self.dy = dy
    self.projectile = true
end

function GameObject:destroy()
    self.isRemoved = true 
end

function GameObject:breakPot()
    self.state = 'broken'
    self.dx = 0
    self.dy = 0
    self.invulnerable = true
end
