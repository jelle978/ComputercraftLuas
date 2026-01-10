-- mega_tree.lua  (Verbeterde mega spray)
local SAPLING_SLOT = 2
local FUEL_SLOT = 1

function refuelIfNeeded()
    turtle.select(FUEL_SLOT)
    turtle.refuel(1)
end

function digIfBlock()
    if turtle.detect() then turtle.dig() end
end

function digUpIfBlock()
    if turtle.detectUp() then turtle.digUp() end
end

-- Slice één laag rondom
function clearLayer()
    for i = 1, 4 do
        digIfBlock()
        turtle.turnRight()
    end
end

-- Ga één blok omhoog en hak alles rondom
function chopUp()
    digUpIfBlock()
    turtle.up()
    clearLayer()
end

-- Loop omhoog zolang er hout is
function chopTree()
    local height = 0

    while true do
        clearLayer()         -- hak horizontaal
        digUpIfBlock()       -- hak boven
        if turtle.detectUp() then
            turtle.up()
            height = height + 1
        else
            break
        end
    end

    return height
end

-- Ga terug naar grond
function goDown(h)
    for i = 1, h do turtle.down() end
end

-- Plant 2×2 saplings
function plant2x2()
    turtle.select(SAPLING_SLOT)
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

-- Drop items in chest achter turtle
function dropInChest()
    turtle.turnRight()
    turtle.turnRight()
    for i=3,16 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.turnRight()
    turtle.turnRight()
end

-- Main Loop
while true do
    refuelIfNeeded()

    print("Wachten op boom...")
    while not turtle.detect() do
        sleep(5)
    end

    print("Boom hakken...")
    local h = chopTree()

    print("Terug naar grond...")
    goDown(h)

    print("Saplings planten...")
    plant2x2()

    print("Items droppen...")
    dropInChest()

    print("Klaar — wacht tot volgende boom!")
    sleep(60)
end
