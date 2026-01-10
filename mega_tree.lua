-- CONFIG
local saplingSlot = 1   -- slot met spruce saplings
local fuelSlot = 16     -- slot met fuel (optioneel)
local maxTreeHeight = 10 -- maximale boomhoogte voor oogsten

-- REFUEL FUNCTIE
function refuelIfNeeded()
    if turtle.getFuelLevel() < 100 then
        turtle.select(fuelSlot)
        if turtle.getItemCount() > 0 then
            turtle.refuel(1)
        else
            print("Niet genoeg brandstof!")
        end
    end
end

-- PLANT 2x2 SAPLINGS
function plantTree()
    turtle.select(saplingSlot)
    for x = 0, 1 do
        for z = 0, 1 do
            turtle.placeDown()
            if z == 0 then
                turtle.forward()
            end
        end
        turtle.back()
        if x == 0 then
            turtle.turnRight()
            turtle.forward()
            turtle.turnLeft()
        end
    end
    -- terug naar startpositie
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
    turtle.turnRight()
end

-- CHECK OF BOOM VOLGROEID IS
function isTreeGrown()
    local grown = false
    for x = 0, 1 do
        for z = 0, 1 do
            local success, block = turtle.inspectUp()
            if success and block.name:find("log") then
                grown = true
            end
            if z == 0 then turtle.forward() end
        end
        turtle.back()
        if x == 0 then
            turtle.turnRight()
            turtle.forward()
            turtle.turnLeft()
        end
    end
    -- terug naar start
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnRight()
    turtle.turnLeft()
    return grown
end

-- OOGST 2x2 BOOM
function harvestTree()
    for y = 1, maxTreeHeight do
        for x = 0, 1 do
            for z = 0, 1 do
                local success, block = turtle.inspectUp()
                if success and block.name:find("log") then
                    turtle.digUp()
                end
                if z == 0 then turtle.forward() end
            end
            turtle.back()
            if x == 0 then
                turtle.turnRight()
                turtle.forward()
                turtle.turnLeft()
            end
        end
        -- probeer omhoog, stop als niet mogelijk
        if not turtle.up() then
            break
        end
    end
    -- terug naar grond
    while true do
        if turtle.down() == false then break end
    end
end

-- HOOFDLOOP
while true do
    refuelIfNeeded()
    
    if isTreeGrown() then
        print("Boom volgroeid! Oogsten...")
        harvestTree()
        print("Boom geoogst.")
    else
        print("Boom nog niet volgroeid, wachten...")
    end
    
    print("Saplings planten...")
    plantTree()
    print("Saplings geplant.")
    
    -- Wacht 3 minuten (180 seconden) voordat je opnieuw checkt
    sleep(180)
end
