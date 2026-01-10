-- 2x2 Spruce Mega Tree Farm (Improved)

local SAPLING_SLOT = 2
local FUEL_SLOT = 1

function refuelIfNeeded()
    if turtle.getFuelLevel() < 200 then
        turtle.select(FUEL_SLOT)
        turtle.refuel(10)
    end
end

-- Hak een blok als het er is
function digIfBlock()
    if turtle.detect() then
        turtle.dig()
    end
end

function digUpIfBlock()
    if turtle.detectUp() then
        turtle.digUp()
    end
end

function digDownIfBlock()
    if turtle.detectDown() then
        turtle.digDown()
    end
end

-- Grondvlak hakken
function clearBase()
    digIfBlock()
    turtle.forward()
    digIfBlock()
    turtle.turnRight()
    digIfBlock()
    turtle.back()
    turtle.turnLeft()
end

-- 2x2 stam omhoog hakken
function chopMegaTree()
    -- Zet turtle in hoek voor 2x2
    turtle.dig()
    turtle.forward()
    turtle.dig()
    turtle.turnRight()
    turtle.dig()
    turtle.forward()
    turtle.dig()

    local height = 0

    -- Ga omhoog en hak alles rondom mee
    while true do
        local anyBlock = false

        -- Hakken boven
        if turtle.detectUp() then
            turtle.digUp()
            anyBlock = true
        end

        -- Hakken in alle richtingen
        for i = 1, 4 do
            if turtle.detect() then
                turtle.dig()
                anyBlock = true
            end
            turtle.turnRight()
        end

        if anyBlock then
            turtle.up()
            height = height + 1
        else
            break
        end
    end

    -- Ga naar beneden
    for i = 1, height do
        turtle.down()
    end

    -- Ga terug naar startpositie
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
    turtle.forward()
    turtle.turnLeft()
end

-- Plant 2x2 spruce
function plant2x2()
    turtle.select(SAPLING_SLOT)

    -- Sta op startpositie
    turtle.placeDown()
    turtle.forward()
    turtle.placeDown()
    turtle.turnRight()
    turtle.forward()
    turtle.placeDown()
    turtle.back()
    turtle.turnLeft()
    turtle.back()
end

-- Drop items in kist achter turtle
function dropInChest()
    turtle.turnAround()
    for i = 3, 16 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.turnAround()
end

-- Main loop
while true do
    refuelIfNeeded()
    print("Wachten op groei...")
    while not turtle.detect() do
        sleep(10)
    end

    print("Hak boom...")
    chopMegaTree()
    print("Plant saplings...")
    plant2x2()
    print("Leeg inventaris...")
    dropInChest()
    print("Klaar! Wacht tot volgende groei.")
    sleep(60)
end

