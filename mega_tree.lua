-- CONFIG
local saplingSlot = 1  -- slot met spruce saplings
local fuelSlot = 16    -- slot met brandstof
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

-- HULPFUNCTIE: ga naar boomblok vanaf zijkant
-- pos = {dx, dz} relativ aan turtle startpositie
function moveToBlock(pos)
    local dx, dz = pos[1], pos[2]
    if dx == 1 then turtle.forward() end
    if dz == 1 then
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
    end
end

-- ga terug naar startpositie
function returnToStart(pos)
    local dx, dz = pos[1], pos[2]
    if dz == 1 then
        turtle.turnRight()
        turtle.back()
        turtle.turnLeft()
    end
    if dx == 1 then turtle.back() end
end

-- HARVEST 2x2 BOOM VANUIT ZIJKANT
function harvestTree()
    local positions = {
        {0,0}, {0,1},
        {1,0}, {1,1}
    }

    for _, pos in ipairs(positions) do
        moveToBlock(pos)

        -- hak alle logs boven dit blok
        while true do
            local success, block = turtle.inspectUp()
            if success and block.name:find("log") then
                turtle.digUp()
                if not turtle.up() then break end
            else
                break
            end
        end

        -- terug naar grondlaag
        while turtle.detectDown() do
            turtle.down()
        end

        returnToStart(pos)
    end
end

-- DROPPEN IN CHEST AAN ZIJKANT
function storeLogs()
    local chestFunction = (chestSide == "right") and turtle.drop or turtle.dropUp
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
        moveToBlock(pos)
        turtle.placeDown()
        returnToStart(pos)
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
