camera = {}

camera.x, camera.y = 0, 0

local camera_bounds = {
    x = 0.3,
    y = 0.4
}

function camera:update(dt)
    if (player.x + player.width)+camera.x >= love.graphics.getWidth()*(1-camera_bounds.x) then
        camera.x = camera.x - player.speed * dt
    elseif (player.x)+camera.x <= love.graphics.getWidth() * camera_bounds.x then
        camera.x = camera.x + player.speed * dt
    end

    if (player.y + player.height)+camera.y > love.graphics.getHeight() * (1-camera_bounds.y) then
        camera.y = camera.y - player.speed * dt
    elseif (player.y)+camera.y < love.graphics.getHeight() * camera_bounds.y then
        camera.y = camera.y + player.speed * dt
    end
end