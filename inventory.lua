inventory = {}

inventory.contents = {}

inventory.interface = {slots={}, hidden = true}

slotSize = 30

function inventory.interface:load()


    inventory.images = {
        ['pick'] = love.graphics.newImage('images/pick_axe.png'),
        ['dirt'] = love.graphics.newImage('images/blocks/dirt.png')
    }
    inventory.contents = {
        {
            name = 'pick',
            type = 'tool',
            icon = inventory.images['pick'],
            quantity = 1
        }
    }

    for i = 1, 3 do
        table.insert(inventory.contents, {icon = inventory.images['dirt'], quantity = 1})
    end

    local gap = 5

    local quantity = 4

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
       if (s.cascade and not inventory.interface.hidden) or not s.cascade then
          love.graphics.setColor(1, 1, 1, 0.5)
           love.graphics.rectangle('fill', s.x, s.y, s.w, s.h)
       end
    end

    for i,s in ipairs(inventory.contents) do
        local slot =  inventory.interface.slots[i]
        while slot.filled do -- TO DO: MAKE SURE THAT INVENTORY IS NOT FULL
            i = i + 1
            slot = inventory.interface.slots[i]
        end
        if (slot.cascade and not inventory.interface.hidden) or not slot.cascade then
            love.graphics.setColor(1,1,1)
            local factor = slotSize/s.icon:getHeight() * .5
            love.graphics.draw(s.icon, slot.x + (slotSize - s.icon:getWidth()*factor)/2, slot.y + (slotSize - s.icon:getHeight()*factor)/2, 0, factor, factor)
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