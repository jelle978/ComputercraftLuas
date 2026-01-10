-- CONFIG
local saplingSlot = 1   -- slot met spruce saplings
local fuelSlot = 16     -- slot met brandstof

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

-- HARVEST 2x2 BOOM
function harvestTree()
    -- Ga door 2x2 grid
    local directions = {{0,0},{0,1},{1,0},{1,1}}
    local startX, startZ = 0, 0 -- referentiepositie
    -- ga omhoog en hak alles
    local maxHeight = 20
    for y = 1,maxHeight do
        for i=1,#directions do
            local dx, dz = directions[i][1], directions[i][2]
            -- beweeg naar dit blok
            if dx == 1 then turtle.forward() end
            if dz == 1 then turtle.turnRight(); turtle.forward(); turtle.turnLeft() end

            -- hak als er log is
            while true do
                local success, block = turtle.inspectUp()
                if success and block.name:find("log") then
                    turtle.digUp()
                    turtle.up()
                else
                    break
                end
            end

            -- terug naar grondlaag
            while turtle.getY() > 0 do
                turtle.down()
            end

            -- terug naar startpositie van de grid
            if dz == 1 then turtle.turnRight(); turtle.back(); turtle.turnLeft() end
            if dx == 1 then turtle.back() end
        end
    end
end

-- ZET LOGS IN CHEST ONDER TURTLE
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
    for x=0,1 do
        for z=0,1 do
            turtle.placeDown()
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
    turtle.turnLeft()
    turtle.turnRight()
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

    -- Wacht 3 minuten
    sleep(180)
end
