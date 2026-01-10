-- CONFIG
local saplingSlot = 1  -- slot met spruce saplings
local fuelSlot = 16    -- slot met brandstof (optioneel)

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

-- HARVEST 2x2 BOOM (zonder max height)
function harvestTree()
    local positions = {{0,0},{0,1},{1,0},{1,1}}

    for _, pos in ipairs(positions) do
        local dx, dz = pos[1], pos[2]

        -- beweeg naar het blok
        if dx == 1 then turtle.forward() end
        if dz == 1 then
            turtle.turnRight()
            turtle.forward()
            turtle.turnLeft()
        end

        -- hak alle logs boven dit blok
        while true do
            local success, block = turtle.inspectUp()
            if success and block.name:find("log") then
                turtle.digUp()
                if not turtle.up() then break end  -- stop veilig als niet omhoog kan
            else
                break
            end
        end

        -- terug naar grondlaag
        while turtle.detectDown() do
            turtle.down()
        end

        -- terug naar startpositie van de grid
        if dz == 1 then
            turtle.turnRight()
            turtle.back()
            turtle.turnLeft()
        end
        if dx == 1 then turtle.back() end
    end
end

-- OPSLAAN IN CHEST ONDER TURTLE
function storeLogs()
    for slot = 2,16 do
        turtle.select(slot)
        if turtle.getItemCount() > 0 then
            turtle.dropDown()
        end
    end
end

-- PLANT 2x2 SAPLINGS
function plantTree()
    turtle.select(saplingSlot)
    local positions = {{0,0},{0,1},{1,0},{1,1}}

    for _, pos in ipairs(positions) do
        local dx, dz = pos[1], pos[2]

        -- beweeg naar het blok
        if dx == 1 then turtle.forward() end
        if dz == 1 then
            turtle.turnRight()
            turtle.forward()
            turtle.turnLeft()
        end

        -- plant sapling
        turtle.placeDown()

        -- terug naar startpositie
        if dz == 1 then
            turtle.turnRight()
            turtle.back()
            turtle.turnLeft()
        end
        if dx == 1 then turtle.back() end
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
