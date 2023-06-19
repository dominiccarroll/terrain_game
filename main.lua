require 'smoke'
require 'particle'
require 'world'
require 'items'
require 'inventory'
require 'player'
require 'camera'

function love.load()
    world:generate()
    items:load()
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
    local interface = false
    if inventory.interface:mousePressed(x, y, btn) then
        interface = true
    end
    if btn == 1 and not interface then
        print('use')
        player:use(x,y)
    end
end

function love.keypressed(key, unicode)
    inventory.interface:keyPress(key, unicode)
end