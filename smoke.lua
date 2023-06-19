local anim8 = require 'anim8'

-- 80 x 80

smoke = {}
smoke.pumes = {}

function smoke:load()
    smoke.image = love.graphics.newImage('images/smoke.png')
end

function smoke:new(x, y)
    local s = {}
    s.x = x
    s.y = y

    s.start = love.timer.getTime()

    local g = anim8.newGrid(1024, 1024, smoke.image:getWidth(), smoke.image:getHeight())
    s.animation = anim8.newAnimation(g('1-4',1),0.1)

    table.insert(smoke.pumes, s)
end

function smoke:update(dt)
    for i,v in ipairs(smoke.pumes) do
        v.animation:update(dt)

        if love.timer.getTime()-v.start >= 0.4 then
            table.remove(smoke.pumes, i)
        end
    end
end

function smoke:draw()
    for _,v in ipairs(smoke.pumes) do
        local scaleFactor = 16/1024 * 2
        love.graphics.setColor(1,1,1)
        v.animation:draw(smoke.image, v.x + camera.x, v.y + camera.y, 0, scaleFactor, scaleFactor)
    end
end