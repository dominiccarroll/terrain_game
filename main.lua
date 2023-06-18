require 'world'
require 'player'
require 'camera'


function love.load()
    world:generate()
    player:load()
end

function love.draw()
    local offset = camera
    world:draw(offset)
    player:draw(offset) 
end

function love.update(dt)
    player:update(dt)
    camera:update(dt)
end