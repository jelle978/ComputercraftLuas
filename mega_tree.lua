-- mega_tree_farm.lua
-- CC:Tweaked, Minecraft 1.21
-- Automatische 2x2 spruce mega tree farm

local FUEL_SLOT = 1
local SAPLING_SLOT = 2
local LOG_NAME = "minecraft:spruce_log"
local SLEEP_TIME = 20 -- seconden wachten tussen checks

-- ========== Basis bewegingen ==========
local function turnRight() turtle.turnRight() end
local function turnLeft() turtle.turnLeft() end

local function forward()
    while not turtle.forward() do
        if turtle.detect() then turtle.dig() end
        sleep(0.2)
    end
end

local function up()
    while not turtle.up() do
        if turtle.detectUp() then turtle.digUp() end
        sleep(0.2)
    end
end

local function down()
    while not turtle.down() do
        if turtle.detectDown() then turtle.digDown() end
        sleep(0.2)
    end
end

-- Refuel
local function refuelIfNeeded()
    if turtle.getFuelLevel() < 100 then
        turtle.select(FUEL_SLOT)
        turtle.refuel(1)
    end
end

-- ========== Boom detectie ==========
local function isLog()
    local success, data = turtle.inspect()
    return success and data.name == LOG_NAME
end

local function isMegaTree()
    -- Check de 2x2 blokken in front en rechts
    forward()
    local frontLeft = isLog()
    turnRight()
    local frontRight = isLog()
    turnLeft()
    back()
    return frontLeft and frontRight
end

-- ========== Boom hakken ==========
local function chopMegaTree()
    print("Boom gevonden! Hakken...")

    -- Turtle gaat naar hoek van 2x2
    turtle.dig()
    forward()
    turtle.dig()
    turnRight()
    forward()
    turtle.dig()

    local height = 0
    -- Loop omhoog
    while true do
        local anyBlock = false
        -- hak rondom (4 kanten)
        for i=1,4 do
            if turtle.detect() then turtle.dig() anyBlock=true end
            turnRight()
        end
        -- hak boven
        if turtle.detectUp() then
            turtle.digUp() anyBlock=true
        end

        if anyBlock then
            up()
            height = height + 1
        else
            break
        end
    end

    -- Terug naar grond
    for i=1,height do down() end

    -- terug naar startpositie
    turnLeft()
    forward()
    turnLeft()
    forward()

    -- Plant saplings
    turtle.select(SAPLING_SLOT)
    turtle.placeDown()
    forward()
    turtle.placeDown()
    turnRight()
    forward()
    turtle.placeDown()
    back()
    turnLeft()
    back()

    print("Boom gekapt en saplings geplant!")
end

-- ========== Wacht totdat boom groeit ==========
local function waitForGrowth()
    print("Wachten totdat boom groeit...")
    while true do
        forward()
        if isLog() then
            back()
            break
        end
        back()
        sleep(SLEEP_TIME)
    end
end

-- ========== Main loop ==========
while true do
    refuelIfNeeded()
    waitForGrowth()
    chopMegaTree()
    print("Klaar, wacht tot volgende groei...")
end
