require 'items'

inventory = {}

inventory.contents = {}

inventory.interface = {slots={}, hidden = true}

slotSize = 30
quantity = 4 -- size of slot matrix

function inventory:isFull()
    return #inventory.contents >= (quantity^2)
end

function inventory:addItem(name, amount)
    local function add(n, a)
        if not inventory:isFull() then
            local item = {
                name = n,
                selected = false,
                quantity = a
            }
            table.insert(inventory.contents, item)
        else
            print('inventory full!')
            -- TO DO: Drop item
        end
    end
    
    local proto = items.prototypes[name]
    local stacks = math.floor(amount / proto.maxStack)
    local remainder = amount % proto.maxStack

    if stacks > 0 then
        for i = 1, stacks do
            add(name, proto.maxStack)
        end
        if remainder > 0 then
            add(name, remainder)
        end
    else
        add(name, amount)
    end
end

function inventory.interface:load()



    inventory.images = {
        ['pick'] = love.graphics.newImage('images/pick_axe.png'),
        ['dirt'] = love.graphics.newImage('images/blocks/dirt.png')
    }
    

    inventory:addItem('pick', 1)
    inventory:addItem('dirt', 230)



    local gap = 5


    local o = quantity * slotSize + gap * slotSize

    for v = 1, quantity do
        for h = 1, quantity do
            local slot = {}

            slot.x = (h-1) * slotSize + gap * h + love.graphics.getWidth()/2 - o/3
            slot.y = (v-1) * slotSize + gap * v
            slot.w, slot.h = slotSize, slotSize
            if v > 1 then
                slot.cascade = true
            end
            table.insert(inventory.interface.slots, slot)
        end
    end
end

function inventory.interface:draw()
    for i,s in ipairs(inventory.interface.slots) do
        local slot =  inventory.contents[i]

       if (s.cascade and not inventory.interface.hidden) or not s.cascade then
          love.graphics.setColor(1, 1, 1, 0.5)
            if slot ~= nil then
                if slot.selected then
                    love.graphics.setColor(0.5, 0.5, 1, 0.8)
                end
            end
           love.graphics.rectangle('fill', s.x, s.y, s.w, s.h)
       end
    end

    for i,s in ipairs(inventory.contents) do
        local slot =  inventory.interface.slots[i]
        local proto = items.prototypes[s.name]
        while slot.filled do -- TO DO: MAKE SURE THAT IT IS NOT FULL
            i = i + 1
            slot = inventory.interface.slots[i]
        end
        if (slot.cascade and not inventory.interface.hidden) or not slot.cascade then
            love.graphics.setColor(1,1,1)
            local factor = slotSize/proto.icon:getHeight() * .5
            love.graphics.draw(proto.icon, slot.x + (slotSize - proto.icon:getWidth()*factor)/2, slot.y + (slotSize - proto.icon:getHeight()*factor)/2, 0, factor, factor)
            if s.quantity > 1 then
                love.graphics.print('x' .. tostring(s.quantity), slot.x, slot.y + slotSize - 12)
            end
        end
    end
end

function inventory.interface:keyPress(key, unicode)
    if key == 'g' then
        if inventory.interface.hidden then
            inventory.interface.hidden = false
        else
            inventory.interface.hidden = true
        end
    end
end

function inventory.interface:mousePressed(x, y, button)
    if button == 1 then
        for _,slot in ipairs(inventory.interface.slots) do
            if (slot.cascade and not inventory.interface.hidden) or not slot.cascade then
                if x > slot.x and x < (slot.x + slot.w) and y > slot.y and y < (slot.y + slot.h) then
                    print('slot clicked')
                    return true
                end
             end
        end
    end
end