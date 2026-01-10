-- CONFIG
local saplingSlot = 1   -- Slot met spruce saplings
local fuelSlot = 16     -- Slot met brandstof (optioneel)

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

-- GA NAAR BOVEN EN HAK BOOM TOT ER GEEN LOGS MEER ZIJN
function harvestTree()
    while true do
        local success, block = turtle.inspectUp()
        if success and block.name:find("log") then
            turtle.digUp()
            turtle.up()
        else
            break
        end
    end
    -- terug naar grond
    while turtle.down() do end
end

-- ZET LOGS IN CHEST ONDER DE TURTLE
function storeLogs()
    for slot=2,16 do -- pak alle logs behalve saplings
        turtle.select(slot)
        if turtle.getItemCount() > 0 then
            turtle.dropDown()
        end
    end
end

-- PLANT 2x2 SAPLINGS
function plantTree()
    turtle.select(saplingSlot)
    for x = 0, 1 do
        for z = 0, 1 do
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
    -- terug naar startpositie
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

    -- Wacht 3 minuten voordat je opnieuw checkt
    sleep(180)
end
