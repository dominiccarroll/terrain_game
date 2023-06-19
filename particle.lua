particle = {}
particle.gravity = 300
particle.particles = {}

function particle:new(x, y, color, size, scatter, duration, speed)
    local duration = duration or 2
    local speed = speed or 50
    local scatter = scatter or 25
    local size = size or 3

    for i = 1, scatter do
        local p = {}
        p.x = x
        p.y = y
        p.size = size
        p.duration = duration
        p.color = color
        p.start = love.timer.getTime()
        p.vx = love.math.random(-speed, speed) * love.math.random(-500, 500)/100
        p.vy = love.math.random(-speed, speed) * love.math.random(-500, 500)/100 + 300


        table.insert(particle.particles, p)
    end
end

function particle:draw()
    for i,p in ipairs(particle.particles) do
        love.graphics.setColor(1, 1, 1) -- to do set color
        love.graphics.rectangle('fill', p.x, p.y, p.size, p.size)
    end
end

function particle:update(dt)
    for index,p in ipairs(particle.particles) do
        p.y = p.y + p.vy * dt
        p.x = p.x + p.vx * dt

        if love.timer.getTime()-p.start >= p.duration then
            table.remove(particle.particles, index)
        end
    end
end