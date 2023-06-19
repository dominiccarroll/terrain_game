require 'smoke'
require 'particle'
require 'world'
require 'player'
require 'camera'
require 'inventory'

function love.load()
    world:generate()
    player:load()
    smoke:load()
    inventory.interface:load()
end

function love.draw()
    local offset = camera
    world:draw(offset)
    player:draw(offset) 
    particle:draw()
    smoke:draw()

    inventory.interface:draw()
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

function love.keypressed(key, unicode)
    inventory.interface:keyPress(key, unicode)
end