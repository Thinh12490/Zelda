PlayerLiftState = Class{__includes = BaseState}

function PlayerLiftState:init(player)
    self.player = player

    self.player:changeAnimation('lift-' .. self.player.direction)

    -- used for drawing when this room is the next room, adjacent to the active
    self.adjacentOffsetX = 0
    self.adjacentOffsetY = 0

    local currentAnimation = self.player.currentAnimation
    self.tweenTimeAnimation = #currentAnimation.frames * currentAnimation.interval
end

function PlayerLiftState:enter(params)
    self.player.currentAnimation:refresh()

    for k, carried in ipairs(self.player.carriedItems) do   
        Timer.tween(self.tweenTimeAnimation, {
            [carried.item] = {
                x = carried.offsetX(),
                y = carried.offsetY()
            }
        })
    end
end

function PlayerLiftState:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to lift idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('lift-idle')
    end
end

function PlayerLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    for k, carried in ipairs(self.player.carriedItems) do   
        carried.item:render(self.adjacentOffsetX, self.adjacentOffsetY)
    end
end
