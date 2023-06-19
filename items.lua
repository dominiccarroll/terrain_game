
items = {}
items.prototypes = {}

function items:load() 
    items.prototypes = {
        ["pick"] = {
            icon = love.graphics.newImage('images/pick_axe.png'),
            type = 'tool',
            maxStack = 1
        },
        ["dirt"] = {
            icon = love.graphics.newImage('images/blocks/dirt.png'),
            type = 'material',
            maxStack = 100
        }
    }
end