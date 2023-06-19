require 'smoke'
require 'particle'
require 'world'
require 'player'
require 'camera'


function love.load()
    world:generate()
    player:load()
    smoke:load()
end

function love.draw()
    local offset = camera
    world:draw(offset)
    player:draw(offset) 
    particle:draw()
    smoke:draw()
end

function love.update(dt)
    player:update(dt)
    camera:update(dt)
    particle:update(dt)
    smoke:update(dt)
end

function love.mousepressed(x, y, btn)
    if btn == 1 then
        print('use')
        player:use(x,y)
    end
end