player = {}

player.x = 50
player.y = 200

player.width = 50
player.height = 100
player.speed = 400
player.jumpVelocity = 0

gravity = 400

function player:draw(offset)
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
            return true
         end
      end
end

function player:jump(p)
    if player.jumpVelocity <= 0.05 then
        player.jumpVelocity = player.jumpVelocity + p
    end
end

function player:update(dt)
    local fallingState = false
    if not collisionDetection(player.x, player.y - player.jumpVelocity + gravity * dt) then
        player.y = player.y - player.jumpVelocity + gravity * dt
        fallingState = true
    else
        fallingState = false
    end
    player.jumpVelocity = player.jumpVelocity * 0.98
    if love.keyboard.isDown('d') then
      if not collisionDetection(player.x + gravity * dt, player.y) then
        player.x = player.x + gravity * dt
      else
        if not fallingState then
            player:jump(3) -- auto jump
        end
      end
    end
    if love.keyboard.isDown('a') then
        if not collisionDetection(player.x - gravity * dt, player.y) then
            player.x = player.x - gravity * dt
        else
            if not fallingState then
                player:jump(3) -- auto jump
            end
        end
    end

    if love.keyboard.isDown('space') and not fallingState then
        player:jump(6)
    end
end