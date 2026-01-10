-- 2x2 Spruce Mega Tree Farm Turtle

local SAPLING_SLOT = 2
local FUEL_SLOT = 1

function refuelIfNeeded()
    if turtle.getFuelLevel() < 200 then
        turtle.select(FUEL_SLOT)
        turtle.refuel(10)
    end
end

function waitForTree()
    print("Wachten op boom...")
    while not turtle.detect() do
        sleep(10)
    end
end

function clearLeaves()
    for i = 1, 4 do
        turtle.dig()
        turtle.turnRight()
    end
end

function chopTrunkUp()
    local height = 0

    while turtle.detectUp() do
        turtle.digUp()
        turtle.up()
        height = height + 1

        -- Hak rondom voor dikke stam
        for i = 1, 4 do
            turtle.dig()
            turtle.turnRight()
        end
    end

    return height
end

function goDown(height)
    for i = 1, height do
        turtle.down()
    end
end

function chopMegaTree()
    print("Boom hakken...")

    turtle.dig()
    turtle.forward()

    -- Positioneer op 2x2 stam
    turtle.dig()
    turtle.turnRight()
    turtle.forward()

    local height = chopTrunkUp()

    goDown(height)

    -- Terug naar startpositie
    turtle.back()
    turtle.turnLeft()
    turtle.back()
end

function plant2x2()
    print("Saplings planten...")

    turtle.select(SAPLING_SLOT)

    -- Plant 4 saplings in vierkant
    for i = 1, 2 do
        for j = 1, 2 do
            turtle.placeDown()
            if j == 1 then turtle.forward() end
        end
        turtle.back()
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
    end

    -- Terug naar startpositie
    turtle.turnLeft()
    turtle.back()
    turtle.turnRight()
end

function dropInChest()
    -- Als je een kist ACHTER de turtle zet:
    turtle.turnAround()
    for i = 3, 16 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.turnAround()
end

while true do
    refuelIfNeeded()
    waitForTree()
    chopMegaTree()
    plant2x2()
    dropInChest()
    print("Wachten tot boom groeit...")
    sleep(60)
end
