world = {}

world.map = {}

local nodeSize = 16
local width = 800/nodeSize * 10
local height = 600/nodeSize
local frequency = 100

function world:tree(x, y)
    local trunkSize = love.math.random(4, 15)
    for trunkTile = 1, trunkSize do
        local trunkNode = {}
        trunkNode.x = x
        trunkNode.y = y - nodeSize * trunkTile
        trunkNode.width = nodeSize
        trunkNode.height = nodeSize
        trunkNode.texture = 'trunk'
        trunkNode.passThrough = true

        table.insert(world.map, trunkNode)
    end

    local leavesWidth = love.math.random(5, 10)
    leavesHeight = love.math.random(5, 15)

    for lh = 1, leavesHeight do
        for lw = -leavesWidth/2, leavesWidth do
            local leafNode = {}
            leafNode.x = x + lw * nodeSize
            leafNode.y = y - nodeSize * trunkSize - nodeSize * lh
            leafNode.width = nodeSize
            leafNode.height = nodeSize

            leafNode.texture = 'leaves'

            leafNode.passThrough = true

            table.insert(world.map, leafNode)
        end
    end
end

function world:generate()
    world.images = {
        ['grass'] = love.graphics.newImage('images/blocks/old_grass_side.png'),
        ['dirt'] = love.graphics.newImage('images/blocks/old_dirt.png'),
        ['sky'] = love.graphics.newImage('images/sky.png'),
        ['trunk'] = love.graphics.newImage('images/blocks/Snakewood_side.png'),
        ['leaves'] = love.graphics.newImage('images/blocks/old_grass_top.png')

    }
  for x = 1,width do
        local offset = love.math.noise(x/width)
        -- print(offset)
        local node = {}
        node.x = x*nodeSize
        node.y = -300 + math.floor(offset*frequency)*nodeSize
        node.width = nodeSize
        node.height = nodeSize
        node.passThrough = false

        node.texture = 'grass'

        if 1 == love.math.random(1, 30) then
            world:tree(node.x, node.y)
            print('tree')
        end

        for vertical = 1,40 do
            local v_node = {}
            v_node.x = x*nodeSize
            v_node.width = nodeSize
            v_node.height = nodeSize
            v_node.y = node.y + vertical*v_node.height
            v_node.texture = 'dirt'
            v_node.passThrough = false

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

local nodesRendered = 0
function world:draw(offset)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(world.images['sky'], 0, 0, 0, 3.5,3.5)

    love.graphics.print('Nodes rendered: ' .. tostring(nodesRendered), 0, 30)
    nodesRendered = 0
    for index,node in ipairs(world.map) do
        if world:isVisible(offset, node.x, node.y, node.width, node.height) then
            love.graphics.draw(world.images[node.texture], node.x + offset.x, node.y + offset.y) --, node.width, node.height)
            nodesRendered = nodesRendered + 1
        end
    end
end