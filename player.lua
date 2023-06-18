local anim8 = require 'anim8'

player = {}

player.x = 50
player.y = 200

player.realX = 0
player.realY = 0

player.width = 48
player.height = 64
player.speed = 400
player.jumpVelocity = 0

player.falling = false
player.walking = false
player.animation = nil

gravity = 400

function player:load()
    player.spriteImage = love.graphics.newImage('images/player.png')
    local g = anim8.newGrid(48, 64, player.spriteImage:getWidth(), player.spriteImage:getHeight())
    
    player.animations = {
        walkRight = anim8.newAnimation(g('1-3', 2), 0.1),
        walkLeft = anim8.newAnimation(g('1-3', 4), 0.1),
        neutral = anim8.newAnimation(g('2-2', 3), 0.1),
    }

    player.tools = {
        ['pick'] = {
            image = love.graphics.newImage('images/pick_axe.png'),
            offset = {20, 50},
            origin = {0, 40}
        }
    }
    player.tool = {
        index = 'pick',
        show = false,
        r = -math.pi/2,
        using = false,
        duration = 0.2,
        direction = 0,
        start = nil
    }
    player.animation = player.animations.neutral
end 

function player:use(x, y)
    if player.tool.index == 'pick' and not player.tool.using then
        player.tool.using = true
        player.tool.show = true
        if x < player.realX then
            player.tool.direction = -1
        else
            player.tool.direction = 1
        end
        player.tool.start = love.timer.getTime()
    end
end

function player:draw(offset)
    local playerX, playerY = player.x + offset.x, player.y + offset.y
    player.realX, player.realY = playerX, playerY

    player.animation:draw(player.spriteImage, playerX, playerY)

    local tool = player.tools[player.tool.index]
    if player.tool.show then
        love.graphics.draw(tool.image, playerX + tool.offset[1], playerY + tool.offset[2], player.tool.r, 0.3, 0.3, tool.origin[1], tool.origin[2])
    end
    love.graphics.setColor(1,1,1)
    love.graphics.print('Jump velocity: ' .. player.jumpVelocity,0,0)
    love.graphics.print('Falling state: ' .. tostring(player.falling),0,10)
    love.graphics.setColor(0,0,1)
    -- love.graphics.rectangle('fill', player.x + offset.x, player.y + offset.y, player.width, player.height)
end

function collisionDetection(x,y)
    local function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
        return x1 < x2+w2 and
               x2 < x1+w1 and
               y1 < y2+h2 and
               y2 < y1+h1
      end
      for _,node in ipairs(world.map) do
         if CheckCollision(x,y, player.width, player.height, node.x, node.y, node.width, node.height) and not node.passThrough then
            return true
         end
      end
end

function player:jump(p)
    if player.jumpVelocity < 10 then
        player.jumpVelocity = gravity * p * 1.2
    end
end

function player:update(dt)
    player.animation:update(dt)
    player.walking = false
    player.animation = player.animations.neutral

    if love.keyboard.isDown('d') then
      if not collisionDetection(player.x + player.speed * dt, player.y) then
        player.x = player.x + player.speed * dt
        player.animation = player.animations.walkRight
        player.walking = true
      else
        if not player.falling then
            player:jump(2) -- auto jump
        end
      end
    end
    if love.keyboard.isDown('a') then
        if not collisionDetection(player.x - player.speed * dt, player.y) then
            player.x = player.x - player.speed * dt
            player.animation = player.animations.walkLeft
            player.walking = true
        else
            if not player.falling then
                player:jump(2) -- auto jump
            end
        end
    end

    if love.keyboard.isDown('space') and not player.falling then
        player:jump(4)
    end


    if not collisionDetection(player.x, player.y - player.jumpVelocity * dt) then
        player.y = player.y - player.jumpVelocity * dt

    else
        print('cant jump')
    end

    if player.jumpVelocity > 0.001 then
        player.jumpVelocity = player.jumpVelocity * 0.95
    end

    if not collisionDetection(player.x, player.y + gravity * dt) then
        player.y = player.y + gravity * dt
        player.falling = true
    else
        player.falling = false
    end

    if player.tool.start ~= nil then
        local toolGradient = (love.timer.getTime()-player.tool.start)/player.tool.duration
        if toolGradient < 1 then
            player.tool.r = -math.pi/2 + toolGradient*(math.pi/2) * player.tool.direction
            print(toolGradient)
        else
            player.tool.using = false 
            player.tool.show = false
        end
    end

end