world = {}

world.map = {}

local nodeSize = 30
local width = 800/nodeSize + 500
local height = 600/nodeSize
local frequency = 100

function world:generate()
  for x = 1,width do
        local offset = love.math.noise(x/width)
        -- print(offset)
        local node = {}
        node.x = x*nodeSize
        node.y = -100 + math.floor(offset*frequency)*nodeSize
        node.width = nodeSize
        node.height = nodeSize

        for vertical = 1,200 do
            local v_node = {}
            v_node.x = x*nodeSize
            v_node.width = nodeSize
            v_node.height = nodeSize
            v_node.y = node.y + vertical*v_node.height
            table.insert(world.map, v_node)
            
        end

        table.insert(world.map, node)
    
    end

end

function world:isVisible(offset, x, y, w, h)
    x = x + offset.x
    y = y + offset.y
    if (x+w) < 0 then
        return false
    end

    if x > love.graphics.getWidth() then
        return false
    end

    if (y+h) < 0 then
        return false
    end

    if y > love.graphics.getHeight() then
        return false
    end

    return true
end

function world:draw(offset)
    for index,node in ipairs(world.map) do
        if world:isVisible(offset, node.x, node.y, node.width, node.height) then
            love.graphics.setColor(0,1,0)
            love.graphics.rectangle("fill", node.x + offset.x, node.y + offset.y, node.width, node.height)
        end
    end
end