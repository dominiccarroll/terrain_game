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
            v_node = node.y + vertical*node.height
            v_node.width = nodeSize
            v_node.height = nodeSize
            
        end

        table.insert(world.map, node)
    
    end

end

function world:draw(offset)
    for index,node in ipairs(world.map) do
        love.graphics.setColor(0,1,0)
        love.graphics.rectangle("fill", node.x + offset.x, node.y + offset.y, nodeSize, nodeSize)
    end
end