player = {}

player.x = 50
player.y = 200

player.width = 50
player.height = 100
player.speed = 400
player.jumpVelocity = 0

player.falling = false

gravity = 400

function player:draw(offset)
    love.graphics.setColor(1,1,1)
    love.graphics.print('Jump velocity: ' .. player.jumpVelocity,0,0)
    love.graphics.setColor(0,0,1)
    love.graphics.rectangle('fill', player.x + offset.x, player.y + offset.y, player.width, player.height)
end

function collisionDetection(x,y)
    local function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
        return x1 < x2+w2 and
               x2 < x1+w1 and
               y1 < y2+h2 and
               y2 < y1+h1
      end
      for _,node in ipairs(world.map) do
         if CheckCollision(x,y, player.width, player.height, node.x, node.y, node.width, node.height) then
            node.color.g = 0
            node.color.r = 1
            return true
         else
            node.color.g = 1
            node.color.r = 0
         end
      end
end

function player:jump(p)
    if player.jumpVelocity <= 0.01 then
        player.jumpVelocity = player.jumpVelocity + gravity * p
        player.jumpVelocity = player.jumpVelocity * 0.98

    end
end

function player:update(dt)



    if love.keyboard.isDown('d') then
      if not collisionDetection(player.x + player.speed * dt, player.y) then
        player.x = player.x + player.speed * dt
      else
        if not player.falling then
            player:jump(6) -- auto jump
        end
      end
    end
    if love.keyboard.isDown('a') then
        if not collisionDetection(player.x - player.speed * dt, player.y) then
            player.x = player.x - player.speed * dt
        else
            if not player.falling then
                player:jump(6) -- auto jump
            end
        end
    end

    if love.keyboard.isDown('space') and not player.falling then
        player:jump(15)
    end


    if not collisionDetection(player.x, player.y - player.jumpVelocity * dt) then
        player.y = player.y - player.jumpVelocity * dt

    else
        print('cant jump')
    end

    if player.jumpVelocity > 0.01 then
        player.jumpVelocity = player.jumpVelocity * 0.95
    end

    if not collisionDetection(player.x, player.y + gravity * dt) then
        player.y = player.y + gravity * dt
        player.falling = true
    else
        player.falling = false
    end
end