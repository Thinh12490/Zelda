--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    self.carriedItems = {}
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:render()
    Entity.render(self)
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)

    love.graphics.setColor(255, 0, 255, 255)
    local pickHitbox = self:getPickHitbox()
    love.graphics.rectangle('line', pickHitbox.x, pickHitbox.y,
    pickHitbox.width, pickHitbox.height)
    love.graphics.setColor(255, 255, 255, 255)
end

function Player:getPickHitbox()
    if self.direction == "left" then
        return Hitbox(self.x - 5, self.y + 5, 5, 15)
    elseif self.direction == "right" then
        return Hitbox(self.x + self.width, self.y + 5, 5, 15)
    elseif self.direction == "up" then
        return Hitbox(self.x, self.y - 5, 15, 5)
    elseif self.direction == "down" then
        return Hitbox(self.x, self.y + self.height, 15, 5)
    end
end

function Player:checkAndPickItems(items)
    local pickHitbox = self:getPickHitbox()

    for k, item in ipairs(items) do
        if item.type == 'pot' and item.state == 'default' then
            if hitboxesOverlap(pickHitbox, item) then
                table.remove(items, k)
                table.insert(self.carriedItems, {
                    item = item,
                    offsetX = function()
                        return self.x
                    end,
                    offsetY = function()
                        return self.y - item.height + 10
                    end
                })

                self:changeState('lift')
            end
        end
    end
end

function Player:updateCoordinateItems() 
    for k, carried in ipairs(self.carriedItems) do 
        carried.item.x = carried.offsetX()
        carried.item.y = carried.offsetY()
    end
end

