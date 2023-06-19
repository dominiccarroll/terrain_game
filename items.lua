
items = {}
items.prototypes = {}

function items:load() 
    items.prototypes = {
        ["pick"] = {
            icon = love.graphics.newImage('images/pick_axe.png'),
            type = 'tool',
            maxStack = 1,
            utility = function(x, y)
                local nodeClicked
                print(x .. ', ' .. y)
                for nodeIndex,node in ipairs(world.map) do
                    if CheckCollision(x, y, 1, 1, node.x + camera.x, node.y + camera.y, node.width, node.height) then
                        table.remove(world.map, nodeIndex)
                        smoke:new(node.x - node.width / 2, node.y - node.height/2)
                        print('success')
                    end 
                end

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
        },
        ["dirt"] = {
            icon = love.graphics.newImage('images/blocks/dirt.png'),
            type = 'material',
            maxStack = 100
        }
    }
end