-- CONFIG
local saplingSlot = 1   -- slot met spruce saplings
local fuelSlot = 16     -- slot met brandstof
local chestSide = "right" -- kant waar de chest staat: "right" of "left"

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

-- BEWEGING FUNCTIES
-- ga naar een boomblok vanaf startpositie naast de boom
local function moveToBlock(dx, dz)
    if dx == 1 then turtle.forward() end
    if dz == 1 then
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
    end
end

-- terug naar startpositie naast de boom
local function returnToStart(dx, dz)
    if dz == 1 then
        turtle.turnRight()
        turtle.back()
        turtle.turnLeft()
    end
    if dx == 1 then turtle.back() end
end

-- HAK ALLE LOGS VAN EEN BLOK, rekening houdend met ongelijke kolomhoogte
local function harvestColumn()
    while true do
        local success, block = turtle.inspectUp()
        if success and block.name:find("log") then
            turtle.digUp()
            if not turtle.up() then break end
        else
            break
        end
    end
    -- terug naar grond
    while turtle.detectDown() do
        turtle.down()
    end
end

-- HARVEST 2x2 BOOM VANUIT ZIJKANT
function harvestTree()
    local positions = {
        {0,0}, {0,1},
        {1,0}, {1,1}
    }
    for _, pos in ipairs(positions) do
        moveToBlock(pos[1], pos[2])
        harvestColumn()
        returnToStart(pos[1], pos[2])
    end
end

-- DROPPEN LOGS IN CHEST
function storeLogs()
    for slot = 2,16 do
        turtle.select(slot)
        if turtle.getItemCount() > 0 then
            if chestSide == "right" then turtle.turnRight() end
            turtle.drop()
            if chestSide == "right" then turtle.turnLeft() end
        end
    end
end

-- PLANT 2x2 SAPLINGS VANUIT ZIJKANT
function plantTree()
    turtle.select(saplingSlot)
    local positions = {
        {0,0}, {0,1},
        {1,0}, {1,1}
    }
    for _, pos in ipairs(positions) do
        moveToBlock(pos[1], pos[2])
        turtle.placeDown()
        returnToStart(pos[1], pos[2])
    end
end

-- HOOFDLOOP
while true do
    refuelIfNeeded()

    print("Boom oogsten...")
    harvestTree()
    print("Boom geoogst.")

    print("Logs opslaan in chest...")
    storeLogs()
    print("Logs opgeslagen.")

    print("Saplings planten...")
    plantTree()
    print("Saplings geplant.")

    print("Wachten 3 minuten...")
    sleep(180)
end
