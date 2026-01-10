-- CONFIG
local saplingSlot = 1 -- slot met saplings
local fuelSlot = 16   -- optioneel, slot met brandstof

-- Hulpfuncties
function refuelIfNeeded()
    if turtle.getFuelLevel() < 100 then
        turtle.select(fuelSlot)
        turtle.refuel(1)
    end
end

-- Plant een 2x2 sapling
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
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
    end
    turtle.back()
    turtle.turnLeft()
    turtle.turnLeft() -- terug naar originele facing
end

-- Controleer of boom volgroeid is (blokken boven saplings)
function isTreeGrown()
    for x = 0, 1 do
        for z = 0, 1 do
            if turtle.inspectUp() then
                local success, data = turtle.inspectUp()
                if success and data.name:find("log") then
                    return true
                end
            end
            if z == 0 then turtle.forward() end
        end
        turtle.back()
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
    end
    turtle.back()
    turtle.turnLeft()
    turtle.turnLeft()
    return false
end

-- Harvest een 2x2 boom
function harvestTree()
    for y = 1, 10 do  -- max boomhoogte
        for x = 0, 1 do
            for z = 0, 1 do
                local success, block = turtle.inspectUp()
                if success and block.name:find("log") then
                    turtle.digUp()
                end
                if z == 0 then turtle.forward() end
            end
            turtle.back()
            if x == 0 then turtle.turnRight(); turtle.forward(); turtle.turnLeft() end
        end
        if not turtle.detectUp() then break end
        turtle.up()
    end
    -- Terug naar grond
    for i = 1, 10 do
        turtle.down()
    end
end

-- Hoofdloop
while true do
    refuelIfNeeded()
    
    if isTreeGrown() then
        print("Boom is volgroeid! Harvesting...")
        harvestTree()
        print("Boom geoogst.")
    else
        print("Boom nog niet volgroeid, wachten...")
    end
    
    plantTree()
    print("Saplings geplant.")
    
    -- Wacht 30 minuten (3600 ticks) voordat je opnieuw checkt
    sleep(1800) -- 1800 seconden = 30 minuten
end
